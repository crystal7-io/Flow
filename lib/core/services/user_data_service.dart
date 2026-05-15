import 'package:flutter/cupertino.dart';
import 'package:redesigned/core/models/user.dart';
import 'package:redesigned/data/repositories/user_repository.dart';

class UserDataService extends ChangeNotifier {
  bool _isLoaded = false;
  User? _user;

  UserDataService(this._userRepository) {
    _loadLocalUser();
  }

  Future<void> _loadLocalUser() async {
    try {
      _user = await _userRepository.getUserData('');
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading local user: $e');
    }
  }

  /// Data fetching check
  bool get isLoaded => _isLoaded;

  /// Instance of [User]
  User? get user => _user;

  /// Instance of [UserRepository] for fetching/updating data;
  final UserRepository _userRepository;

  /// Fetch User data from [UserRepository]
  Future fetchData(String userID) async {
    _isLoaded = false;
    notifyListeners();
    try {
      _user = await _userRepository.getUserData(userID);
    } catch (e) {
      rethrow;
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }
}
