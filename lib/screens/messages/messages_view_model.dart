import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';

// Filters indices
int unread = 0;
int group = 1;
int starred = 2;

class MessagesViewModel extends ChangeNotifier {
  Set<int> _currentFilters = {};
  Set<int> get currentFilters => _currentFilters;

  List<Chat> _chatData = chats;
  List<Chat> get chatData => _chatData;

  Person? _currentActive;
  Person? get currentActive => _currentActive;

  void selectActiveChat(Person? person) {
    _currentActive = person;
    notifyListeners();
  }

  /// Function called when a filter is selected on UI side
  /// This changes [_currentFilters] indices and calls [_applyFilters]
  /// Method which applies filters
  void toggleFilter(int filter, bool value) {
    if (filter == -1 && value) {
      _currentFilters.removeAll({0, 1, 2});
    } else {
      if (value) {
        _currentFilters.add(filter);
      } else {
        _currentFilters.remove(filter);
      }
    }
    _applyFilters();
    notifyListeners();
  }

  /// This function applies filters to [_chatData] based on
  /// Filters indices in [_currentFilters]
  void _applyFilters() {
    _chatData = chats;
    // Unread Filter
    if (_currentFilters.contains(unread)) {
      _chatData = _chatData.where((element) => element.newMessage > 0).toList();
    }

    // Groups Filter
    // (NOTE:Currently set to return false always as data dont have Groups Items)
    if (_currentFilters.contains(group)) {
      _chatData = _chatData.where((element) => false).toList();
    }

    // Starred Filter
    // (NOTE:Currently set to return false always as data dont have starred Items)
    if (_currentFilters.contains(starred)) {
      _chatData = _chatData.where((element) => false).toList();
    }
  }
}
