import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/data/repositories/places/places_repository.dart';
import 'package:trip_planner/data/repositories/trips/trips_repository.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/place/place_suggestion.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/domain/models/trip/trip_draft.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/result.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AuthRepository authRepository,
    required TripsRepository tripsRepository,
    required PlacesRepository placesRepository,
  }) : _authRepository = authRepository,
       _tripsRepository = tripsRepository,
       _placesRepository = placesRepository {
    logout = Command0(_logout);
    startPlanning = Command0(_startPlanning);
    queryDestination = Command1(_queryDestination);
    loadSuggestedCountries = Command0(_loadSuggestedCountries);
    loadSuggestedCountries.execute();
  }

  static const List<String> _fallbackCountries = <String>[
    'Hungary',
    'Italy',
    'France',
    'Spain',
    'Japan',
    'Greece',
    'Portugal',
    'Thailand',
  ];

  final AuthRepository _authRepository;
  final TripsRepository _tripsRepository;
  final PlacesRepository _placesRepository;
  final _log = Logger('HomeViewModel');

  late Command0 logout;
  late Command0<String> startPlanning;
  late Command1<List<PlaceSuggestion>, String> queryDestination;
  late Command0 loadSuggestedCountries;

  TripDraft _draft = const TripDraft();
  String? _createdTripId;
  String? _formError;
  List<PlaceSuggestion> _destinationSuggestions = const <PlaceSuggestion>[];
  List<Place> _suggestedCountries = const <Place>[];
  Timer? _autocompleteDebounce;
  String _autocompleteSessionToken = const Uuid().v4();

  TripDraft get draft => _draft;
  String? get createdTripId => _createdTripId;
  String? get formError => _formError;
  List<PlaceSuggestion> get destinationSuggestions => _destinationSuggestions;
  List<Place> get suggestedCountries => _suggestedCountries;

  String? get email => _authRepository.getUser()?.email;

  Stream<List<Trip>> get plannedTrips => _tripsRepository.streamMyTrips();

  void setDestination(String value) {
    _draft = _draft.copyWith(destination: value, destinationPlaceId: null);
    _formError = null;
    notifyListeners();
    _scheduleAutocomplete(value);
  }

  void selectDestinationSuggestion(PlaceSuggestion suggestion) {
    _draft = _draft.copyWith(
      destination: suggestion.mainText,
      destinationPlaceId: suggestion.placeId,
    );
    _destinationSuggestions = const <PlaceSuggestion>[];
    _autocompleteSessionToken = const Uuid().v4();
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

  void _scheduleAutocomplete(String value) {
    _autocompleteDebounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _destinationSuggestions = const <PlaceSuggestion>[];
      notifyListeners();
      return;
    }
    _autocompleteDebounce = Timer(
      const Duration(milliseconds: 300),
      () => queryDestination.execute(trimmed),
    );
  }

  Future<Result<List<PlaceSuggestion>>> _queryDestination(String query) async {
    final result = await _placesRepository.autocomplete(
      query,
      sessionToken: _autocompleteSessionToken,
    );
    switch (result) {
      case Ok<List<PlaceSuggestion>>():
        _destinationSuggestions = result.value;
        notifyListeners();
        return result;
      case Error<List<PlaceSuggestion>>():
        _log.warning('autocomplete failed: ${result.error}');
        return result;
    }
  }

  Future<Result<void>> _loadSuggestedCountries() async {
    // top types from user history will personalise this
    // list once `trips/{id}/places` exists. For now we use a static
    // popular-countries list and ignore the (currently empty) top types.
    await _tripsRepository.getUserTopPlaceTypes();
    final result =
        await _placesRepository.getSuggestedCountries(_fallbackCountries);
    switch (result) {
      case Ok<List<Place>>():
        _suggestedCountries = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error<List<Place>>():
        _log.warning('loadSuggestedCountries failed: ${result.error}');
        return Result.error(result.error);
    }
  }

  String suggestedCountryPhotoUrl(Place place, {int maxWidthPx = 600}) {
    if (place.photoRefs.isEmpty) return '';
    return _placesRepository.photoUrl(place.photoRefs.first, maxWidthPx: maxWidthPx);
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
        _destinationSuggestions = const <PlaceSuggestion>[];
        _autocompleteSessionToken = const Uuid().v4();
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

  @override
  void dispose() {
    _autocompleteDebounce?.cancel();
    super.dispose();
  }
}
