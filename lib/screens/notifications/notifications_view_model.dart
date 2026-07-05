import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';

class NotificationsViewModel extends ChangeNotifier {
  final List<String> notifFilters = [
    "Story likes",
    "Comment likes",
    "Post like",
    "Story replies",
    "Comment replies",
    "Post replies",
    "Suggestions",
  ];

  final List<String> _selectedFilters = [];
  List<String> get selectedFilters => _selectedFilters;

  List<List<Notif>> get allNotifications => notifications;

  void toggleFilter(String filter, bool selected) {
    if (selected) {
      _selectedFilters.add(filter);
    } else {
      _selectedFilters.remove(filter);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // Move "New" notifications to "Today" when screen is closed
    // This matches the original dispose logic in lib/notification_screen.dart
    notifications[1] = [...notifications[0], ...notifications[1]];
    notifications[0] = [];
    super.dispose();
  }
}
