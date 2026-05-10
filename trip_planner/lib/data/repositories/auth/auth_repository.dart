import 'package:logging/logging.dart';
import 'package:trip_planner/data/services/fiebase/auth/firebase_auth_service.dart';
import 'package:trip_planner/domain/models/auth/auth_error.dart';
import 'package:trip_planner/domain/models/user/user.dart';
import 'package:trip_planner/utils/result.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService;
  final FirebaseAuthService _firebaseAuthService;
  final _log = Logger('AuthRepository');

  User? _user;

  // Email and password login
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      final err = AuthError(
        description: 'Email must not be empty',
        type: AuthErrorType.email,
      );
      return Result.error(err);
    }
    if (password.isEmpty) {
      final err = AuthError(
        description: 'Password must not be empty',
        type: AuthErrorType.password,
      );
      return Result.error(err);
    }
    final result = await _firebaseAuthService.loginWithEmail(
      email: email,
      password: password,
    );
    switch (result) {
      case Ok<User>():
        _user = result.value;
      case Error<User>():
        _log.warning('Login with email failed: ${result.error}');
        return Result.error(result.error);
    }
    return result;
  }

  // Email and password registration
  Future<Result<User>> registerWithEmail({
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    if (email.isEmpty) {
      final err = AuthError(
        description: 'Email must not be empty',
        type: AuthErrorType.email,
      );
      return Result.error(err);
    }
    if (password.isEmpty) {
      final err = AuthError(
        description: 'Password must not be empty',
        type: AuthErrorType.password,
      );
      return Result.error(err);
    }
    if (password != repeatPassword) {
      _log.warning('Password and repeat password do not match');
      final err = AuthError(
        description: 'Password and repeat password do not match',
        type: AuthErrorType.repeatPassword,
      );
      return Result.error(err);
    }
    final result = await _firebaseAuthService.registerWithEmail(
      email: email,
      password: password,
    );
    switch (result) {
      case Ok<User>():
        _user = result.value;
      case Error<User>():
        _log.warning('Registration with email failed: ${result.error}');
        return Result.error(result.error);
    }
    return result;
  }

  // Logout
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuthService.logout();
      _user = _firebaseAuthService.getUser();
      return Result.ok(null);
    } catch (e) {
      _log.warning('Logout failed: ${e.toString()}');
      return Result.error(
        (AuthError(
          description: 'Logout failed: ${e.toString()}',
          type: AuthErrorType.general,
        )),
      );
    }
  }

  // Reset password
  Future<Result<void>> resetPassword({required String email}) async {
    if (email.isEmpty) {
      final err = AuthError(
        description: 'Email must not be empty',
        type: AuthErrorType.email,
      );
      return Result.error(err);
    }

    final result = await _firebaseAuthService.resetPassword(email: email);
    switch (result) {
      case Ok<void>():
        return Result.ok(null);
      case Error<void>():
        _log.warning('Reset password failed: ${result.error}');
        return Result.error(result.error);
    }
  }

  User? getUser() {
    _user = _firebaseAuthService.getUser();
    return _user;
  }
}
