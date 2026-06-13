import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  AccountPrivacy? accountPrivacy = AccountPrivacy.private;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy and Secrecy")),
      body: ListView(
        children: [
          const ListTile(title: Text("Account privacy")),
          RadioListTile<AccountPrivacy>(
            value: AccountPrivacy.private,
            groupValue: accountPrivacy,
            onChanged: (AccountPrivacy? value) {
              setState(() {
                accountPrivacy = value;
              });
            },
            title: const Text("Private"),
          ),
          RadioListTile<AccountPrivacy>(
            value: AccountPrivacy.public,
            groupValue: accountPrivacy,
            onChanged: (AccountPrivacy? value) {
              setState(() {
                accountPrivacy = value;
              });
            },
            title: const Text("Public"),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "When your account is public, your profile and posts can be seen by anyone, on or off Instagram, even if they don't have Instagram account.\n\nWhen your account is private, only the followers you approve can see what you share, including your photos or videos on hashtag and location pages, and your followers and following lists.\n\nCertain info on your profile, like your profile picture and username, is visible to everyone on and off Instagram.",
            ),
          ),
          // Row(
          //   children: [
          //     const SizedBox(width: 16),
          //     TextButton.icon(
          //         icon: const Icon(Icons.expand_more),
          //         onPressed: () {},
          //         label: const Text("Show more"))
          //   ],
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_border_outlined),
            title: const Text("Close friends"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text("Blocked"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.sensors_off),
            title: const Text("Hide story and live"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

enum AccountPrivacy { private, public }
