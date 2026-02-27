import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Manages authentication state throughout the app
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    // Listen for auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user != null) {
      _userModel = await _firestoreService.getUserProfile(user.uid);
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  /// Sign up with email, password and display name
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    try {
      final credential = await _authService.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      // Save user profile to Firestore
      final user = UserModel(
        uid: credential.user!.uid,
        email: email.trim(),
        displayName: displayName.trim(),
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveUserProfile(user);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = AuthService.mapAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmail(email: email, password: password);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = AuthService.mapAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out
  Future<void> logout() async {
    await _authService.signOut();
  }

  /// Clear any previous error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
