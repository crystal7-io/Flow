import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:libmonet/libmonet.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/constants/app_config.dart';
import 'package:redesigned/core/navigation/router.dart';
import 'package:redesigned/core/services/app_provider.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/data/local/local_user_data_source.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.useAuth) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
  Widget build(BuildContext context) {
    return AppProvider(
      child: Consumer<AppService>(
        builder: (context, appService, child) {
          DynamicScheme createDynamicScheme(
            Brightness brightness,
            bool highContrast,
          ) => DynamicScheme.withDefaults(
            sourceColor: TonalPaletteSourceColor.fromArgb(
              appService.seedColor.toARGB32(),
            ),
            variant: Variant.tonalSpot,
            isDark: brightness == Brightness.dark,
            contrastLevel: highContrast ? 1.0 : 0.0,
            platform: Platform.phone,
            specVersion: SpecVersion.spec2026,
          );

          final lightScheme = createDynamicScheme(Brightness.light, false);
          final darkScheme = createDynamicScheme(Brightness.dark, false);
          final highContrastLightScheme = createDynamicScheme(
            Brightness.light,
            true,
          );
          final highContrastDarkScheme = createDynamicScheme(
            Brightness.dark,
            true,
          );
          return MaterialApp.router(
            routerConfig: context.read<GoRouter>(),
            theme: ThemeData.from(
              textTheme: GoogleFonts.googleSansFlexTextTheme(
                ThemeData.light().textTheme,
              ),
              colorScheme: lightScheme.toColorScheme(),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.from(
              textTheme: GoogleFonts.googleSansFlexTextTheme(
                ThemeData.dark().textTheme,
              ),
              colorScheme: darkScheme.toColorScheme(),
              useMaterial3: true,
            ),
            highContrastTheme: ThemeData.from(
              textTheme: GoogleFonts.googleSansFlexTextTheme(
                ThemeData.light().textTheme,
              ),
              colorScheme: highContrastLightScheme.toColorScheme(),
              useMaterial3: true,
            ),
            highContrastDarkTheme: ThemeData.from(
              textTheme: GoogleFonts.googleSansFlexTextTheme(
                ThemeData.dark().textTheme,
              ),
              colorScheme: highContrastDarkScheme.toColorScheme(),
              useMaterial3: true,
            ),
            themeMode: appService.themeMode,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

extension DynamicSchemeExtension on DynamicScheme {
  ColorScheme toColorScheme() => ColorScheme(
    brightness: isDark ? Brightness.dark : Brightness.light,
    // ignore: deprecated_member_use
    background: Color(background),
    // ignore: deprecated_member_use
    onBackground: Color(onBackground),
    surface: Color(surface),
    surfaceDim: Color(surfaceDim),
    surfaceBright: Color(surfaceBright),
    surfaceContainerLowest: Color(surfaceContainerLowest),
    surfaceContainerLow: Color(surfaceContainerLow),
    surfaceContainer: Color(surfaceContainer),
    surfaceContainerHigh: Color(surfaceContainerHigh),
    surfaceContainerHighest: Color(surfaceContainerHighest),
    onSurface: Color(onSurface),
    // ignore: deprecated_member_use
    surfaceVariant: Color(surfaceVariant),
    onSurfaceVariant: Color(onSurfaceVariant),
    outline: Color(outline),
    outlineVariant: Color(outlineVariant),
    inverseSurface: Color(inverseSurface),
    onInverseSurface: Color(inverseOnSurface),
    shadow: Color(shadow),
    scrim: Color(scrim),
    surfaceTint: Color(surfaceTint),
    primary: Color(primary),
    onPrimary: Color(onPrimary),
    primaryContainer: Color(primaryContainer),
    onPrimaryContainer: Color(onPrimaryContainer),
    primaryFixed: Color(primaryFixed),
    primaryFixedDim: Color(primaryFixedDim),
    onPrimaryFixed: Color(onPrimaryFixed),
    onPrimaryFixedVariant: Color(onPrimaryFixedVariant),
    inversePrimary: Color(inversePrimary),
    secondary: Color(secondary),
    onSecondary: Color(onSecondary),
    secondaryContainer: Color(secondaryContainer),
    onSecondaryContainer: Color(onSecondaryContainer),
    secondaryFixed: Color(secondaryFixed),
    secondaryFixedDim: Color(secondaryFixedDim),
    onSecondaryFixed: Color(onSecondaryFixed),
    onSecondaryFixedVariant: Color(onSecondaryFixedVariant),
    tertiary: Color(tertiary),
    onTertiary: Color(onTertiary),
    tertiaryContainer: Color(tertiaryContainer),
    onTertiaryContainer: Color(onTertiaryContainer),
    tertiaryFixed: Color(tertiaryFixed),
    tertiaryFixedDim: Color(tertiaryFixedDim),
    onTertiaryFixed: Color(onTertiaryFixed),
    onTertiaryFixedVariant: Color(onTertiaryFixedVariant),
    error: Color(error),
    onError: Color(onError),
    errorContainer: Color(errorContainer),
    onErrorContainer: Color(onErrorContainer),
  );
}
