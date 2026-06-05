import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesigned/core/utils/expressive_physics.dart';

class FloatingActionButtonMenu extends StatefulWidget {
  final List<FloatingAcitonMenuButton> children;

  const FloatingActionButtonMenu({super.key, required this.children});

  @override
  State<FloatingActionButtonMenu> createState() => _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _fabController;

  static const double _initialFabWidth = 96.0;
  static const double _initialFabHeight = 96.0;
  static const double _initialFabRadius = 28.0;

  static const double _targetFabWidth = 64.0;
  static const double _targetFabHeight = 64.0;
  static const double _targetFabRadius = 32.0;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
      value: 0.0,
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    final simulation = SpringSimulation(
        ExpressiveMotionSpring.fastSpatial, _fabController.value, _isMenuOpen ? 1.0 : 0.0, 0.0);
    _fabController.animateWith(simulation);
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ValueListenable<ScaffoldGeometry> geometryListenable = Scaffold.geometryOf(context);
    final Size scaffoldSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        if (_isMenuOpen || _fabController.value > 0.0)
          AnimatedBuilder(
            animation: _fabController,
            builder: (context, child) {
              final double clampedProgress = _fabController.value.clamp(0.0, 1.0);
              return IgnorePointer(
                ignoring: !_isMenuOpen,
                child: ModalBarrier(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerLowest
                      .withAlpha((clampedProgress * 160).toInt()),
                  dismissible: true,
                  onDismiss: () {
                    setState(() => _isMenuOpen = false);
                    final simulation = SpringSimulation(
                        ExpressiveMotionSpring.fastSpatial, _fabController.value, 0.0, 0.0);
                    _fabController.animateWith(simulation);
                  },
                ),
              );
            },
          ),
        Flow(
          delegate: _ScaffoldResponsiveFlowDelegate(
            geometryListenable: geometryListenable,
            scaffoldSize: scaffoldSize,
            fallbackSize: const Size(_initialFabWidth, _initialFabHeight), // Fixed frame 1 snap
          ),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isMenuOpen) ...[
                  for (int i = 0; i < widget.children.length; i++) ...[
                    widget.children[i],
                    if (i < widget.children.length - 1) const SizedBox(height: 4),
                  ],
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: _initialFabWidth,
                  height: _initialFabHeight,
                  child: OverflowBox(
                    alignment: Alignment.topRight,
                    minWidth: 0.0,
                    maxWidth: _initialFabWidth * 1.5,
                    minHeight: 0.0,
                    maxHeight: _initialFabHeight * 1.5,
                    child: AnimatedBuilder(
                      animation: _fabController,
                      builder: (context, child) {
                        final double t = _fabController.value;
                        final double currentWidth =
                            Tween<double>(begin: _initialFabWidth, end: _targetFabWidth)
                                .transform(t);
                        final double currentHeight =
                            Tween<double>(begin: _initialFabHeight, end: _targetFabHeight)
                                .transform(t);
                        final double currentRadius =
                            Tween<double>(begin: _initialFabRadius, end: _targetFabRadius)
                                .transform(t);
                        final double currentIconSize =
                            Tween<double>(begin: 32.0, end: 24.0).transform(t);

                        final double safeWidth = currentWidth.clamp(0.0, double.infinity);
                        final double safeHeight = currentHeight.clamp(0.0, double.infinity);
                        final double safeRadius = currentRadius.clamp(0.0, double.infinity);
                        final double rotationAngle = t * (math.pi / 4.0);

                        return GestureDetector(
                          onTap: _toggleMenu,
                          child: Container(
                            width: safeWidth,
                            height: safeHeight,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(safeRadius),
                              boxShadow: kElevationToShadow[6],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Center(
                              child: Transform.rotate(
                                angle: rotationAngle,
                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: currentIconSize.clamp(0.0, double.infinity),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ScaffoldResponsiveFlowDelegate extends FlowDelegate {
  final ValueListenable<ScaffoldGeometry> geometryListenable;
  final Size scaffoldSize;
  final Size fallbackSize; // Added target fallback size tracking

  _ScaffoldResponsiveFlowDelegate({
    required this.geometryListenable,
    required this.scaffoldSize,
    required this.fallbackSize,
  }) : super(repaint: geometryListenable);

  @override
  void paintChildren(FlowPaintingContext context) {
    final ScaffoldGeometry geometry = geometryListenable.value;
    double bottomOffset = 16.0;

    if (geometry.bottomNavigationBarTop != null) {
      final navBarHeight = scaffoldSize.height - geometry.bottomNavigationBarTop!;
      if (navBarHeight > 0) {
        bottomOffset += navBarHeight;
      }
    }

    var childSize = context.getChildSize(0) ?? Size.zero;

    // Fallback to the known standard FAB dimensions if layouts aren't ready yet
    if (childSize == Size.zero) {
      childSize = fallbackSize;
    }

    final double x = scaffoldSize.width - childSize.width - 16.0;
    final double y = scaffoldSize.height - childSize.height - bottomOffset;

    context.paintChild(0, transform: Matrix4.translationValues(x, y, 0.0));
  }

  @override
  bool shouldRepaint(covariant _ScaffoldResponsiveFlowDelegate oldDelegate) {
    return oldDelegate.geometryListenable != geometryListenable ||
        oldDelegate.scaffoldSize != scaffoldSize ||
        oldDelegate.fallbackSize != fallbackSize;
  }
}

class FloatingAcitonMenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Duration delay;

  const FloatingAcitonMenuButton({
    super.key,
    required this.icon,
    required this.label,
    this.delay = Duration.zero,
  });

  @override
  State<FloatingAcitonMenuButton> createState() => _FloatingAcitonMenuButtonState();
}

class _FloatingAcitonMenuButtonState extends State<FloatingAcitonMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _childKey = GlobalKey();

  double _naturalWidth = 0.0;
  bool _isMeasured = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        if (mounted) {
          setState(() {
            _naturalWidth = renderBox.size.width;
            _isMeasured = true;
          });
          _runSimulation();
        }
      }
    });
  }

  Future<void> _runSimulation() async {
    if (widget.delay.inMilliseconds > 0) {
      await Future.delayed(widget.delay);
    }
    if (!mounted) return;

    final simulation = SpringSimulation(ExpressiveMotionSpring.fastSpatial, 0.0, 1.0, 0.0);
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMeasured) {
      return Offstage(
        offstage: true,
        child: UnconstrainedBox(
          child: Container(key: _childKey, child: _buildButtonContent()),
        ),
      );
    }

    final double overshootBufferWidth = _naturalWidth * 1.3;

    return SizedBox(
      width: _naturalWidth,
      height: 64,
      child: OverflowBox(
        alignment: Alignment.centerRight,
        minWidth: 0.0,
        maxWidth: overshootBufferWidth,
        minHeight: 64,
        maxHeight: 64,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double rawValue = _controller.value;
            final double animatedWidth = _naturalWidth * rawValue.clamp(0.0, double.infinity);

            double opacityProgress = 0.0;
            if (rawValue > 0.0) {
              opacityProgress = (rawValue / 0.5).clamp(0.0, 1.0);
            }
            final double animatedOpacity = Easing.standard.transform(opacityProgress);

            return Opacity(
              opacity: animatedOpacity,
              child: Container(
                width: animatedWidth,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(32),
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.centerRight,
                child: child,
              ),
            );
          },
          child: OverflowBox(
            minWidth: 0.0,
            maxWidth: overshootBufferWidth,
            minHeight: 0.0,
            maxHeight: 64,
            alignment: Alignment.centerRight,
            child: SizedBox(width: overshootBufferWidth, child: _buildButtonContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(widget.icon, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 24),
          const SizedBox(width: 14),
          Text(
            widget.label,
            style: GoogleFonts.googleSansFlex(
              decoration: TextDecoration.none,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ZeroPaddingFabLocation extends FloatingActionButtonLocation {
  const ZeroPaddingFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset.zero;
  }
}
