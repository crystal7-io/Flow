import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:redesigned/core/services/navigation_service.dart';
import 'package:redesigned/core/utils/animations.dart';
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
  final Curve expressiveFastSpatial = const Cubic(0.42, 1.67, 0.21, 0.90);
  final Curve expressiveFastEffects = const Cubic(0.31, 0.94, 0.34, 1.00);

  late final _barAnimation = BarAnimation(parent: _controller);
  late final _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);

  final GlobalKey _fabKey = GlobalKey();
  int selectedIndex = 0;
  bool controllerInitialized = false;
  bool _isHomeFABMenuOpen = false;

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

  void _toggleMenu() {
    final RenderBox? renderBox =
        _fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size fabSize = renderBox.size;
    final Offset fabOffset = renderBox.localToGlobal(Offset.zero);
    final Rect sourceRect = fabOffset & fabSize;

    setState(() {
      _isHomeFABMenuOpen = true;
    });

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss Contextual FAB Menu',
      barrierColor: Theme.of(context).colorScheme.scrim.withAlpha(120),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Look here: we can remove the topPadding variable entirely
        return _ModalMenuOverlay(
          routeAnimation: animation,
          sourceRect: sourceRect,
          expressiveFastSpatial: expressiveFastSpatial,
          expressiveFastEffects: expressiveFastEffects,
          onDismissStarted: () {
            setState(() {
              _isHomeFABMenuOpen = false;
            });
          },
        );
      },
    );
  }

  Widget _buildHomeScreenFAB() {
    return SizedBox(
      key: _fabKey,
      height: 84,
      width: 84,
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          width: 84.0,
          height: 84.0,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            heroTag: 'homeFab',
            onPressed: _toggleMenu,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.add,
              size: 28,
              key: ValueKey('m3_fab_icon'),
            ),
          ),
        ),
      ),
    );
  }

  Widget homeScreenFAB() => _buildHomeScreenFAB();

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
    final createPostTransition = context.watch<CreatePostTransitionProvider>();
    final animation = createPostTransition.animation;

    Widget content = Scaffold(
      floatingActionButton: AnimatedSwitcher(
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
        child: !context.watch<AppService>().isNavBarVisible ||
                MediaQuery.sizeOf(context).width > 600 ||
                _isHomeFABMenuOpen
            ? const SizedBox(key: ValueKey('fab_empty'))
            : currentIndex == 0
                ? _buildHomeScreenFAB()
                : currentIndex == 2
                    ? messageFAB()
                    : const SizedBox(key: ValueKey('fab_empty_other')),
      ),
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

    if (animation != null) {
      final rootAnimation = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Easing.standard),
        reverseCurve:
            const Interval(0.0, 0.8, curve: Easing.emphasizedAccelerate),
      );

      return SlideTransition(
        position: rootAnimation.drive(
          Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ),
        ),
        child: ScaleTransition(
          scale: rootAnimation.drive(
            Tween<double>(
              begin: 1.0,
              end: 0.9,
            ),
          ),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _ModalMenuOverlay extends StatefulWidget {
  final Animation<double> routeAnimation;
  final Rect sourceRect;
  final Curve expressiveFastSpatial;
  final Curve expressiveFastEffects;
  final VoidCallback onDismissStarted;

  const _ModalMenuOverlay({
    required this.routeAnimation,
    required this.sourceRect,
    required this.expressiveFastSpatial,
    required this.expressiveFastEffects,
    required this.onDismissStarted,
  });

  @override
  State<_ModalMenuOverlay> createState() => _ModalMenuOverlayState();
}

class _ModalMenuOverlayState extends State<_ModalMenuOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _localCloseController;
  late final Animation<double> _exitAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    // Configure your specialized exit duration (e.g., 140ms for snappy collapse)
    _localCloseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    // Configure your exit curve profile (e.g., fastOutSlowIn to prevent visual float)
    _exitAnimation = CurvedAnimation(
      parent: _localCloseController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _localCloseController.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (_isClosing) return;
    setState(() {
      _isClosing = true;
    });
    widget.onDismissStarted();
    _localCloseController.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.sizeOf(context);

    final double bottomMargin = screenSize.height - widget.sourceRect.bottom;
    final double rightMargin = screenSize.width - widget.sourceRect.right;
    final double fabTargetWidth = widget.sourceRect.width * (56.0 / 84.0);
    final double fabTargetHeight = widget.sourceRect.height * (56.0 / 84.0);

    final double targetLeft = screenSize.width - rightMargin - fabTargetWidth;
    final double targetTop = screenSize.height - bottomMargin - fabTargetHeight;

    final Rect targetRect = Rect.fromLTWH(
      targetLeft,
      targetTop,
      fabTargetWidth,
      fabTargetHeight,
    );

    return RepaintBoundary(
      child: GestureDetector(
        onTap: _handleClose,
        child: Stack(
          children: [
            // Dark Backdrop Layer with decoupled timing tracks
            AnimatedBuilder(
              animation: Listenable.merge(
                  [widget.routeAnimation, _localCloseController]),
              builder: (context, child) {
                final double bgOpacity = _isClosing
                    ? (1.0 - _exitAnimation.value)
                    : widget.routeAnimation.value;
                return Container(
                  color: Color.lerp(
                      Colors.transparent, const Color(0x66000000), bgOpacity),
                );
              },
            ),

            // The Primary Moving FAB Button Node
            AnimatedBuilder(
              animation: Listenable.merge(
                  [widget.routeAnimation, _localCloseController]),
              builder: (context, child) {
                final double spatialT = widget.expressiveFastSpatial
                    .transform(widget.routeAnimation.value);
                final double rotationT =
                    Curves.easeOutCubic.transform(widget.routeAnimation.value);

                final Rect currentRect = _isClosing
                    ? Rect.lerp(
                        targetRect, widget.sourceRect, _exitAnimation.value)!
                    : Rect.lerp(widget.sourceRect, targetRect, spatialT)!;

                final double borderRadiusValue = _isClosing
                    ? BorderRadius.lerp(BorderRadius.circular(30),
                            BorderRadius.circular(24), _exitAnimation.value)!
                        .topLeft
                        .x
                    : BorderRadius.lerp(BorderRadius.circular(24),
                            BorderRadius.circular(30), spatialT)!
                        .topLeft
                        .x;

                final double currentRotation = _isClosing
                    ? (0.125 * (1.0 - _exitAnimation.value))
                    : (0.125 * rotationT);

                return Positioned(
                  left: currentRect.left,
                  top: currentRect.top, // Fixed layout bounds across platforms
                  width: currentRect.width,
                  height: currentRect.height,
                  child: SizedBox(
                    width: currentRect.width,
                    height: currentRect.height,
                    child: FloatingActionButton(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      onPressed: _handleClose,
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(currentRotation),
                        child: const Icon(
                          Icons.add,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Contextual Stacked Option List Menu
            Positioned(
              right: rightMargin,
              bottom: bottomMargin + fabTargetHeight + 16,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width - rightMargin * 2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStaggeredButton(
                      context: context,
                      icon: Symbols.send,
                      label: 'Chat',
                      index: 2,
                      exitAnimation: _exitAnimation,
                      theme: theme,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 4),
                    _buildStaggeredButton(
                      context: context,
                      icon: Symbols.restart_alt,
                      label: 'Slice',
                      index: 0,
                      exitAnimation: _exitAnimation,
                      theme: theme,
                      onPressed: () {
                        _handleClose();
                      },
                    ),
                    const SizedBox(height: 4),
                    _buildStaggeredButton(
                      context: context,
                      icon: Icons.add,
                      label: 'Post',
                      index: 1,
                      exitAnimation: _exitAnimation,
                      theme: theme,
                      onPressed: () {
                        // _handleClose();
                        context.push('/create-post');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaggeredButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Animation<double> exitAnimation,
    required ThemeData theme,
    VoidCallback? onPressed,
  }) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([widget.routeAnimation, _localCloseController]),
      builder: (context, child) {
        final double spatialValue;
        final double opacityValue;

        if (_isClosing) {
          spatialValue = 1.0 - exitAnimation.value;
          opacityValue = 1.0 - exitAnimation.value;
        } else {
          final double startInterval = index * 0.1;
          final double endInterval = (0.76 + index * 0.1).clamp(0.0, 1.0);

          final double rawProgress = widget.routeAnimation.value;
          final double buttonProgress =
              ((rawProgress - startInterval) / (endInterval - startInterval))
                  .clamp(0.0, 1.0);
          spatialValue = widget.expressiveFastSpatial.transform(buttonProgress);

          final double opacityProgress =
              ((rawProgress - startInterval) / 0.12).clamp(0.0, 1.0);
          opacityValue =
              widget.expressiveFastEffects.transform(opacityProgress);
        }

        const double maxButtonWidth = 140.0;
        const double buttonHeight = 56.0;
        final double currentWidth = maxButtonWidth * spatialValue;

        return Opacity(
          opacity: opacityValue.clamp(0.0, 1.0),
          child: Container(
            height: buttonHeight,
            width: currentWidth,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryFixedDim,
              borderRadius: BorderRadius.circular(100),
            ),
            clipBehavior: Clip.antiAlias,
            child: OverflowBox(
              minWidth: maxButtonWidth,
              maxWidth: maxButtonWidth,
              minHeight: buttonHeight,
              maxHeight: buttonHeight,
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  elevation: WidgetStatePropertyAll(0),
                ),
                onPressed: onPressed ?? () {},
                label: Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onPrimaryFixedVariant,
                  ),
                ),
                icon: Icon(
                  icon,
                  size: 24,
                  weight: 700,
                  color: theme.colorScheme.onPrimaryFixedVariant,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
