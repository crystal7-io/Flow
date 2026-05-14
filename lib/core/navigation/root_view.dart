import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesigned/core/utils/animations.dart';
import 'package:redesigned/widgets/utils/open_container.dart'
    as container_transform;
import 'package:redesigned/widgets/navigation/bottom_navigation_bar.dart';
import 'package:redesigned/widgets/navigation/navigation_rail.dart';
import 'package:redesigned/screens/messages/new_chat/new_chat_view.dart';
import 'package:redesigned/screens/messages/new_chat/new_chat_view_model.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:provider/provider.dart';

class RootView extends StatefulWidget {
  final Widget child;
  const RootView({super.key, required this.child});
  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late final _barAnimation = BarAnimation(parent: _controller);
  late final _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);

  int selectedIndex = 0;
  bool controllerInitialized = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          context.read<AppService>().isDark(context)
              ? Brightness.light
              : Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateNavigation();
  }

  void _updateNavigation() {
    final double width = MediaQuery.of(context).size.width;
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

  Widget homeScreenFAB() => FloatingActionButton(
        heroTag: 'homeFab',
        onPressed: () {
          showModalBottomSheet(
              showDragHandle: true,
              useRootNavigator: true,
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                    child: SizedBox(
                        height: 125,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: () {},
                                    padding: const EdgeInsets.all(16),
                                    icon: const Icon(Icons.add_box_outlined),
                                    iconSize: 36,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Post",
                                    style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: () {},
                                    padding: const EdgeInsets.all(16),
                                    icon: const Icon(
                                        Icons.movie_creation_outlined),
                                    iconSize: 36,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Reel",
                                    style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: () {},
                                    padding: const EdgeInsets.all(16),
                                    icon: const Icon(
                                        Icons.cast_connected_outlined),
                                    iconSize: 36,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Live",
                                    style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ])));
              });
        },
        child: const Icon(Icons.add),
      );

  Widget messageFAB() => container_transform.OpenContainer(
      transitionType: container_transform.ContainerTransitionType.fadeThrough,
      transitionDuration: Durations.long1,
      reverseTransitionDuration: Durations.short4,
      openColor: Theme.of(context).colorScheme.surface,
      middleColor: Theme.of(context).colorScheme.surface,
      closedColor: Theme.of(context).colorScheme.primaryContainer,
      openElevation: 0,
      clipBehavior: Clip.none,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      closedElevation: 0,
      closedBuilder: (context, openContainer) => FloatingActionButton.extended(
          heroTag: 'myfab',
          onPressed: () {
            openContainer();
          },
          icon: const Icon(Icons.edit_outlined),
          label: const Text("Chat")),
      openBuilder: (context, controller) =>
          ChangeNotifierProvider<NewChatViewModel>(
              create: (_) => NewChatViewModel(), child: const NewChatView()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !context.watch<AppService>().isNavBarVisible ||
              // ? const SizedBox()
              MediaQuery.sizeOf(context).width > 600
          ? null
          : AnimatedSwitcher(
              switchInCurve: Easing.emphasizedDecelerate,
              switchOutCurve: Easing.emphasizedAccelerate,
              duration: Durations.medium3,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  alignment: Alignment.bottomRight,
                  scale: animation,
                  child: child,
                ),
              ),
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.bottomRight,
                children: [currentChild!, ...previousChildren],
              ),
              child: currentIndex == 0
                  ? homeScreenFAB()
                  : currentIndex == 2
                      ? messageFAB()
                      : const SizedBox(),
            ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: Durations.medium3,
        transitionBuilder: (child, animation) => SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          child: child,
        ),
        child: context.watch<AppService>().isNavBarVisible
            ? RepaintBoundary(
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
              )
            : const SizedBox(key: ValueKey('empty_bar')),
      ),
      body: Row(
        children: [
          AnimatedSwitcher(
            duration: Durations.short4,
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
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
                            case 2:
                              context.go('/messages');
                              break;
                            case 3:
                              context.go('/notification');
                              break;
                            case 4:
                              context.go('/settings');
                              break;
                            default:
                          }
                        });
                      },
                    ),
                  )
                : const SizedBox(key: ValueKey('empty_rail')),
          ),
          Expanded(child: widget.child)
        ],
      ),
    );
  }
}
