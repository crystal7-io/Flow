import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:redesigned/core/utils/expressive_physics.dart';

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
  }) : assert(label != null || icon != null,
            'An item must contain at least a label or an icon.');
}

class StandardButtonGroup extends StatefulWidget {
  final List<ButtonGroupItem> items;
  final double spacing;
  final MainAxisAlignment alignment;
  final bool expandEqually;

  const StandardButtonGroup({
    super.key,
    required this.items,
    this.spacing = 4.0,
    this.alignment = MainAxisAlignment.center,
    this.expandEqually = false,
  });

  @override
  State<StandardButtonGroup> createState() => _StandardButtonGroupState();
}

class _StandardButtonGroupState extends State<StandardButtonGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _activeIndex = -1;

  @override
  void initState() {
    super.initState();
    // A single controller orchestrates the entire row's layout math
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 2.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress(int index) {
    setState(() {
      _activeIndex = index;
    });

    _controller.stop();
    final springSimulation = SpringSimulation(
      ExpressivePhysics.expressiveFastSpatial,
      0.0,
      0.0,
      22.0,
    );

    _controller.animateWith(springSimulation);
    widget.items[index].onPressed();
  }

  /// Calculates exact pixel distribution so only immediate neighbors squash.
  /// Net total width change across the row is always exactly 0.0.
  double _getDeltaForIndex(int index, double maxStretch) {
    if (_activeIndex == -1) return 0.0;

    final int n = widget.items.length;
    final double currentStretch = maxStretch * _controller.value;

    if (index == _activeIndex) {
      return currentStretch; // Active button grows
    }

    if (index == _activeIndex - 1) {
      // If active is the very last item, this single neighbor absorbs all compression
      return (_activeIndex == n - 1) ? -currentStretch : -currentStretch / 2.0;
    }

    if (index == _activeIndex + 1) {
      // If active is the very first item, this single neighbor absorbs all compression
      return (_activeIndex == 0) ? -currentStretch : -currentStretch / 2.0;
    }

    return 0.0; // Distant buttons are completely unaffected
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

            // Calculate math for both modes in real-time
            final double deltaWidth = _getDeltaForIndex(index, 24.0);
            final double deltaFlex = _getDeltaForIndex(index, 350.0);

            final buttonWidget = Padding(
              padding: EdgeInsets.only(
                right: index != widget.items.length - 1 ? widget.spacing : 0.0,
              ),
              child: _ExpressiveGroupButton(
                item: item,
                deltaWidth: deltaWidth,
                onPressed: () => _handlePress(index),
                expandEqually: widget.expandEqually,
              ),
            );

            if (widget.expandEqually) {
              return Expanded(
                flex: (1000 + deltaFlex).toInt(),
                child: buttonWidget,
              );
            }

            return buttonWidget;
          }),
        );
      },
    );
  }
}

class _ExpressiveGroupButton extends StatefulWidget {
  final ButtonGroupItem item;
  final double deltaWidth;
  final VoidCallback onPressed;
  final bool expandEqually;

  const _ExpressiveGroupButton({
    required this.item,
    required this.deltaWidth,
    required this.onPressed,
    required this.expandEqually,
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
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _measureFreshBounds());
    }
  }

  void _measureFreshBounds() {
    if (widget.item.width != null || widget.expandEqually) return;

    final renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
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

    final resolvedBgColor = item.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHigh;
    final resolvedFgColor =
        item.foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    final resolvedIconColor =
        item.foregroundColor ?? Theme.of(context).colorScheme.onSurfaceVariant;

    final ShapeBorder resolvedShape = item.roundBorder
        ? const StadiumBorder()
        : const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          );

    EdgeInsets basePadding;
    if (hasText && hasIcon) {
      basePadding = const EdgeInsets.only(left: 16.0, right: 24.0);
    } else if (hasText) {
      basePadding = const EdgeInsets.symmetric(horizontal: 24.0);
    } else {
      basePadding = const EdgeInsets.symmetric(horizontal: 11.0);
    }

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasIcon) ...[
          Icon(
            item.icon,
            size: 18.0,
            color: resolvedIconColor,
            weight: 700,
          ),
          if (hasText) const SizedBox(width: 8.0),
        ],
        if (hasText)
          Text(
            (item.label as Text).data ?? '', // Assuming label is a Text widget
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: resolvedFgColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
      ],
    );

    if (!_isWidthCalculated) {
      // Invisible render pass to extract exact native pixel width
      return Opacity(
        opacity: 0.0,
        child: SizedBox(
          height: targetHeight,
          child: Padding(
            key: _contentKey,
            padding: basePadding,
            child: buttonContent,
          ),
        ),
      );
    }

    return SizedBox(
      width:
          widget.expandEqually ? null : (_baseContentWidth + widget.deltaWidth),
      height: targetHeight,
      child: Material(
        color: resolvedBgColor,
        shape: resolvedShape,
        clipBehavior: Clip.antiAlias, // Ensures cleanly masked squashing
        child: InkWell(
          onTap: widget.onPressed,
          splashColor: resolvedFgColor.withOpacity(0.08),
          highlightColor: resolvedFgColor.withOpacity(0.04),
          child: Center(
            // OverflowBox provides infinite internal layout bounds.
            // This prevents the text from wrapping or throwing NaN errors when the neighbor buttons compress smaller than their base width!
            child: OverflowBox(
              maxWidth: double.infinity,
              maxHeight: targetHeight,
              alignment: Alignment.center,
              child: Padding(
                padding: basePadding,
                child: buttonContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
