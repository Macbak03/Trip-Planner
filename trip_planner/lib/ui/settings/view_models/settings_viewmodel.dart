import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/domain/models/auth/auth_error.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    logout = Command0(_logout);
    deleteAccount = Command0(_deleteAccount);
  }

  final AuthRepository _authRepository;
  final _log = Logger('SettingsViewModel');

  late final Command0 logout;
  late final Command0 deleteAccount;

  AuthError? _error;

  /// Email of the signed-in user, shown under "Logged in as".
  String? get userEmail => _authRepository.getUser()?.email;

  /// Last error from logout / account deletion, for UI feedback.
  AuthError? get error => _error;

  Future<Result<void>> _logout() async {
    _error = null;
    final result = await _authRepository.logout();
    if (result is Error<void>) {
      _error = _asAuthError(result.error);
      _log.warning('Logout failed: ${result.error}');
    }
    notifyListeners();
    return result;
  }

  Future<Result<void>> _deleteAccount() async {
    _error = null;
    final result = await _authRepository.deleteAccount();
    if (result is Error<void>) {
      _error = _asAuthError(result.error);
      _log.warning('Account deletion failed: ${result.error}');
    }
    notifyListeners();
    return result;
  }

  AuthError _asAuthError(Object error) => error is AuthError
      ? error
      : AuthError(description: error.toString(), type: AuthErrorType.general);
}
