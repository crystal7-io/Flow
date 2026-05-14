import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:redesigned/core/constants/app_config.dart';
import 'package:redesigned/core/services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = false;

  SignUpViewModel(this._authService) {
    if (AppConfig.useAuth) {
      _authService.userChanges.listen((user) {
        _user = user;
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null || !AppConfig.useAuth;

  /// Text editing controller for username
  final TextEditingController userNameController = TextEditingController();

  /// Text editing controller for password
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp() async {
    if (!AppConfig.useAuth) {
      // Simulate success navigation
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpWithEmailAndPassword(
          userNameController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Error (SignUp): ${e.code} - ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('General Error (SignUp): $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
