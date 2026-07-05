// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:redesigned/core/utils/animations.dart';
import 'package:redesigned/data/mock_data.dart';
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
      backgroundColor: Colors.transparent,
      child: NavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        onDestinationSelected: onDestinationSelected,
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: selectedIndex,
        animationDuration: const Duration(milliseconds: 600),
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Symbols.home),
            selectedIcon: Icon(Symbols.home, fill: 1),
            label: "Home",
          ),
          const NavigationDestination(
            icon: Icon(Symbols.animated_images),
            selectedIcon: Icon(Symbols.animated_images, fill: 1),
            label: "Create",
          ),
          const NavigationDestination(
            icon: Icon(Symbols.message),
            selectedIcon: Icon(Symbols.message, fill: 1),
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
            icon: Icon(Symbols.settings),
            selectedIcon: Icon(Symbols.settings, fill: 1),
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
