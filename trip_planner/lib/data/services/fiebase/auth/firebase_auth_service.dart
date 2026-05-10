import 'package:trip_planner/domain/models/user/user.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_planner/domain/models/auth/auth_error.dart';
import 'package:trip_planner/utils/result.dart';

class FirebaseAuthService {
  FirebaseAuthService({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  // Email and password login
  Future<Result<user_model.User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUserToUser(userCredential.user!);
      return Result.ok(user);
    } on FirebaseAuthException catch (e) {
      return Result.error((_handleAuthException(e)));
    } catch (e) {
      return Result.error(
        (AuthError(
          description: 'An unexpected error occurred: ${e.toString()}',
          type: AuthErrorType.general,
        )),
      );
    }
  }

  // Email and password registration
  Future<Result<user_model.User>> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUserToUser(userCredential.user!);
      return Result.ok(user);
    } on FirebaseAuthException catch (e) {
      return Result.error((_handleAuthException(e)));
    } catch (e) {
      return Result.error(
        (AuthError(
          description: 'An unexpected error occurred: ${e.toString()}',
          type: AuthErrorType.general,
        )),
      );
    }
  }

  // Logout
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Result.ok(null);
    } catch (e) {
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
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Result.ok(null);
    } on FirebaseAuthException catch (e) {
      return Result.error((_handleAuthException(e)));
    } catch (e) {
      return Result.error(
        (AuthError(
          description: 'Password reset failed: ${e.toString()}',
          type: AuthErrorType.general,
        )),
      );
    }
  }

  user_model.User? getUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser != null ? _mapFirebaseUserToUser(firebaseUser) : null;
  }

  String? getUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  user_model.User _mapFirebaseUserToUser(User firebaseUser) {
    return user_model.User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }

  // Helper method to handle Firebase auth exceptions
  // handles old and new error codes
  AuthError _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return AuthError(
          description: 'No user found with this email',
          type: AuthErrorType.email,
        );
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return AuthError(
          description: 'Incorrect password or email',
          type: AuthErrorType.password,
        );
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return AuthError(
          description: 'Email is already in use',
          type: AuthErrorType.email,
        );
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return AuthError(
          description: 'Email address is not valid',
          type: AuthErrorType.email,
        );
      case 'weak-password':
        return AuthError(
          description: 'Password is too weak',
          type: AuthErrorType.password,
        );
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return AuthError(
          description: 'Too many requests. Try again later.',
          type: AuthErrorType.general,
        );
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return AuthError(
          description: 'This user account has been disabled.',
          type: AuthErrorType.general,
        );
      case "invalid-credential":
        return AuthError(
          description: 'Incorrect password or email',
          type: AuthErrorType.password,
        );
      default:
        return AuthError(
          description: 'Authentication failed: ${e.message}',
          type: AuthErrorType.general,
        );
    }
  }
}
