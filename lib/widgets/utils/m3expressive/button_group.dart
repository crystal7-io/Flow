import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:redesigned/core/utils/expressive_physics.dart';

/// Configuration schema for an individual button within a [StandardButtonGroup].
///
/// Holds layout bounds, styling, icons, text, and operational hooks.
class ButtonGroupItem {
  final Widget? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool roundBorder;

  const ButtonGroupItem({
    this.label,
    this.icon,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.roundBorder = true,
  }) : assert(label != null || icon != null, 'An item must contain at least a label or an icon.');
}

/// A highly expressive row-bound button cluster utilizing spring physics
/// to scale items reactively on user interaction.
class StandardButtonGroup extends StatefulWidget {
  final List<ButtonGroupItem> items;
  final double spacing;
  final bool expandEqually;
  final MainAxisAlignment alignment;

  const StandardButtonGroup({
    super.key,
    required this.items,
    this.spacing = 8.0,
    this.expandEqually = false,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  State<StandardButtonGroup> createState() => _StandardButtonGroupState();
}

class _StandardButtonGroupState extends State<StandardButtonGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _activeIndex = -1;
  DateTime? _tapStartTime;
  bool _isReleasePending = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this, value: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers a high-velocity forward spring transformation when a button is pressed down.
  void _handleTapDown(int index) {
    setState(() {
      _activeIndex = index;
      _isReleasePending = false;
      _tapStartTime = DateTime.now();
    });

    final simulation = SpringSimulation(
      ExpressiveMotionSpring.fastSpatial,
      _controller.value,
      1.0,
      24.0,
    );
    _controller.animateWith(simulation);
  }

  /// Manages release events, preserving frame runtime to ensure Android touch
  /// interactions capture visual expansion states.
  void _handleTapRelease({required bool executeClick}) {
    if (_activeIndex == -1) return;

    if (executeClick) {
      widget.items[_activeIndex].onPressed();
    }

    _isReleasePending = true;
    final elapsed = DateTime.now().difference(_tapStartTime ?? DateTime.now());
    final remainingDelay = const Duration(milliseconds: 60) - elapsed;

    if (remainingDelay.isNegative) {
      _startRetractSimulation();
    } else {
      Future.delayed(remainingDelay, () {
        if (mounted && _isReleasePending) {
          _startRetractSimulation();
        }
      });
    }
  }

  /// Reverses the active physics simulation to gracefully snap components back to resting size bounds.
  void _startRetractSimulation() {
    _isReleasePending = false;

    final simulation = SpringSimulation(
      ExpressiveMotionSpring.fastSpatial,
      _controller.value,
      0.0,
      _controller.velocity,
    );

    _controller.animateWith(simulation).orCancel.then((_) {
      if (mounted && _controller.value == 0.0 && !_isReleasePending) {
        setState(() => _activeIndex = -1);
      }
    }, onError: (_) {});
  }

  /// Computes geometric scale adjustments across adjacent nodes to preserve visual conservation of mass.
  double _getDeltaForIndex(int index, double maxStretch) {
    if (_activeIndex == -1) return 0.0;
    final int n = widget.items.length;
    final double currentStretch = maxStretch * _controller.value;

    if (index == _activeIndex) return currentStretch;
    if (index == _activeIndex - 1) {
      return (_activeIndex == n - 1) ? -currentStretch : -currentStretch / 2.0;
    }
    if (index == _activeIndex + 1) {
      return (_activeIndex == 0) ? -currentStretch : -currentStretch / 2.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: widget.alignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final double deltaWidth = _getDeltaForIndex(index, 12.0);
            final double deltaFlex = _getDeltaForIndex(index, 175.0);

            final buttonWidget = Padding(
              padding: EdgeInsets.only(
                right: index != widget.items.length - 1 ? widget.spacing : 0.0,
              ),
              child: _ExpressiveGroupButton(
                item: item,
                deltaWidth: deltaWidth,
                expandEqually: widget.expandEqually,
                onTapDown: () => _handleTapDown(index),
                onTap: () => _handleTapRelease(executeClick: true),
                onTapCancel: () => _handleTapRelease(executeClick: false),
              ),
            );

            if (widget.expandEqually) {
              return Expanded(flex: (1000 + deltaFlex).toInt(), child: buttonWidget);
            }

            return buttonWidget;
          }),
        );
      },
    );
  }
}

