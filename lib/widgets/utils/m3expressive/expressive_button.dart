import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

enum SpringDirection { horizontal, vertical }

class ExpressiveSpringButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final String? text;
  final bool persistText;
  final double selectedLength;
  final double unselectedLength;
  final double thickness;
  final SpringDirection direction;
  final TextStyle? textStyle;
  final Color? selectedBg;
  final Color? unselectedBg;
  final Color? selectedContent;
  final Color? unselectedContent;
  final bool keepRound;

  const ExpressiveSpringButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.text,
    this.persistText = false,
    this.keepRound = false,
    double? height,
    double? selectedLength,
    double? unselectedLength,
    this.direction = SpringDirection.horizontal,
    this.textStyle,
    this.selectedBg,
    this.unselectedBg,
    this.selectedContent,
    this.unselectedContent,
  }) : thickness = height ?? 56.0,
       unselectedLength = unselectedLength ?? 42.0,
       selectedLength = selectedLength ?? (unselectedLength ?? 42) + 12.0;

  @override
  State<ExpressiveSpringButton> createState() => _ExpressiveSpringButtonState();
}

class _ExpressiveSpringButtonState extends State<ExpressiveSpringButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // upperBound > 1.0 is the secret to the "overshoot" bounce
    _controller = AnimationController(vsync: this, upperBound: 1.5);
    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ExpressiveSpringButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      _runSpring(widget.isSelected ? 1.0 : 0.0);
    }
  }

  void _runSpring(double target) {
    final simulation = SpringSimulation(
      const SpringDescription(
        mass: 1.2,
        stiffness: 1000, // Higher stiffness for a faster, "snappier" start
        damping:
            25, // High damping prevents multiple wiggles (the "bounce once" feel)
      ),
      _controller.value,
      target,
      0,
    );
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fallback colors from your original logic
    final bgSelected = widget.selectedBg ?? theme.colorScheme.primary;
    final bgUnselected =
        widget.unselectedBg ?? theme.colorScheme.surfaceContainerHigh;
    final contentSelected =
        widget.selectedContent ?? theme.colorScheme.onPrimary;
    final contentUnselected =
        widget.unselectedContent ?? theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          // Clamp t for color/radius lerping so they don't "break" during overshoot
          final clampedT = t.clamp(0.0, 1.0);

          final currentLength =
              widget.unselectedLength +
              (t * (widget.selectedLength - widget.unselectedLength));

          return Container(
            height: widget.direction == SpringDirection.horizontal
                ? widget.thickness
                : null,
            width: widget.direction == SpringDirection.vertical
                ? widget.thickness
                : null,
            padding: EdgeInsets.only(
              left: widget.direction == SpringDirection.horizontal
                  ? currentLength / 2
                  : 12.0,
              right:
                  (widget.direction == SpringDirection.horizontal
                      ? currentLength / 2
                      : 12.0) +
                  6,
              top: widget.direction == SpringDirection.vertical
                  ? currentLength / 2
                  : 0.0,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected ? bgSelected : bgUnselected,
              borderRadius: BorderRadius.circular(
                (clampedT > 0.5 && !widget.keepRound)
                    ? 14
                    : widget.thickness / 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Icon(
                    weight: 600,
                    widget.icon,
                    color: widget.isSelected
                        ? contentSelected
                        : contentUnselected,
                    size: 24,
                  ),
                // Text expansion logic
                if (widget.text != null)
                  ClipRect(
                    child: Align(
                      widthFactor: widget.persistText ? 1.0 : clampedT,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: (widget.persistText || clampedT > 0.1)
                              ? 8.0
                              : 0,
                        ),
                        child: Text(
                          widget.text!,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style:
                              (widget.textStyle ?? theme.textTheme.labelLarge)!
                                  .copyWith(
                                    color: widget.isSelected
                                        ? contentSelected
                                        : contentUnselected,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExpressiveSpringIconButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final double selectedLength;
  final double unselectedLength;
  final SpringDirection direction;
  final Color? selectedBg;
  final Color? unselectedBg;
  final Color? selectedContent;
  final Color? unselectedContent;
  final bool keepRound;

  const ExpressiveSpringIconButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    this.selectedLength = 64.0,
    this.unselectedLength = 56.0,
    this.direction = SpringDirection.horizontal,
    this.selectedBg,
    this.unselectedBg,
    this.selectedContent,
    this.unselectedContent,
    this.keepRound = false,
  });

  @override
  State<ExpressiveSpringIconButton> createState() =>
      _ExpressiveSpringIconButtonState();
}

class _ExpressiveSpringIconButtonState extends State<ExpressiveSpringIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, upperBound: 1.5);
    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ExpressiveSpringIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      _runSpring(widget.isSelected ? 1.0 : 0.0);
    }
  }

  void _runSpring(double target) {
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1.2, stiffness: 1000, damping: 25),
      _controller.value,
      target,
      0,
    );
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgSelected = widget.selectedBg ?? theme.colorScheme.primary;
    final bgUnselected =
        widget.unselectedBg ?? theme.colorScheme.surfaceContainerHigh;
    final contentSelected =
        widget.selectedContent ?? theme.colorScheme.onPrimary;
    final contentUnselected =
        widget.unselectedContent ?? theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final clampedT = t.clamp(0.0, 1.0);

          final currentLength =
              widget.unselectedLength +
              (t * (widget.selectedLength - widget.unselectedLength));

          final width = widget.direction == SpringDirection.horizontal
              ? currentLength
              : widget.unselectedLength;
          final height = widget.direction == SpringDirection.vertical
              ? currentLength
              : widget.unselectedLength;

          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Color.lerp(bgUnselected, bgSelected, clampedT),
              borderRadius: BorderRadius.circular(
                (clampedT > 0.5 && !widget.keepRound)
                    ? 16
                    : widget.unselectedLength / 2,
              ),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                color: Color.lerp(contentUnselected, contentSelected, clampedT),
                size: (widget.unselectedLength * 0.45) + (t * 2.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExpressiveButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final String? text;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedContentColor;
  final Color? unselectedContentColor;
  final double thickness;
  final Duration duration;

  const ExpressiveButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.text,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedContentColor,
    this.unselectedContentColor,
    this.thickness = 48.0,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<ExpressiveButton> createState() => _ExpressiveButtonState();
}

class _ExpressiveButtonState extends State<ExpressiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: Durations.short3,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Easing.standard,
      reverseCurve: Easing.standard,
    );
    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ExpressiveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgSelected =
        widget.selectedBackgroundColor ?? theme.colorScheme.primary;
    final bgUnselected =
        widget.unselectedBackgroundColor ??
        theme.colorScheme.surfaceContainerHigh;
    final contentSelected =
        widget.selectedContentColor ?? theme.colorScheme.onPrimary;
    final contentUnselected =
        widget.unselectedContentColor ?? theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final t = _animation.value;

          return Container(
            height: widget.thickness,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color.lerp(bgUnselected, bgSelected, t),
              borderRadius: BorderRadius.lerp(
                BorderRadius.circular(widget.thickness / 2),
                BorderRadius.circular(12),
                t,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: Color.lerp(contentUnselected, contentSelected, t),
                    size: 20,
                  ),
                if (widget.icon != null && widget.text != null)
                  const SizedBox(width: 8),
                if (widget.text != null)
                  Text(
                    widget.text!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Color.lerp(contentUnselected, contentSelected, t),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
