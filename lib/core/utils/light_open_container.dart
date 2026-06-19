import 'package:flutter/material.dart';

class LightOpenContainer<T> extends StatefulWidget {
  final Widget Function(BuildContext context, VoidCallback openContainer) closedBuilder;
  final Widget Function(BuildContext context, VoidCallback closeContainer) openBuilder;
  final void Function(T? data)? onClosed;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve curve;
  final Curve reverseCurve;

  // Custom Color & Shape parameters
  final Color closedColor;
  final Color openColor;
  final ShapeBorder closedShape;
  final ShapeBorder openShape;
  final bool useRootNavigator;

  const LightOpenContainer({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.onClosed,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubicEmphasized,
    this.reverseCurve = Easing.emphasizedAccelerate,
    this.closedColor = Colors.transparent,
    this.openColor = Colors.transparent,
    // Defaults: Rounded tile shape transitioning to full screen sharp edge
    this.closedShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.openShape = const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    this.useRootNavigator = false,
  });

  @override
  State<LightOpenContainer<T>> createState() => _LightOpenContainerState<T>();
}

class _LightOpenContainerState<T> extends State<LightOpenContainer<T>> {
  final GlobalKey _key = GlobalKey();

  Future<void> _open() async {
    final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final Rect initialRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    final T? result = await Navigator.of(context, rootNavigator: widget.useRootNavigator).push<T>(
      _LightContainerRoute<T>(
        initialRect: initialRect,
        closedBuilder: widget.closedBuilder,
        openBuilder: widget.openBuilder,
        transitionDuration: widget.transitionDuration,
        reverseTransitionDuration: widget.reverseTransitionDuration,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
        closedColor: widget.closedColor,
        openColor: widget.openColor,
        closedShape: widget.closedShape,
        openShape: widget.openShape,
        useRootNavigator: widget.useRootNavigator,
      ),
    );

    if (widget.onClosed != null) {
      widget.onClosed!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.closedBuilder(context, _open));
  }
}

class _LightContainerRoute<T> extends PageRouteBuilder<T> {
  final Rect initialRect;
  final Widget Function(BuildContext, VoidCallback) closedBuilder;
  final Widget Function(BuildContext, VoidCallback) openBuilder;
  final Curve curve;
  final Curve reverseCurve;
  final Color closedColor;
  final Color openColor;
  final ShapeBorder closedShape;
  final ShapeBorder openShape;
  final bool useRootNavigator;

  _LightContainerRoute({
    required this.initialRect,
    required this.closedBuilder,
    required this.openBuilder,
    required super.transitionDuration,
    required super.reverseTransitionDuration,
    required this.curve,
    required this.reverseCurve,
    required this.closedColor,
    required this.openColor,
    required this.closedShape,
    required this.openShape,
    required this.useRootNavigator,
  }) : super(
         opaque: false,
         barrierColor: Colors.transparent,
         pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
       );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final CurvedAnimation geometricAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    // --- SEPARATED ENTRY/EXIT INTERVALS ---

    // Closed Element:
    // Forward: Fades out in first 20% (0.0 -> 0.2)
    // Reverse: Fades back in at last 30% of the close time (0.7 -> 1.0 map on exit countdown)
    final Animation<double> closedOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.2, curve: Curves.fastOutSlowIn),
        reverseCurve: const Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    // Open Element:
    // Forward: Fades in starting at 40% (0.4 -> 1.0)
    // Reverse: Vanishes completely within first 10% of exit time (0.9 -> 1.0 map on exit countdown)
    final Animation<double> openOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.40, 1.0, curve: Curves.fastOutSlowIn),
        reverseCurve: const Interval(0.90, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    final VoidCallback popAction = () =>
        Navigator.of(context, rootNavigator: useRootNavigator).pop();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final Rect targetRect = Offset.zero & constraints.biggest;
            final Rect currentRect = Rect.lerp(initialRect, targetRect, geometricAnimation.value)!;

            final ShapeBorder currentShape = ShapeBorder.lerp(
              closedShape,
              openShape,
              geometricAnimation.value,
            )!;

            return Stack(
              children: [
                Positioned.fromRect(
                  rect: currentRect,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color.lerp(closedColor, openColor, geometricAnimation.value),
                      shape: currentShape,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (closedOpacity.value > 0.0)
                          FadeTransition(
                            opacity: closedOpacity,
                            child: closedBuilder(context, () {}),
                          ),
                        if (openOpacity.value > 0.0)
                          FadeTransition(
                            opacity: openOpacity,
                            child: openBuilder(context, popAction),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
