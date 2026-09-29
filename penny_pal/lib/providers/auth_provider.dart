import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:penny_pal/models/user_model.dart';
import 'package:penny_pal/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUserData;
  bool _isLoading = false;
  String? _error;
  bool _hasShownTutorialThisSession = false;

  UserModel? get currentUserData => _currentUserData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;
  bool get hasShownTutorialThisSession => _hasShownTutorialThisSession;

  void markTutorialAsShownLocally() {
    _hasShownTutorialThisSession = true;
  }

  AuthProvider() {
    _initAuthListener();
  }

  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        _currentUserData = await _authService.getUserData(user.uid);
      } else {
        _currentUserData = null;
      }
      notifyListeners();
    });
  }

  Future<void> refreshUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserData = await _authService.getUserData(user.uid);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _currentUserData = await _authService.logIn(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _currentUserData = await _authService.signUp(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logOut();
    _currentUserData = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _error = null;
    notifyListeners();
  }

  void _handleError(dynamic e) {
    _isLoading = false;
    if (e is FirebaseAuthException) {
      _error = e.message ?? 'Authentication failed.';
    } else {
      _error = 'An unexpected error occurred.';
    }
    notifyListeners();
  }
}
