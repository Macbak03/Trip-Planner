import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/data/repositories/trips/trips_repository.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/domain/models/trip/trip_draft.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AuthRepository authRepository,
    required TripsRepository tripsRepository,
  }) : _authRepository = authRepository,
       _tripsRepository = tripsRepository {
    logout = Command0(_logout);
    startPlanning = Command0(_startPlanning);
  }

  final AuthRepository _authRepository;
  final TripsRepository _tripsRepository;
  final _log = Logger('HomeViewModel');

  late Command0 logout;
  late Command0<String> startPlanning;

  TripDraft _draft = const TripDraft();
  String? _createdTripId;
  String? _formError;

  TripDraft get draft => _draft;
  String? get createdTripId => _createdTripId;
  String? get formError => _formError;

  String? get email => _authRepository.getUser()?.email;

  Stream<List<Trip>> get plannedTrips => _tripsRepository.streamMyTrips();

  void setDestination(String value) {
    _draft = _draft.copyWith(destination: value, destinationPlaceId: null);
    _formError = null;
    notifyListeners();
  }

  void setBudget(String value) {
    _draft = _draft.copyWith(
      budget: double.tryParse(value.replaceAll(',', '.')),
    );
    _formError = null;
    notifyListeners();
  }

  void setDateRange(DateTime start, DateTime end) {
    _draft = _draft.copyWith(startDate: start, endDate: end);
    _formError = null;
    notifyListeners();
  }

  void clearCreatedTripId() {
    _createdTripId = null;
  }

  Future<Result<String>> _startPlanning() async {
    final destination = _draft.destination.trim();
    if (destination.isEmpty) {
      return _fail('Wpisz cel podróży');
    }
    final budget = _draft.budget;
    if (budget == null || budget <= 0) {
      return _fail('Podaj budżet większy od zera');
    }
    final start = _draft.startDate;
    final end = _draft.endDate;
    if (start == null || end == null) {
      return _fail('Wybierz zakres dat');
    }

    final result = await _tripsRepository.createTrip(
      destination: destination,
      destinationPlaceId: _draft.destinationPlaceId,
      budget: budget,
      currency: _draft.currency,
      startDate: start,
      endDate: end,
    );
    switch (result) {
      case Ok<String>():
        _createdTripId = result.value;
        _formError = null;
        _draft = const TripDraft();
        notifyListeners();
        return result;
      case Error<String>():
        _log.warning('Create trip failed: ${result.error}');
        return _fail('Nie udało się utworzyć wycieczki');
    }
  }

  Result<String> _fail(String message) {
    _formError = message;
    notifyListeners();
    return Result.error(Exception(message));
  }

  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();
    if (result is Error<void>) {
      _log.warning('Logout failed: ${result.error}');
    }
    notifyListeners();
    return result;
  }
}
