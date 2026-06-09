import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class _ShapeState {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  final Widget child;

  _ShapeState({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.child,
  });
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_ShapeState> _shapes = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updatePositions);
  }

  void _initShapes(Size size) {
    if (_initialized) return;
    final random = Random();
    final colorScheme = Theme.of(context).colorScheme;

    _shapes = [
      _ShapeState(
        position: Offset(
          random.nextDouble() * (size.width - 150),
          random.nextDouble() * (size.height - 150),
        ),
        velocity: Offset(
          random.nextDouble() * 4 - 2,
          random.nextDouble() * 4 - 2,
        ),
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: 0.02,
        child: MaterialShapes.burst(
          size: 150,
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        ),
      ),
      _ShapeState(
        position: Offset(
          random.nextDouble() * (size.width - 200),
          random.nextDouble() * (size.height - 200),
        ),
        velocity: Offset(
          random.nextDouble() * 4 - 2,
          random.nextDouble() * 4 - 2,
        ),
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: -0.02,
        child: MaterialShapes.flower(
          size: 200,
          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        ),
      ),
      _ShapeState(
        position: Offset(
          random.nextDouble() * (size.width - 100),
          random.nextDouble() * (size.height - 100),
        ),
        velocity: Offset(
          random.nextDouble() * 4 - 2,
          random.nextDouble() * 4 - 2,
        ),
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: 0.01,
        child: MaterialShapes.heart(
          size: 100,
          color: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        ),
      ),
      _ShapeState(
        position: Offset(
          random.nextDouble() * (size.width - 120),
          random.nextDouble() * (size.height - 120),
        ),
        velocity: Offset(
          random.nextDouble() * 4 - 2,
          random.nextDouble() * 4 - 2,
        ),
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: -0.01,
        child: MaterialShapes.circle(
          size: 120,
          color: colorScheme.errorContainer.withValues(alpha: 0.5),
        ),
      ),
    ];
    _initialized = true;
    _controller.repeat();
  }

  void _updatePositions() {
    final size = MediaQuery.of(context).size;
    for (var shape in _shapes) {
      shape.position += shape.velocity;
      shape.rotation += shape.rotationSpeed;

      if (shape.position.dx <= 0 || shape.position.dx >= size.width - 150) {
        shape.velocity = Offset(-shape.velocity.dx, shape.velocity.dy);
      }
      if (shape.position.dy <= 0 || shape.position.dy >= size.height - 150) {
        shape.velocity = Offset(shape.velocity.dx, -shape.velocity.dy);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _initShapes(size);

    return Scaffold(
      body: Stack(
        children: [
          ..._shapes.map(
            (s) => Positioned(
              left: s.position.dx,
              top: s.position.dy,
              child: Transform.rotate(angle: s.rotation, child: s.child),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("data")],
            ),
          ),
        ],
      ),
    );
  }
}
