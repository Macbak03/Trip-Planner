import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<User?>? _authSubscription;
  User? _user;
  bool _isInitialized = false;

  AuthNotifier({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      
      // Get current user
      _user = _firebaseAuth.currentUser;
      
      // Listen to auth state changes FIRST (before notifying)
      // Skip the first event since we already have the current user
      _authSubscription = _firebaseAuth.authStateChanges().skip(1).listen(
        (User? user) {
          _user = user;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('[AuthNotifier] Auth state error: $error');
        },
      );
      
      // Mark as initialized and notify ONCE
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      notifyListeners();
    }
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  @override
  void dispose() {
    debugPrint('AuthNotifier: Disposing');
    _authSubscription?.cancel();
    super.dispose();
  }
}