import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:redesigned/core/utils/animations.dart';
import 'package:redesigned/widgets/navigation/bottom_navigation_bar.dart';
import 'package:redesigned/widgets/navigation/navigation_rail.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:provider/provider.dart';

class RootView extends StatefulWidget {
  final Widget child;
  const RootView({super.key, required this.child});
  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> with TickerProviderStateMixin {
  // Merged currentIndex and selectedIndex into a single source of truth
  int selectedIndex = 0;
  bool controllerInitialized = false;

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    value: 0,
    vsync: this,
  );
  // Reordered below _controller for explicit dependency flow
  late final _barAnimation = BarAnimation(parent: _controller);
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: context.read<AppService>().isDark(context)
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
      if (status != AnimationStatus.forward && status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse && status != AnimationStatus.dismissed) {
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

  void _onNavigationChanged(int index, String route) {
    if (selectedIndex != index) {
      context.go(route);
      setState(() => selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNavbarVisible = context.watch<AppService>().isNavBarVisible;
    final double width = MediaQuery.sizeOf(context).width;
    final bool isDesktop = width > 600; // Check if screen is expanded

    return Scaffold(
      // Completely omit the bottom navigation bar on desktop to reclaim the space
      bottomNavigationBar: isDesktop
          ? null
          : AnimatedSize(
              duration: Durations.medium3,
              curve: Easing.emphasizedDecelerate,
              child: SizedBox(
                height: isNavbarVisible ? 80 : 0,
                child: AnimatedSlide(
                  duration: Durations.medium3,
                  curve: Easing.emphasizedDecelerate,
                  offset: isNavbarVisible ? Offset.zero : const Offset(0, 1),
                  child: RepaintBoundary(
                    child: DisappearingBottomNavigationBar(
                      key: const ValueKey('bottom_bar'),
                      barAnimation: _barAnimation,
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (int index) {
                        final routes = [
                          '/home',
                          // '/stories',
                          '/messages',
                          '/notification',
                          '/settings',
                        ];
                        _onNavigationChanged(index, routes[index]);
                      },
                    ),
                  ),
                ),
              ),
            ),
      body: Row(
        children: [
          AnimatedSwitcher(
            duration: Durations.short4,
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              alignment: Alignment.centerLeft,
              child: child,
            ),
            // Only show the navigation rail if we are on desktop/expanded view
            child: isDesktop && isNavbarVisible
                ? RepaintBoundary(
                    child: DisappearingNavigationRail(
                      key: const ValueKey('nav_rail'),
                      railAnimation: _railAnimation,
                      railFabAnimation: _railFabAnimation,
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (int index) {
                        final routes = [
                          '/home',
                          '/reels',
                          '/messages',
                          '/notification',
                          '/settings',
                        ];
                        _onNavigationChanged(index, routes[index]);
                      },
                    ),
                  )
                : const SizedBox(key: ValueKey('empty_rail')),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
