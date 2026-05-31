import 'dart:ui';
import 'package:flutter/material.dart';

Future<T?> showExpressiveDialog<T>({
  required BuildContext context,
  required Widget child,
}) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder<T>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _ExpressiveDialogTransition(
          animation: animation,
          child: child,
        );
      },
    ),
  );
}

class _ExpressiveDialogTransition extends StatelessWidget {
  const _ExpressiveDialogTransition({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double value = animation.value;

        final double opacity = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.4, curve: Easing.emphasizedDecelerate),
        ).value;

        final double translateProgress =
            Easing.emphasizedDecelerate.transform(value);
        final double translateY = -150.0 * (1.0 - translateProgress);

        final double blurProgress =
            Easing.emphasizedDecelerate.transform(value);
        final double currentBlur = blurProgress * 4.0;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: currentBlur, sigmaY: currentBlur),
          child: Material(
            color: Colors.black.withOpacity(opacity * 0.45),
            child: Transform.translate(
              offset: Offset(0.0, translateY),
              child: Opacity(
                opacity: opacity,
                child: Dialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 24.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(28.0)),
                    child: IntrinsicHeight(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: value,
                        child: OverflowBox(
                          alignment: Alignment.topCenter,
                          minHeight: 0,
                          maxHeight: double.infinity,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}
