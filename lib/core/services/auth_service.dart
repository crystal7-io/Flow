import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:redesigned/core/constants/app_config.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth? _firebaseAuth =
      AppConfig.useAuth ? FirebaseAuth.instance : null;

  /// Currently signed in User
  User? _currentUser;

  AuthService._() {
    if (AppConfig.useAuth && _firebaseAuth != null) {
      _firebaseAuth.authStateChanges().listen((user) {
        _currentUser = user;
        notifyListeners();
      });
    }
  }
  static AuthService? _instance;
  factory AuthService() {
    _instance ??= AuthService._();
    return _instance!;
  }
  User? get currentUser => _currentUser;
  Future<bool> isLoggedIn() async {
    if (!AppConfig.useAuth) return true;
    return _firebaseAuth?.currentUser != null;
  }

  // Stream to listen to authentication state changes
  Stream<User?> get userChanges => AppConfig.useAuth && _firebaseAuth != null
      ? _firebaseAuth.authStateChanges()
      : const Stream.empty();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    if (!AppConfig.useAuth || _firebaseAuth == null) return null;
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    if (!AppConfig.useAuth || _firebaseAuth == null) return null;
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (!AppConfig.useAuth || _firebaseAuth == null) return;
    await _firebaseAuth.signOut();
  }
}
