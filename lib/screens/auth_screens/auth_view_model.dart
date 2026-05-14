import 'package:flutter/material.dart';
import 'package:redesigned/core/constants/app_config.dart';
import 'package:redesigned/core/constants/route_names.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';

enum AuthStep { email, otp, password, signup }

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final NavigationService _navService;

  AuthViewModel(this._authService, this._navService);

  AuthStep _currentStep = AuthStep.email;
  String _email = '';
  String _password = '';
  String? _errorMessage;

  final List<String> _existingUsers = [
    'tejasj29067@gmail.com',
    'crystalarcus@gmail.com'
  ];

  String get password => _password;
  AuthStep get currentStep => _currentStep;
  String? get errorMessage => _errorMessage;

  void setEmail(String email) {
    _email = email;
    _errorMessage = null;
    notifyListeners();
  }

  bool proceedEmail() {
    if (!AppConfig.useAuth) {
      _currentStep = AuthStep.password;
      _errorMessage = null;
      notifyListeners();
      return true;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_email)) {
      _errorMessage = 'Invalid email format';
      notifyListeners();
      return false;
    }
    
    if (_existingUsers.contains(_email)) {
      _currentStep = AuthStep.password;
    } else {
      _currentStep = AuthStep.otp;
    }
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  void verifyOtp(String otp) {
    if (!AppConfig.useAuth || otp == '111222') {
      _currentStep = AuthStep.signup;
      _errorMessage = null;
    } else {
      _errorMessage = 'Invalid OTP';
    }
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
  }

  Future<void> validatePassword() async {
    if (!AppConfig.useAuth || _password == '123456') {
      // Logic for successful login
      if (AppConfig.useAuth) {
        await _authService.signInWithEmailAndPassword(_email, _password);
      }
      _errorMessage = null;
      _navService.go(RouteNames.HOME_SCREEN);
    } else {
      _errorMessage = 'Wrong password';
    }
    notifyListeners();
  }

  void reset() {
    _currentStep = AuthStep.email;
    _email = '';
    _password = '';
    _errorMessage = null;
    notifyListeners();
  }
}
