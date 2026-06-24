import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:libmonet/libmonet.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/constants/app_config.dart';
import 'package:redesigned/core/navigation/router.dart';
import 'package:redesigned/core/services/app_provider.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/utils/color.dart';
import 'package:redesigned/data/local/local_user_data_source.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.useAuth) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    // Ensure default user is initialized for local development
    await LocalUserDataSource().initializeDefaultUser();
  }
  // debugRepaintRainbowEnabled = true;
  runApp(Provider<GoRouter>(create: (_) => router, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => AppProvider(
    child: Consumer<AppService>(
      builder: (context, appService, child) {
        DynamicScheme createDynamicScheme(Brightness brightness, bool highContrast) =>
            DynamicScheme.withDefaults(
              // sourceColor: TonalPaletteSourceColor.fromArgb(
              //   appService.seedColor.toARGB32(),
              // ),
              variant: appService.variant,
              isDark: brightness == .dark,
              contrastLevel: highContrast ? 1.0 : 0.0,
              platform: .phone,
              specVersion: .spec2026,
            );

        ColorScheme createColorScheme(Brightness brightness, bool highContrast) =>
            createDynamicScheme(brightness, highContrast).toColorScheme(lazy: true);

        ThemeData createTheme({required ColorScheme colorScheme}) {
          return ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            textTheme: GoogleFonts.googleSansFlexTextTheme(),
            splashFactory: kIsWeb ? InkRipple.splashFactory : InkSparkle.splashFactory,
            iconTheme: IconThemeData(
              fill: 0.0,
              weight: 400.0,
              grade: 0.0,
              opticalSize: 24.0,
              size: 24.0,
              color: colorScheme.onSurface,
            ),
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: appService.themeMode,
          theme: createTheme(colorScheme: createColorScheme(.light, false)),
          darkTheme: createTheme(colorScheme: createColorScheme(.dark, false)),
          highContrastTheme: createTheme(colorScheme: createColorScheme(.light, true)),
          highContrastDarkTheme: createTheme(colorScheme: createColorScheme(.dark, true)),
          routerConfig: context.read<GoRouter>(),
        );
      },
    ),
  );
}
