import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/auth_screens/sign_in/sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          color: colorScheme.surface,
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 50,
                child: MaterialShapes.burst(
                  size: 150,
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              Positioned(
                bottom: -10,
                right: 20,
                child: MaterialShapes.flower(
                  size: 200,
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                ),
              ),
              Positioned(
                top: size.height / 2,
                right: 20,
                child: MaterialShapes.heart(
                  size: 100,
                  color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                ),
              ),
              Positioned(
                bottom: size.height / 3,
                left: -20,
                child: MaterialShapes.circle(
                  size: 150,
                  color: colorScheme.secondary.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
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
                  const SizedBox(height: 8),
                  Text(
                    "Reconnect with your world",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        TextField(
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          controller: context
                              .read<SignInViewModel>()
                              .emailController,
                          decoration: InputDecoration(
                            fillColor: colorScheme.surfaceContainer,
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
                        TextField(
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          controller: context
                              .read<SignInViewModel>()
                              .passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: colorScheme.surfaceContainer,
                            filled: true,
                            hintText: "Password",
                            border: OutlineInputBorder(
                              gapPadding: 16,
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: context
                                .read<SignInViewModel>()
                                .onLoginPress,
                            child: const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: Text(
                              "G",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            label: const Text("Continue with Google"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: context
                        .read<SignInViewModel>()
                        .onForgetPasswordPress,
                    child: const Text("Forget password?"),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: theme.textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: context
                            .read<SignInViewModel>()
                            .onSignUpPress,
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
