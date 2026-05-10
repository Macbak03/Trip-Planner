import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/domain/models/auth/auth_error.dart';
import 'package:trip_planner/domain/models/user/user.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository})
    : _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _repeatPasswordController = TextEditingController(),
      _authRepository = authRepository {
    logout = Command0(_logout);
    loginWithEmail = Command0(_loginWithEmail);
    registerWithEmail = Command0(_registerWithEmail);
    resetPassword = Command0(_resetPassword);
  }

  final AuthRepository _authRepository;
  User? _user;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPasswordController;

  SelectedTab _selectedTab = SelectedTab.login;
  bool _obscurePassword = true;

  AuthError? _authError;

  // Getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get repeatPasswordController =>
      _repeatPasswordController;
  SelectedTab get selectedTab => _selectedTab;
  bool get obscurePassword => _obscurePassword;
  User? get user => _user;
  AuthError? get authError => _authError;

  final _log = Logger('AuthViewModel');

  set selectedTab(SelectedTab tab) {
    _selectedTab = tab;
    _authError = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void init() {
    _emailController.clear();
    _passwordController.clear();
    _selectedTab = SelectedTab.login;
    _obscurePassword = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  late Command0 logout;
  late Command0 registerWithEmail;
  late Command0 loginWithEmail;
  late Command0 resetPassword;

  Future<Result<void>> _loginWithEmail() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final result = await _authRepository.loginWithEmail(
      email: email,
      password: password,
    );
    if (result is Error<User>) {
      final error = result.error;
      _authError = error is AuthError ? error : null;
      _log.warning('Email login failed: $error');
      _user = null;
    } else if (result is Ok<User>) {
      _user = result.value;
      _authError = null;
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _registerWithEmail() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final repeatPassword = _repeatPasswordController.text;
    final result = await _authRepository.registerWithEmail(
      email: email,
      password: password,
      repeatPassword: repeatPassword,
    );
    if (result is Error<User>) {
      final err = result.error;
      _log.warning('Email register failed: $err');
      _user = null;
      _authError = err is AuthError
          ? err
          : AuthError(description: err.toString(), type: AuthErrorType.general);
    } else if (result is Ok<User>) {
      _user = result.value;
      _authError = null;
    } else if (result is Error<void>) {
      _log.warning('Email register failed: database error');
      _user = null;
      _authError = AuthError(
        description: "database error",
        type: AuthErrorType.general,
      );
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();
    if (result is Error<User>) {
      final err = result.error;
      _log.warning('Logout failed: $err');
      _authError = err is AuthError
          ? err
          : AuthError(description: err.toString(), type: AuthErrorType.general);
    } else if (result is Ok<void>) {
      _user = null;
      _authError = null;
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _resetPassword() async {
    final email = _emailController.text;
    final result = await _authRepository.resetPassword(email: email);
    if (result is Error<void>) {
      final err = result.error;
      _log.warning('Password reset failed: $err');
      _authError = err is AuthError
          ? err
          : AuthError(description: err.toString(), type: AuthErrorType.general);
    } else if (result is Ok<void>) {
      _authError = null;
    }
    notifyListeners();
    return result;
  }
}

enum SelectedTab { login, signup }
