import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Configuration schema for independent items inside the group.
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

/// The master Standard Button Group container.
class StandardButtonGroup extends StatelessWidget {
  final List<ButtonGroupItem> items;
  final double spacing;
  final MainAxisAlignment alignment; // Added alignment parameter

  const StandardButtonGroup({
    super.key,
    required this.items,
    this.spacing = 4.0,
    this.alignment = MainAxisAlignment.center, // Defaults to center alignment
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize
          .max, // Allows the Row to occupy full width to respect alignment parameters
      mainAxisAlignment: alignment, // Applied dynamic alignment parameter here
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            right: index != items.length - 1 ? spacing : 0.0,
          ),
          child: _ExpressiveGroupButton(item: items[index]),
        );
      }),
    );
  }
}

class _ExpressiveGroupButton extends StatefulWidget {
  final ButtonGroupItem item;

  const _ExpressiveGroupButton({required this.item});

  @override
  State<_ExpressiveGroupButton> createState() => _ExpressiveGroupButtonState();
}

class _ExpressiveGroupButtonState extends State<_ExpressiveGroupButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _contentKey = GlobalKey();

  double _baseContentWidth = 0.0;
  bool _isWidthCalculated = false;

  static const double _kSpringExtensionPixels = 16.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: -0.2,
      upperBound: 1.5,
    );

    if (widget.item.width != null) {
      _baseContentWidth = widget.item.width!;
      _isWidthCalculated = true;
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _measureFreshBounds());
    }
  }

  void _measureFreshBounds() {
    if (widget.item.width != null) return;

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
  void didUpdateWidget(_ExpressiveGroupButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.width != null) {
      setState(() {
        _baseContentWidth = widget.item.width!;
        _isWidthCalculated = true;
      });
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _measureFreshBounds());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fireExpressiveSpring() {
    _controller.stop();

    const springDescription = SpringDescription(
      mass: 1.0,
      stiffness: 480.0,
      damping: 17,
    );

    final springSimulation = SpringSimulation(
      springDescription,
      1.0,
      0.0,
      0.0,
    );

    _controller.animateWith(springSimulation);
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

    EdgeInsets padding;
    double minTargetWidth = 0.0;

    if (hasText && hasIcon) {
      padding = const EdgeInsets.only(left: 16.0, right: 24.0);
    } else if (hasText) {
      padding = const EdgeInsets.symmetric(horizontal: 24.0);
    } else {
      padding = const EdgeInsets.symmetric(horizontal: 11.0);
      minTargetWidth = item.width ?? 40.0;
    }

    Widget buttonContent = Padding(
      key: item.width == null ? _contentKey : null,
      padding: item.width != null ? EdgeInsets.zero : padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon) ...[
            Icon(
              item.icon,
              size: 18.0,
              color: resolvedIconColor,
            ),
            if (hasText) const SizedBox(width: 8.0),
          ],
          if (hasText)
            Flexible(
              child: DefaultTextStyle(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: resolvedFgColor,
                      fontWeight: FontWeight.w600,
                    ),
                child: item.label!,
              ),
            ),
        ],
      ),
    );

    if (minTargetWidth > 0 && item.width == null) {
      buttonContent = Container(
        constraints: BoxConstraints(minWidth: minTargetWidth),
        alignment: Alignment.center,
        child: buttonContent,
      );
    }

    if (!_isWidthCalculated) {
      return Opacity(
        opacity: 0.0,
        child: SizedBox(height: targetHeight, child: buttonContent),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double extraWidth = _kSpringExtensionPixels * _controller.value;
        final double finalDynamicWidth = _baseContentWidth + extraWidth;

        return SizedBox(
          width: finalDynamicWidth < minTargetWidth
              ? minTargetWidth
              : finalDynamicWidth,
          height: targetHeight,
          child: child,
        );
      },
      child: Material(
        color: resolvedBgColor,
        shape: resolvedShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            _fireExpressiveSpring();
            item.onPressed();
          },
          splashColor: resolvedFgColor.withOpacity(0.08),
          highlightColor: resolvedFgColor.withOpacity(0.04),
          child: Center(
            child: OverflowBox(
              minWidth: _baseContentWidth,
              maxWidth: _baseContentWidth,
              child: buttonContent,
            ),
          ),
        ),
      ),
    );
  }
}
