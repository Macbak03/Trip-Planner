import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    logout = Command0(_logout);
  }

  final AuthRepository _authRepository;
  final _log = Logger('HomeViewModel');

  late Command0 logout;

  String? get email => _authRepository.getUser()?.email;

  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();
    if (result is Error<void>) {
      _log.warning('Logout failed: ${result.error}');
    }
    notifyListeners();
    return result;
  }
}
