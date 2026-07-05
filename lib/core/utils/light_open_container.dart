import 'package:flutter/material.dart';

class CustomOpenContainer extends StatefulWidget {
  final Widget Function(BuildContext context, VoidCallback open, bool visible) closedBuilder;
  final WidgetBuilder openBuilder;
  final VoidCallback? onClosed;
  final Color closedColor;

  // Custom Animation Parameters
  final Curve curve;
  final Curve reverseCurve;
  final Duration duration;
  final Duration reverseDuration;

  const CustomOpenContainer({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.onClosed,
    required this.closedColor,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.reverseCurve = Easing.emphasizedAccelerate,
    this.duration = const Duration(milliseconds: 450),
    this.reverseDuration = const Duration(milliseconds: 350),
  });

  @override
  State<CustomOpenContainer> createState() => _CustomOpenContainerState();
}

class _CustomOpenContainerState extends State<CustomOpenContainer> {
  final GlobalKey _containerKey = GlobalKey();
  bool _visible = true;

  void _openView() async {
    final RenderBox? renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final Rect initialRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    setState(() => _visible = false);

    await Navigator.of(context).push(
      _OpenContainerRoute(
        containerKey: _containerKey,
        initialRect: initialRect,
        closedColor: widget.closedColor,
        closedBuilder: widget.closedBuilder,
        openBuilder: widget.openBuilder,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
        duration: widget.duration,
        reverseDuration: widget.reverseDuration,
      ),
    );

    if (mounted) {
      setState(() => _visible = true);
      widget.onClosed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _containerKey, child: widget.closedBuilder(context, _openView, _visible));
  }
}

class _OpenContainerRoute extends PageRouteBuilder {
  final GlobalKey containerKey;
  final Rect initialRect;
  final Color closedColor;
  final Widget Function(BuildContext context, VoidCallback open, bool visible) closedBuilder;
  final WidgetBuilder openBuilder;
  final Curve curve;
  final Curve reverseCurve;

  _OpenContainerRoute({
    required this.containerKey,
    required this.initialRect,
    required this.closedColor,
    required this.closedBuilder,
    required this.openBuilder,
    required this.curve,
    required this.reverseCurve,
    required Duration duration,
    required Duration reverseDuration,
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: reverseDuration,
         opaque: false,
         barrierDismissible: false,
         pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
       );

  @override
  Widget buildPage(BuildContext context, Animation<double> anim, Animation<double> secAnim) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    // Determine direction: Is the user closing the view?
    final bool isReversing = animation.status == AnimationStatus.reverse;

    // 1. Controls closedBuilder (the list item)
    final Animation<double> exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          isReversing ? 0.15 : 0.0, // When closing, it finishes fading in at 60% remaining progress
          isReversing ? 0.75 : 0.1, // When closing, it starts fading in at 85% progress
        ),
      ),
    );

    // 2. Controls openBuilder (the full chat screen)
    final Animation<double> enterOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          isReversing ? 0.0 : 0.15,
          isReversing
              ? 0.1
              : 0.75, // When closing, it drops to 0% opacity extremely fast (between 1.0 -> 0.85)
        ),
      ),
    );

    if (animation.isCompleted) {
      return openBuilder(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final Rect targetRect = Offset.zero & constraints.biggest;
        final Rect currentRect = Rect.lerp(initialRect, targetRect, curvedAnimation.value)!;

        final ShapeBorder currentShape = ShapeBorder.lerp(
          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          curvedAnimation.value,
        )!;

        // Determine the absolute direction to toggle structural gates
        final bool isReversing = animation.status == AnimationStatus.reverse;

        return Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: curvedAnimation,
              child: Container(color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.85)),
            ),

            Positioned.fromRect(
              rect: currentRect,
              child: Material(
                clipBehavior: Clip.antiAlias,
                animationDuration: Duration.zero,
                shape: currentShape,
                color: Color.lerp(
                  closedColor,
                  Theme.of(context).colorScheme.surface,
                  curvedAnimation.value,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Gated Closed Builder: Discarded as soon as we transition past the threshold
                    if (isReversing ? animation.value < 0.85 : animation.value < 0.25)
                      if (exitOpacity.value > 0.0)
                        Opacity(
                          opacity: exitOpacity.value,
                          child: OverflowBox(
                            alignment: Alignment.topLeft,
                            minWidth: initialRect.width,
                            maxWidth: initialRect.width,
                            minHeight: initialRect.height,
                            maxHeight: initialRect.height,
                            child: closedBuilder(context, () {}, true),
                          ),
                        ),

                    // 2. Gated Open Builder: Only mounted when the closed builder is completely gone
                    if (isReversing ? animation.value >= 0.85 : animation.value >= 0.25)
                      if (enterOpacity.value > 0.0)
                        Opacity(
                          opacity: enterOpacity.value,
                          child: OverflowBox(
                            alignment: Alignment.topLeft,
                            minWidth: targetRect.width,
                            maxWidth: targetRect.width,
                            minHeight: targetRect.height,
                            maxHeight: targetRect.height,
                            child: openBuilder(context),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
