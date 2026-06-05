import 'package:button_group_m3e/button_group_m3e.dart';
import 'package:button_m3e/button_m3e.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/widgets/utils/m3expressive/button_group.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferences"),
      ),
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
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
            child: ButtonGroupM3E(
              size: ButtonGroupM3ESize.md,
              type: ButtonGroupM3EType.connected,
              selectedIndex: themeMode == ThemeMode.system
                  ? 0
                  : themeMode == ThemeMode.light
                      ? 1
                      : 2,
              equalizeWidths: true,
              actions: [
                ButtonGroupM3EAction(
                    style: themeMode == ThemeMode.system
                        ? ButtonM3EStyle.filled
                        : ButtonM3EStyle.tonal,
                    label: const Text('System'),
                    onPressed: () => appService.changeTheme(ThemeMode.system)),
                ButtonGroupM3EAction(
                    style: themeMode == ThemeMode.light
                        ? ButtonM3EStyle.filled
                        : ButtonM3EStyle.tonal,
                    label: const Text('Light'),
                    onPressed: () => appService.changeTheme(ThemeMode.light)),
                ButtonGroupM3EAction(
                    style: themeMode == ThemeMode.dark
                        ? ButtonM3EStyle.filled
                        : ButtonM3EStyle.tonal,
                    label: const Text('Dark'),
                    onPressed: () => appService.changeTheme(ThemeMode.dark)),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: const Icon(Icons.translate_outlined),
            title: const Text("Language"),
            subtitle: const Text("English"),
          ),
          SwitchListTile(
              title: const Text("Floating Searchbar"),
              subtitle:
                  const Text("Make search bar reappears when you scroll up"),
              secondary: const Icon(Icons.search),
              value: appService.isSearchFloating,
              onChanged: (bool value) {
                appService.toggleSearchFloating();
              })
        ],
      ),
    );
  }
}
