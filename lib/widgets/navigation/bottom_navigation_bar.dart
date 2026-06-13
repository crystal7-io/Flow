// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:redesigned/data/mock_data.dart';

import 'package:redesigned/core/utils/animations.dart';
import 'package:redesigned/widgets/navigation/bottom_bar_transition.dart';

class DisappearingBottomNavigationBar extends StatelessWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final BarAnimation barAnimation;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: barAnimation,
      backgroundColor: Colors.white,
      child: NavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        onDestinationSelected: onDestinationSelected,
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: selectedIndex,
        animationDuration: const Duration(milliseconds: 600),
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          const NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle),
            label: "Reels",
          ),
          const NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: "Message",
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: notifications[0].isNotEmpty,
              label: Text(notifications[0].length.toString()),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: "Alerts",
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        // destinations: destinations.map<NavigationDestination>((d) {
        //   return NavigationDestination(
        //     icon: Icon(d.icon),
        //     label: d.label,
        //   );
        // }).toList(),
        // selectedIndex: selectedIndex,
        // onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
