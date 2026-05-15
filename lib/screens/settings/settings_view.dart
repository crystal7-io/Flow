import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/profile/user_profile_view.dart';
import 'package:redesigned/screens/settings/settings_view_model.dart';
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
            icon: Icons.account_circle_outlined,
            title: "Profile",
            subtitle: "View and edit your profile",
            onTap: () => _pushSharedAxis(context, const UserProfileView()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.auto_awesome_outlined,
            title: "Preferences",
            subtitle: "Customize your theme and app",
            onTap: () => _pushSharedAxis(context, const PreferencesScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: "Notifications",
            subtitle: "Control your alerts and messaging sounds.",
            onTap: () =>
                _pushSharedAxis(context, const NotificationSettingsScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.gpp_good_outlined,
            title: "Privacy and Security",
            subtitle: "Manage data visibility and safety settings.",
            onTap: () => _pushSharedAxis(context, const PrivacyScreen()),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: "Support",
            subtitle: "Help and support for you",
          ),
          _buildSettingsTile(
            context,
            icon: Icons.account_circle_outlined,
            title: "Account login",
            subtitle: "Manages your account data",
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
      MaterialPageRoute(builder: (context) => screen),
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
