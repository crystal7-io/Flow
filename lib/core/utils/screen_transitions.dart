import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/navigation/create_post_transition_provider.dart';

class SlideTransitionPage extends CustomTransitionPage {
  final GoRouterState state;
  SlideTransitionPage({required super.child, required this.state})
      : super(
            key: state.pageKey,
            transitionDuration: Durations.long1,
            reverseTransitionDuration: Durations.medium2,
            transitionsBuilder:
                ((context, animation, secondaryAnimation, child) =>
                    CupertinoPageTransition(
                      primaryRouteAnimation: animation,
                      secondaryRouteAnimation: secondaryAnimation,
                      linearTransition: false,
                      child: child,
                    )));
}

class SlideBottomTransitionPage extends CustomTransitionPage {
  final GoRouterState state;
  SlideBottomTransitionPage({required super.child, required this.state})
      : super(
          key: state.pageKey,
          transitionDuration: Durations.short2,
          reverseTransitionDuration: Durations.short1,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeThroughTransition(
            secondaryAnimation: secondaryAnimation,
            animation: animation,
            child: child,
          ),
        );
}

class ZoomTransitionPage extends CustomTransitionPage {
  ZoomTransitionPage({required super.child, super.key})
      : super(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve:
                  const Interval(0.2, 1.0, curve: Easing.emphasizedDecelerate),
              reverseCurve:
                  const Interval(0.2, 1.0, curve: Easing.emphasizedAccelerate),
            );

            final slideIn = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(curvedAnimation);

            final scaleIn = Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(curvedAnimation);

            return CreatePostTransitionDriver(
              animation: animation,
              child: SlideTransition(
                position: slideIn,
                child: ScaleTransition(
                  scale: scaleIn,
                  child: child,
                ),
              ),
            );
          },
        );
}

class CreatePostTransitionDriver extends StatefulWidget {
  final Widget child;
  final Animation<double> animation;
  const CreatePostTransitionDriver({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  State<CreatePostTransitionDriver> createState() =>
      _CreatePostTransitionDriverState();
}

class _CreatePostTransitionDriverState
    extends State<CreatePostTransitionDriver> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<CreatePostTransitionProvider>()
            .setAnimation(widget.animation);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
