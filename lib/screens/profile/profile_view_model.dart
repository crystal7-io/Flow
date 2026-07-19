import 'package:flutter/material.dart';
import 'package:redesigned/core/models/profile.dart';
import 'package:redesigned/data/repositories/user_profile_repository.dart';

abstract class IProfileViewModel {
  Profile? get profile;
  late final TabController tabController;

  /// Data loaded boolean check
  bool get isDataLoaded;

  /// Get profile data of person user is viewing
  /// A placeholder should be showing till data loads
  Future<void> getProfileData();

  /// Follow/Unfollow a profile
  Future<void> toggleFollow();
}

class ProfileViewModel extends ChangeNotifier implements IProfileViewModel {
  /// Constructor, it takes [UserProfileRepository] as argument
  ProfileViewModel(this._repository);

  bool _isDataLoaded = false;
  @override
  bool get isDataLoaded => _isDataLoaded;

  final UserProfileRepository _repository;

  @override
  Profile? get profile => _repository.profile;

  @override
  late final TabController tabController;

  @override
  Future<void> toggleFollow() async {
    _repository.toggleFollow();
  }

  /// Get Profile Data from Repository
  @override
  Future<void> getProfileData() async {
    _isDataLoaded = false;
    notifyListeners();
    try {
      await _repository.getProfileData();
    } catch (e) {
      rethrow;
    } finally {
      _isDataLoaded = true;
    }
    notifyListeners();
  }
}
