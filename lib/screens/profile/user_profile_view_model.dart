import 'package:flutter/material.dart';
import 'package:redesigned/core/services/user_data_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserDataService _userDataService;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String _originalUserName = '';
  String _originalDisplayName = '';
  String _originalBio = '';

  bool _isDirty = false;
  bool get isDirty => _isDirty;

  UserProfileViewModel(this._userDataService) {
    _userDataService.addListener(_onUserDataChanged);
    _onUserDataChanged();

    userNameController.addListener(_checkChanges);
    displayNameController.addListener(_checkChanges);
    bioController.addListener(_checkChanges);
  }

  void _onUserDataChanged() {
    if (_userDataService.user != null) {
      _originalUserName = _userDataService.user!.userName;
      _originalDisplayName = _userDataService.user!.name;
      _originalBio = _userDataService.user!.bio ?? '';

      // Only update if current text is empty to avoid overwriting user edits
      if (userNameController.text.isEmpty) {
        userNameController.text = _originalUserName;
      }
      if (displayNameController.text.isEmpty) {
        displayNameController.text = _originalDisplayName;
      }
      if (bioController.text.isEmpty) {
        bioController.text = _originalBio;
      }
      notifyListeners();
    }
  }

  void _checkChanges() {
    bool dirty = userNameController.text != _originalUserName ||
        displayNameController.text != _originalDisplayName ||
        bioController.text != _originalBio;
    if (dirty != _isDirty) {
      _isDirty = dirty;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userDataService.removeListener(_onUserDataChanged);
    userNameController.dispose();
    displayNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (!_isDirty) return;
    // Logic to save profile data via _userDataService
    // Assuming _userDataService has an update method
    _originalUserName = userNameController.text;
    _originalDisplayName = displayNameController.text;
    _originalBio = bioController.text;
    _isDirty = false;
    notifyListeners();
  }
}
