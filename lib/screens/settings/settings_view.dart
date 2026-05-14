import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/settings/settings_view_model.dart';
import 'package:redesigned/screens/settings/sub_screens/activity_screen.dart';
import 'package:redesigned/screens/settings/sub_screens/interactions_screen.dart';
import 'package:redesigned/screens/settings/sub_screens/interests_screen.dart';
import 'package:redesigned/screens/settings/sub_screens/notification_settings_screen.dart';
import 'package:redesigned/screens/settings/sub_screens/preferences_screen.dart';
import 'package:redesigned/screens/settings/sub_screens/privacy_screen.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: 24, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
              leading: Icon(
                Symbols.search,
                weight: 600,
              ),
              elevation: WidgetStatePropertyAll(0),
              hintText: "Search settings",
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.data_usage_outlined,
            title: "Activity",
            subtitle: "App usage and your activity",
            onTap: () => _pushSharedAxis(context, const ActivityScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.auto_awesome_outlined,
            title: "Preferences",
            subtitle: "Theme, Language and more",
            onTap: () => _pushSharedAxis(context, const PreferencesScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: "Notifications",
            subtitle: "Manage app notifications",
            onTap: () => _pushSharedAxis(context, const NotificationSettingsScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.gpp_good_outlined,
            title: "Privacy and Secrecy",
            subtitle: "Who can see your content",
            onTap: () => _pushSharedAxis(context, const PrivacyScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: MdiIcons.heartMultipleOutline,
            title: "Your Interests",
            subtitle: "Control what you see",
            onTap: () => _pushSharedAxis(context, const InterestsScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.people_alt_outlined,
            title: "Interactions",
            subtitle: "How others interact with you",
            onTap: () => _pushSharedAxis(context, const InteractionsScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.pending_outlined,
            title: "Other",
            subtitle: "Families, professional, payments and more",
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: "Support",
            subtitle: "Help, support and account status",
          ),
          _buildSettingsTile(
            context,
            icon: Icons.account_circle_outlined,
            title: "Account login",
            subtitle: "Manages accounts on this device",
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: "About",
            subtitle: "App info and credits",
          ),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: "Logout",
            subtitle: "Log out your account",
            onTap: () => viewModel.logout(),
          ),
        ],
      ),
    );
  }

  void _pushSharedAxis(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      titleTextStyle: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

