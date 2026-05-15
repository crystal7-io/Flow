import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
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
  Widget build(BuildContext context) {
    return AppProvider(
      child: Consumer<AppService>(
        builder: (context, appService, child) {
          return MaterialApp.router(
            routerConfig: context.read<GoRouter>(),
            theme: ThemeData.from(
              textTheme: GoogleFonts.manropeTextTheme(
                ThemeData.light().textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: appService.seedColor,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.from(
              textTheme: GoogleFonts.manropeTextTheme(
                ThemeData.dark().textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: appService.seedColor,
                brightness: Brightness.dark,
              ),
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
