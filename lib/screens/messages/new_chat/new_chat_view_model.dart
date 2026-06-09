import 'package:flutter/material.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/data/mock_data.dart';

class NewChatViewModel extends ChangeNotifier {
  final List<String> _selectedUserNames = [];
  List<String> get selectedUserNames => _selectedUserNames;

  final SearchController searchController = SearchController();

  List<Person> get shownAccounts {
    if (searchController.text.isEmpty) {
      return myFollowersConst;
    } else {
      return myFollowersConst
          .where(
            (element) =>
                element.name.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                element.userName.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void toggleSelection(String userName) {
    if (_selectedUserNames.contains(userName)) {
      _selectedUserNames.remove(userName);
    } else {
      _selectedUserNames.add(userName);
    }
    notifyListeners();
  }

  void removeSelection(String userName) {
    _selectedUserNames.remove(userName);
    notifyListeners();
  }

  void onBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
