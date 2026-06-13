import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';

class MessagesViewModel extends ChangeNotifier {
  final Set<String> _currentFilters = {};
  Set<String> get currentFilters => _currentFilters;

  List<Chat> _chatData = chats;
  List<Chat> get chatData => _chatData;

  Person? _currentActive;
  Person? get currentActive => _currentActive;

  void selectActiveChat(Person? person) {
    _currentActive = person;
    notifyListeners();
  }

  void toggleFilter(String filter, bool isSelected) {
    if (isSelected) {
      _currentFilters.add(filter);
    } else {
      _currentFilters.remove(filter);
    }
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_currentFilters.isEmpty) {
      _chatData = chats;
    } else {
      _chatData = chats.where((element) {
        if (element.newMessage > 0 && _currentFilters.contains('Unread')) {
          return true;
        } else if (element.newMessage == 0 &&
            _currentFilters.contains('Read')) {
          return true;
        } else if (element.isActive && _currentFilters.contains('Active')) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
  }
}
