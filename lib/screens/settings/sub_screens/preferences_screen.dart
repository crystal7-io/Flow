import 'package:flutter/material.dart';
import 'package:libmonet/material_color_utilities.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool hideLikeAndShare = false;

  @override
  Widget build(BuildContext context) {
    final appService = context.watch<AppService>();
    final themeMode = appService.themeMode;
    final variant = appService.variant;
    return Scaffold(
      appBar: AppBar(title: const Text("Preferences")),
      body: ListView(
        children: [
          // ListTile(
          //   leading: Icon(appService.isDark(context)
          //       ? Icons.dark_mode_outlined
          //       : Icons.light_mode_outlined),
          //   title: const Text("Theme"),
          //   subtitle: Text(themeMode == ThemeMode.dark
          //       ? "Dark"
          //       : themeMode == ThemeMode.light
          //           ? "Light"
          //           : "System"),
          //   onTap: () {
          //     showGeneralDialog(
          //         context: context,
          //         transitionDuration: const Duration(milliseconds: 200),
          //         transitionBuilder: (context, anim1, anim2, child) {
          //           return FadeTransition(
          //             opacity: anim1,
          //             child: ScaleTransition(
          //               scale: CurvedAnimation(
          //                   parent: anim1,
          //                   curve: const Cubic(0.05, 0.7, 0.1, 1.0)),
          //               child: child,
          //             ),
          //           );
          //         },
          //         pageBuilder: (context, animation, secondaryAnimation) {
          //           return SimpleDialog(
          //             title: const Text("Choose Theme"),
          //             children: [
          //               RadioListTile(
          //                   value: ThemeMode.system,
          //                   groupValue: themeMode,
          //                   title: const Text(
          //                     "System",
          //                     style: TextStyle(fontSize: 18),
          //                   ),
          //                   onChanged: (t) {
          //                     appService.changeTheme(ThemeMode.system);
          //                     Navigator.pop(context);
          //                   }),
          //               RadioListTile(
          //                   value: ThemeMode.light,
          //                   groupValue: themeMode,
          //                   title: const Text(
          //                     "Light",
          //                     style: TextStyle(fontSize: 18),
          //                   ),
          //                   onChanged: (t) {
          //                     appService.changeTheme(ThemeMode.light);
          //                     Navigator.pop(context);
          //                   }),
          //               RadioListTile(
          //                   value: ThemeMode.dark,
          //                   groupValue: themeMode,
          //                   title: const Text(
          //                     "Dark",
          //                     style: TextStyle(fontSize: 18),
          //                   ),
          //                   onChanged: (t) {
          //                     appService.changeTheme(ThemeMode.dark);
          //                     Navigator.pop(context);
          //                   }),
          //             ],
          //           );
          //         });
          //   },
          // ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 16),
            child: Text(
              "Theme",
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
              child: M3EToggleButtonGroup(
                spacing: 4,
                size: M3EButtonSize.md,
                type: M3EButtonGroupType.connected,
                onSelectedIndexChanged: (value) => appService.changeTheme(
                  value == 0
                      ? ThemeMode.system
                      : value == 1
                      ? ThemeMode.light
                      : ThemeMode.dark,
                ),
                selectedIndex: themeMode == ThemeMode.system
                    ? 0
                    : themeMode == ThemeMode.light
                    ? 1
                    : 2,
                actions: [
                  M3EToggleButtonGroupAction(
                    width: (MediaQuery.widthOf(context) - 36) / 3,
                    label: const Text('System'),
                  ),
                  M3EToggleButtonGroupAction(
                    width: (MediaQuery.widthOf(context) - 36) / 3,
                    label: const Text('Light'),
                  ),
                  M3EToggleButtonGroupAction(
                    width: (MediaQuery.widthOf(context) - 36) / 3,
                    label: const Text('Dark'),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 16),
            child: Text(
              "Variant",
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
              child: M3EToggleButtonGroup(
                spacing: 4,
                size: M3EButtonSize.md,
                type: M3EButtonGroupType.connected,
                onSelectedIndexChanged: (value) => appService.changeThemeVariant(
                  value == 0
                      ? Variant.tonalSpot
                      : value == 1
                      ? Variant.expressive
                      : Variant.vibrant,
                ),
                selectedIndex: variant == Variant.tonalSpot
                    ? 0
                    : variant == Variant.expressive
                    ? 1
                    : 2,
                actions: [
                  M3EToggleButtonGroupAction(
                    width: (MediaQuery.widthOf(context) - 36) / 3,
                    label: const Text('Tonal Spot'),
                  ),
                  M3EToggleButtonGroupAction(
                    width: (MediaQuery.widthOf(context) - 36) / 3,
                    label: const Text('Expressive'),
                  ),
                  M3EToggleButtonGroupAction(
                    width: (MediaQuery.widthOf(context) - 36) / 3,
                    label: const Text('Vibrant'),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: const Icon(Icons.translate_outlined),
            title: const Text("Language"),
            subtitle: const Text("English"),
          ),
          SwitchListTile(
            title: const Text("Floating Searchbar"),
            subtitle: const Text("Make search bar reappears when you scroll up"),
            secondary: const Icon(Icons.search),
            value: appService.isSearchFloating,
            onChanged: (bool value) {
              appService.toggleSearchFloating();
            },
          ),
        ],
      ),
    );
  }
}
