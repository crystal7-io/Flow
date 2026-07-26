import 'package:flutter/material.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);
  final IconData icon;
  final String label;
  final IconData selectedIcon;
}

const List<Destination> destinations = <Destination>[
  Destination("Home", Icons.home_outlined, Icons.home),
  Destination("Message", Icons.chat_outlined, Icons.chat),
  Destination("Notification", Icons.notifications_outlined, Icons.notifications),
  Destination("Settings", Icons.settings_outlined, Icons.settings),
];
