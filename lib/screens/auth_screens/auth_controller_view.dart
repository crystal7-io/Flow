import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';
import 'package:redesigned/screens/auth_screens/auth_view_model.dart';

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

class AuthControllerView extends StatefulWidget {
  const AuthControllerView({super.key});

  @override
  State<AuthControllerView> createState() => _AuthControllerViewState();
}

class _AuthControllerViewState extends State<AuthControllerView>
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
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
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
          color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
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
          color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        ),
      ),
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
        rotationSpeed: -0.01,
        child: MaterialShapes.circle(
          size: 150,
          color: colorScheme.secondary.withValues(alpha: 0.2),
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
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    _initShapes(size);

    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        Provider.of<AuthService>(context, listen: false),
        Provider.of<NavigationService>(context, listen: false),
      ),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            ..._shapes.map(
              (s) => Positioned(
                left: s.position.dx,
                top: s.position.dy,
                child: Transform.rotate(angle: s.rotation, child: s.child),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Consumer<AuthViewModel>(
                  builder: (context, vm, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Flow",
                        style: GoogleFonts.pacifico(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _buildAuthStep(context, vm),
                      if (vm.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            vm.errorMessage!,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthStep(BuildContext context, AuthViewModel vm) {
    switch (vm.currentStep) {
      case AuthStep.email:
        return _buildEmailStep(context, vm);
      case AuthStep.otp:
        return _buildOtpStep(context, vm);
      case AuthStep.password:
        return _buildPasswordStep(context, vm);
      case AuthStep.signup:
        return const Text("Sign Up Form Placeholder");
    }
  }

  Widget _buildEmailStep(BuildContext context, AuthViewModel vm) {
    return Column(
      children: [
        TextField(
          onChanged: vm.setEmail,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            filled: true,
            hintText: "Email",
            border: OutlineInputBorder(
              gapPadding: 16,
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: () {
              if (!vm.proceedEmail()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(vm.errorMessage ?? 'Invalid email')),
                );
              }
            },
            child: const Text("Continue"),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(onPressed: () {}, child: const Text("Continue with Google")),
      ],
    );
  }

  Widget _buildOtpStep(BuildContext context, AuthViewModel vm) {
    return Column(
      children: [
        TextField(
          onChanged: vm.verifyOtp,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            filled: true,
            hintText: "Enter OTP (111222)",
            border: OutlineInputBorder(
              gapPadding: 16,
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordStep(BuildContext context, AuthViewModel vm) {
    return _PasswordTextField(vm: vm);
  }
}

class _PasswordTextField extends StatefulWidget {
  final AuthViewModel vm;
  const _PasswordTextField({required this.vm});

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.vm.password);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          controller: _controller,
          onChanged: (value) => widget.vm.setPassword(value),
          obscureText: true,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            filled: true,
            hintText: "Password",
            border: OutlineInputBorder(
              gapPadding: 16,
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(50),
              ),
              child: SizedBox(
                height: 56,
                width: 64,
                child: IconButton(
                  onPressed: widget.vm.reset,
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    widget.vm.validatePassword();
                    if (widget.vm.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(widget.vm.errorMessage!)),
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
