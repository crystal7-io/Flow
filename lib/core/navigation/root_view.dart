import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:redesigned/core/utils/animations.dart';
import 'package:redesigned/widgets/utils/m3expressive/fab_menu.dart';
import 'package:redesigned/widgets/utils/open_container.dart'
    as container_transform;
import 'package:redesigned/widgets/navigation/bottom_navigation_bar.dart';
import 'package:redesigned/widgets/navigation/navigation_rail.dart';
import 'package:redesigned/screens/messages/new_chat/new_chat_view.dart';
import 'package:redesigned/screens/messages/new_chat/new_chat_view_model.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/navigation/create_post_transition_provider.dart';
import 'package:provider/provider.dart';

class RootView extends StatefulWidget {
  final Widget child;
  const RootView({super.key, required this.child});
  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> with TickerProviderStateMixin {
  int currentIndex = 0;

  late final _barAnimation = BarAnimation(parent: _controller);
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    value: 0,
    vsync: this,
  );
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);

  int selectedIndex = 0;
  bool controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            context.read<AppService>().isDark(context)
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateNavigation();
  }

  void _updateNavigation() {
    final double width = MediaQuery.sizeOf(context).width;
    final AnimationStatus status = _controller.status;
    final bool shouldShow = width > 600;

    if (shouldShow) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = shouldShow ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget messageFAB() => container_transform.OpenContainer(
    transitionType: container_transform.ContainerTransitionType.fadeThrough,
    transitionDuration: Durations.long1,
    reverseTransitionDuration: Durations.short4,
    openColor: Theme.of(context).colorScheme.surface,
    middleColor: Theme.of(context).colorScheme.surface,
    closedColor: Theme.of(context).colorScheme.primaryContainer,
    openElevation: 0,
    clipBehavior: Clip.none,
    closedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    closedElevation: 0,
    closedBuilder: (context, openContainer) => FloatingActionButton.extended(
      heroTag: 'myfab',
      onPressed: () {
        openContainer();
      },
      icon: const Icon(Icons.edit_outlined),
      label: const Text("Chat"),
    ),
    openBuilder: (context, controller) =>
        ChangeNotifierProvider<NewChatViewModel>(
          create: (_) => NewChatViewModel(),
          child: const NewChatView(),
        ),
  );

  @override
  Widget build(BuildContext context) {
    final createPostTransition = context.watch<CreatePostTransitionProvider>();
    final animation = createPostTransition.animation;

    Widget floatingMenu = AnimatedSwitcher(
      switchInCurve: Easing.emphasizedDecelerate,
      switchOutCurve: Curves.linear, // Linear works best for a hard cutoff
      duration: const Duration(milliseconds: 250),

      transitionBuilder: (child, animation) {
        // Check if this child is the one leaving the screen
        final bool isExiting =
            animation.status == AnimationStatus.completed ||
            animation.status == AnimationStatus.reverse;

        // If it's exiting, force its opacity to 0 instantly so it never lingers
        return FadeTransition(
          opacity: isExiting ? const AlwaysStoppedAnimation(0.0) : animation,
          child: ScaleTransition(
            alignment: Alignment.bottomRight,
            scale: animation,
            child: child,
          ),
        );
      },
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topLeft,
        children: [...previousChildren, if (currentChild != null) currentChild],
      ),
      child:
          !context.watch<AppService>().isNavBarVisible ||
              MediaQuery.sizeOf(context).width > 600
          ? const SizedBox(key: ValueKey('fab_empty'))
          : currentIndex == 0
          ? FloatingActionButtonMenu(
              key: const ValueKey('home_fab_menu'),
              children: [
                FloatingAcitonMenuButton(
                  icon: Icons.movie_filter_outlined,
                  label: "Slice",
                  delay: Duration(milliseconds: 80),
                ),
                FloatingAcitonMenuButton(
                  icon: Icons.message_outlined,
                  label: "Message",
                  delay: Duration(milliseconds: 40),
                ),
                FloatingAcitonMenuButton(
                  onPressed: () {
                    context.push('/create-post');
                  },
                  icon: Icons.image_outlined,
                  label: "Post",
                  delay: Duration(milliseconds: 0),
                ),
              ],
            )
          : currentIndex == 2
          ? Align(
              key: const ValueKey('message_fab_aligned'),
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: messageFAB(),
              ),
            )
          : const SizedBox(key: ValueKey('fab_empty_other')),
    );
    Widget content = Scaffold(
      bottomNavigationBar: AnimatedContainer(
        duration: Durations.medium3,
        curve: Easing.emphasizedDecelerate,
        height: context.watch<AppService>().isNavBarVisible ? 80 : 0,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxHeight: 80,
          child: AnimatedSlide(
            duration: Durations.medium3,
            curve: Easing.emphasizedDecelerate,
            offset: context.watch<AppService>().isNavBarVisible
                ? Offset.zero
                : const Offset(0, 1),
            child: RepaintBoundary(
              child: DisappearingBottomNavigationBar(
                key: const ValueKey('bottom_bar'),
                barAnimation: _barAnimation,
                selectedIndex: currentIndex,
                onDestinationSelected: (int index) {
                  if (currentIndex != index) {
                    switch (index) {
                      case 0:
                        context.go('/home');
                        break;
                      case 1:
                        context.go('/stories');
                        break;
                      case 2:
                        context.go('/messages');
                        break;
                      case 3:
                        context.go('/notification');
                        break;
                      case 4:
                        context.go('/settings');
                        break;
                    }
                    setState(() {
                      currentIndex = index;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              AnimatedSwitcher(
                duration: Durations.short4,
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
                child: context.watch<AppService>().isNavBarVisible
                    ? RepaintBoundary(
                        child: DisappearingNavigationRail(
                          key: const ValueKey('nav_rail'),
                          railAnimation: _railAnimation,
                          railFabAnimation: _railFabAnimation,
                          selectedIndex: selectedIndex,
                          onDestinationSelected: (index) {
                            setState(() {
                              selectedIndex = index;
                              switch (index) {
                                case 0:
                                  context.go('/home');
                                  break;
                                case 1:
                                  context.go('/reels');
                                  break;
                                case 2:
                                  context.go('/messages');
                                  break;
                                case 3:
                                  context.go('/notification');
                                  break;
                                case 4:
                                  context.go('/settings');
                                  break;
                              }
                            });
                          },
                        ),
                      )
                    : const SizedBox(key: ValueKey('empty_rail')),
              ),
              Expanded(child: widget.child),
            ],
          ),
          Positioned.fill(
            child: IgnorePointer(ignoring: false, child: floatingMenu),
          ),
        ],
      ),
    );

    if (animation != null) {
      final rootAnimation = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Easing.standard),
        reverseCurve: const Interval(
          0.0,
          0.8,
          curve: Easing.emphasizedAccelerate,
        ),
      );

      return SlideTransition(
        position: rootAnimation.drive(
          Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)),
        ),
        child: ScaleTransition(
          scale: rootAnimation.drive(Tween<double>(begin: 1.0, end: 0.9)),
          child: content,
        ),
      );
    }

    return content;
  }
}