/// An unexposed, atomized layout node that applies structural styling metrics and captures sub-pixel boundaries.
class _ExpressiveGroupButton extends StatefulWidget {
  final ButtonGroupItem item;
  final double deltaWidth;
  final bool expandEqually;
  final VoidCallback onTapDown;
  final VoidCallback onTap;
  final VoidCallback onTapCancel;

  const _ExpressiveGroupButton({
    required this.item,
    required this.deltaWidth,
    required this.expandEqually,
    required this.onTapDown,
    required this.onTap,
    required this.onTapCancel,
  });

  @override
  State<_ExpressiveGroupButton> createState() => _ExpressiveGroupButtonState();
}

class _ExpressiveGroupButtonState extends State<_ExpressiveGroupButton> {
  final GlobalKey _contentKey = GlobalKey();
  double _baseContentWidth = 0.0;
  bool _isWidthCalculated = false;

  @override
  void initState() {
    super.initState();
    if (widget.expandEqually) {
      _isWidthCalculated = true;
    } else if (widget.item.width != null) {
      _baseContentWidth = widget.item.width!;
      _isWidthCalculated = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureFreshBounds());
    }
  }

  /// Executes a zero-latency offscreen baseline measurement to prevent layout thrashing on variable text string nodes.
  void _measureFreshBounds() {
    if (widget.item.width != null || widget.expandEqually) return;

    final renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _baseContentWidth = renderBox.size.width;
        _isWidthCalculated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final hasText = item.label != null;
    final hasIcon = item.icon != null;
    final targetHeight = item.height ?? 40.0;

    final resolvedBgColor =
        item.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHigh;
    final resolvedFgColor = item.foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    final resolvedIconColor =
        item.foregroundColor ?? Theme.of(context).colorScheme.onSurfaceVariant;

    final ShapeBorder resolvedShape = item.roundBorder
        ? const StadiumBorder()
        : const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)));

    final EdgeInsets basePadding = hasText && hasIcon
        ? const EdgeInsets.only(left: 16.0, right: 24.0)
        : hasText
        ? const EdgeInsets.symmetric(horizontal: 24.0)
        : const EdgeInsets.symmetric(horizontal: 11.0);

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasIcon) ...[
          Icon(item.icon, size: 18.0, color: resolvedIconColor, weight: 700),
          if (hasText) const SizedBox(width: 8.0),
        ],
        if (hasText)
          Text(
            (item.label as Text).data ?? '',
            style: Theme.of(context).textTheme.labelLarge!
                .copyWith(color: resolvedFgColor, fontWeight: FontWeight.w600)
                .merge((item.label as Text).style),
          ),
      ],
    );

    if (!_isWidthCalculated) {
      return Opacity(
        opacity: 0.0,
        child: SizedBox(
          height: targetHeight,
          child: Padding(key: _contentKey, padding: basePadding, child: buttonContent),
        ),
      );
    }

    return SizedBox(
      width: widget.expandEqually ? null : (_baseContentWidth + widget.deltaWidth),
      height: targetHeight,
      child: Material(
        color: resolvedBgColor,
        shape: resolvedShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTapDown: (_) => widget.onTapDown(),
          onTap: widget.onTap,
          onTapCancel: widget.onTapCancel,
          child: Center(
            child: OverflowBox(
              maxWidth: double.infinity,
              maxHeight: targetHeight,
              alignment: Alignment.center,
              child: Padding(padding: basePadding, child: buttonContent),
            ),
          ),
        ),
      ),
    );
  }
}
