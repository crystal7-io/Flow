import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';

class AppService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void changeTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  final Color _seedColor = const Color.fromARGB(255, 138, 82, 118);
  Color get seedColor => _seedColor;

  bool isDark(BuildContext context) {
    if (_themeMode == ThemeMode.dark) {
      return true;
    }
    if (_themeMode == ThemeMode.system &&
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark) {
      return true;
    }
    return false;
  }

  bool _isSearchFloating = true;
  bool get isSearchFloating => _isSearchFloating;

  void toggleSearchFloating() {
    _isSearchFloating = !_isSearchFloating;
    notifyListeners();
  }

  bool _isNavBarVisible = true;
  bool get isNavBarVisible => _isNavBarVisible;

  void setNavBarVisible(bool visible) {
    if (_isNavBarVisible != visible) {
      _isNavBarVisible = visible;
      notifyListeners();
    }
  }

  final List<Person> _myFollowers = [
    accounts[3].person,
    accounts[4].person,
    accounts[5].person,
    accounts[6].person,
    accounts[7].person,
    accounts[12].person,
    accounts[15].person,
    accounts[19].person,
    accounts[24].person,
  ];
  List<Person> get myFollowers => _myFollowers;

  final List<Person> _myFriends = []; // Initialize as needed
  List<Person> get myFriends => _myFriends;

  bool isFollowing(Person p) {
    return _myFollowers.any((element) => element.userName == p.userName);
  }

  bool isUserNameFollowing(String userName) {
    return _myFollowers.any((element) => element.userName == userName);
  }

  bool isFriend(Person p) {
    return _myFriends.any((element) => element.userName == p.userName);
  }

  void addFollower(Person p) {
    if (!isFollowing(p)) {
      _myFollowers.add(p);
      notifyListeners();
    }
  }

  void removeFollower(Person p) {
    _myFollowers.removeWhere((element) => element.userName == p.userName);
    notifyListeners();
  }
}
