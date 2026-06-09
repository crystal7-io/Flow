import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity")),
      body: ListView(
        children: [
          ListItem(
            title: "Saved",
            iconData: Icons.bookmark_outline,
            onTap: () {},
          ),
          ListItem(title: "Archive", iconData: Icons.history, onTap: () {}),
          ListItem(
            title: "Time spent",
            iconData: Icons.schedule_outlined,
            onTap: () {},
          ),
          const Divider(),
          ListItem(
            title: "Likes",
            iconData: Icons.favorite_outline,
            onTap: () {},
          ),
          ListItem(
            title: "Comments",
            iconData: Icons.comment_outlined,
            onTap: () {},
          ),
          ListItem(
            title: "Tags",
            iconData: Icons.account_box_outlined,
            onTap: () {},
          ),
          ListItem(
            title: "Sticker responses",
            iconData: Symbols.sticky_note,
            onTap: () {},
          ),
          ListItem(
            title: "Reviews",
            iconData: Icons.remove_red_eye_outlined,
            onTap: () {},
          ),
          const Divider(),
          ListItem(
            title: "Recently Deleted",
            iconData: Symbols.delete_outline,
            onTap: () {},
          ),
          ListItem(
            title: "Account history",
            iconData: Icons.calendar_month_outlined,
            onTap: () {},
          ),
          ListItem(
            title: "Recent searches",
            iconData: Icons.manage_search,
            onTap: () {},
          ),
          ListItem(title: "Link history", iconData: Icons.link, onTap: () {}),
          const Divider(),
          ListItem(
            title: "Transfer information",
            iconData: Icons.swap_horiz_outlined,
            onTap: () {},
          ),
          ListItem(
            title: "Download information",
            iconData: Icons.download_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
  });
  final String title;
  final IconData iconData;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      onTap: onTap,
      title: Text(title),
      leading: Icon(iconData),
    );
  }
}
