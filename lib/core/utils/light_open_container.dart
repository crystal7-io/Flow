import 'package:flutter/material.dart';

class LightOpenContainer<T> extends StatefulWidget {
  final Widget Function(BuildContext context, VoidCallback openContainer)
      closedBuilder;
  final Widget Function(BuildContext context, VoidCallback closeContainer)
      openBuilder;
  final void Function(T? data)? onClosed; // Added onClosed callback
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve curve;
  final Curve reverseCurve;
  final Color closedColor;
  final Color openColor;
  final bool useRootNavigator;

  const LightOpenContainer({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.onClosed,
    this.transitionDuration = Durations.long1,
    this.reverseTransitionDuration = Durations.medium1,
    this.curve = Easing.emphasizedDecelerate,
    this.reverseCurve = Easing.emphasizedAccelerate,
    this.closedColor = Colors.transparent,
    this.openColor = Colors.transparent,
    this.useRootNavigator = false,
  });

  @override
  State<LightOpenContainer<T>> createState() => _LightOpenContainerState<T>();
}

class _LightOpenContainerState<T> extends State<LightOpenContainer<T>> {
  final GlobalKey _key = GlobalKey();

  // Changed to async to handle the route result
  Future<void> _open() async {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Rect initialRect =
        renderBox.localToGlobal(Offset.zero) & renderBox.size;

    final T? result =
        await Navigator.of(context, rootNavigator: widget.useRootNavigator)
            .push<T>(
      _LightContainerRoute<T>(
        initialRect: initialRect,
        openBuilder: widget.openBuilder,
        transitionDuration: widget.transitionDuration,
        reverseTransitionDuration: widget.reverseTransitionDuration,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
        closedColor: widget.closedColor,
        openColor: widget.openColor,
        useRootNavigator: widget.useRootNavigator,
      ),
    );

    // Trigger onClosed when the navigator pops
    if (widget.onClosed != null) {
      widget.onClosed!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.closedBuilder(context, _open),
    );
  }
}

class _LightContainerRoute<T> extends PageRouteBuilder<T> {
  final Rect initialRect;
  final Widget Function(BuildContext, VoidCallback) openBuilder;
  final Curve curve;
  final Curve reverseCurve;
  final Color closedColor;
  final Color openColor;
  final bool useRootNavigator;

  _LightContainerRoute({
    required this.initialRect,
    required this.openBuilder,
    required super.transitionDuration,
    required super.reverseTransitionDuration,
    required this.curve,
    required this.reverseCurve,
    required this.closedColor,
    required this.openColor,
    required this.useRootNavigator,
  }) : super(
          pageBuilder: (context, _, __) => const SizedBox.shrink(),
        );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // Allows passing a result back via Navigator.of(context).pop(someData)
    return openBuilder(
      context,
      () => Navigator.of(context, rootNavigator: useRootNavigator).pop(),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final Rect targetRect = Offset.zero & constraints.biggest;
        final Rect currentRect =
            Rect.lerp(initialRect, targetRect, curvedAnimation.value)!;

        final double fadeOutValue =
            (1.0 - (curvedAnimation.value * 5.0)).clamp(0.0, 1.0);
        final double fadeInValue =
            ((curvedAnimation.value - 0.2) * 1.25).clamp(0.0, 1.0);

        return Stack(
          children: [
            Positioned.fromRect(
              rect: currentRect,
              child: Container(
                color:
                    Color.lerp(closedColor, openColor, curvedAnimation.value),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (fadeOutValue > 0)
                      Opacity(
                        opacity: fadeOutValue,
                        child: const SizedBox.shrink(),
                      ),
                    if (fadeInValue > 0)
                      Opacity(
                        opacity: fadeInValue,
                        child: child,
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
