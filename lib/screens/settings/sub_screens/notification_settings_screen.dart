import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool pauseAll = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        children: [
          // const Banner(
          //     message:
          //         "Control all your notifications from your device settings",
          //     location: BannerLocation.topStart),
          SwitchListTile(
            title: const Text("Pause all"),
            value: pauseAll,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 16,
            ),
            onChanged: (value) {
              setState(() {
                pauseAll = value;
              });
            },
          ),
          ListItem(title: "Quite mode", onTap: () {}),
          const Divider(),
          ListItem(title: "Posts, stories and comments", onTap: () {}),
          ListItem(title: "Following and followers", onTap: () {}),
          ListItem(title: "Messages", onTap: () {}),
          ListItem(title: "Calls", onTap: () {}),
          ListItem(title: "Live and reels", onTap: () {}),
          ListItem(title: "Fundraisers", onTap: () {}),
          ListItem(title: "From Instagram", onTap: () {}),
          ListItem(title: "Birthdays", onTap: () {}),
          const Divider(),
          ListItem(title: "Email notifications", onTap: () {}),
          ListItem(title: "Shopping", onTap: () {}),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      onTap: onTap,
      title: Text(title),
    );
  }
}
