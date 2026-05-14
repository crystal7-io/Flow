import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class ExpressiveButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final String? text;
  final bool persistText;
  final double height;
  final TextStyle? textStyle;
  final Color? selectedBg;
  final Color? unselectedBg;
  final Color? selectedContent;
  final Color? unselectedContent;

  const ExpressiveButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.text,
    this.persistText = false,
    this.height = 56.0,
    this.textStyle,
    this.selectedBg,
    this.unselectedBg,
    this.selectedContent,
    this.unselectedContent,
  });

  @override
  State<ExpressiveButton> createState() => _ExpressiveButtonState();
}

class _ExpressiveButtonState extends State<ExpressiveButton>
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
  void didUpdateWidget(ExpressiveButton oldWidget) {
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

          return Container(
            height: widget.height,
            padding: EdgeInsets.symmetric(
              // The horizontal padding "bounces", physically pushing neighbors
              horizontal: 16.0 + (t * 6.0),
            ),
            constraints: BoxConstraints(
              // The minWidth overshoots, creating the "catchy" bounce effect
              minWidth: widget.height + (t * 40.0),
            ),
            decoration: BoxDecoration(
              color: Color.lerp(bgUnselected, bgSelected, clampedT),
              borderRadius: BorderRadius.circular(
                clampedT > 0.5 ? 14 : widget.height / 2,
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
                    color: Color.lerp(
                        contentUnselected, contentSelected, clampedT),
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
                          left:
                              (widget.persistText || clampedT > 0.1) ? 8.0 : 0,
                        ),
                        child: Text(
                          widget.text!,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style:
                              (widget.textStyle ?? theme.textTheme.labelLarge)!
                                  .copyWith(
                            color: Color.lerp(
                                contentUnselected, contentSelected, clampedT),
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
