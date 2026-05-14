import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/constants/app_config.dart';
import 'package:redesigned/core/constants/route_names.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';
import 'package:redesigned/core/services/user_data_service.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthService _authService;

  final NavigationService _navService;

  final UserDataService _userDataService;

  User? _user;
  bool _isLoading = false;

  SignInViewModel(this._authService, this._navService, this._userDataService) {
    _authService.userChanges.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null || !AppConfig.useAuth;

  /// Text editing controller for username
  final TextEditingController emailController = TextEditingController(text: "");

  /// Text editing controller for password
  final TextEditingController passwordController =
      TextEditingController(text: "");

  /// Login using user entered credentials
  Future<void> onLoginPress() async {
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      if (!AppConfig.useAuth) {
        _navService.go(RouteNames.HOME_SCREEN);
        return;
      }
      _isLoading = true;
      notifyListeners();
      try {
        UserCredential? creds = await _authService.signInWithEmailAndPassword(
            emailController.text, passwordController.text);
        if (creds != null) {
          await _userDataService.fetchData(creds.user!.uid);
        }
      } catch (e) {
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
        _navService.go(RouteNames.HOME_SCREEN);
      }
    } else {
      // TODO: Show snackbar that email/password is empty
    }
  }

  /// Navigate to Forget password screen
  void onForgetPasswordPress() {
    _navService.go(RouteNames.FORGET_PASSWORD_SCREEN);
  }

  // Navigate to Sign up page
  void onSignUpPress() {
    _navService.push(RouteNames.SIGN_UP_SCREEN);
  }
}
