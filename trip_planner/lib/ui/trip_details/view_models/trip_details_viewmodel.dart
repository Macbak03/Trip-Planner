import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/places/places_repository.dart';
import 'package:trip_planner/data/repositories/trips/trips_repository.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/domain/models/trip/trip_place.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/geo_distance.dart';
import 'package:trip_planner/utils/result.dart';

class TripMetaUpdate {
  const TripMetaUpdate({
    this.destination,
    this.destinationPlaceId,
    this.budget,
    this.startDate,
    this.endDate,
  });

  final String? destination;
  final String? destinationPlaceId;
  final double? budget;
  final DateTime? startDate;
  final DateTime? endDate;
}

class TripDetailsViewModel extends ChangeNotifier {
  TripDetailsViewModel({
    required this.tripId,
    required TripsRepository tripsRepository,
    required PlacesRepository placesRepository,
  }) : _tripsRepository = tripsRepository,
       _placesRepository = placesRepository {
    search = Command1(_search);
    addPlace = Command1(_addPlace);
    removePlace = Command1(_removePlace);
    loadSuggestedPlaces = Command0(_loadSuggestedPlaces);
    load = Command0(_load);
    updateTripMeta = Command1(_updateTripMeta);
    load.execute();
  }

  final String tripId;
  final TripsRepository _tripsRepository;
  final PlacesRepository _placesRepository;
  final _log = Logger('TripDetailsViewModel');

  late Command0<void> load;
  late Command1<List<Place>, String> search;
  late Command1<String, String> addPlace;
  late Command1<void, String> removePlace;
  late Command0<List<Place>> loadSuggestedPlaces;
  late Command1<void, TripMetaUpdate> updateTripMeta;

  Trip? _trip;
  StreamSubscription<List<TripPlace>>? _placesSub;
  List<TripPlace> _allPlaces = const <TripPlace>[];
  int _selectedDay = 1;
  List<Place> _searchResults = const <Place>[];
  List<Place> _suggestedPlaces = const <Place>[];
  Timer? _searchDebounce;
  String _lastQuery = '';

  Trip? get trip => _trip;
  int get selectedDay => _selectedDay;
  List<Place> get searchResults => _searchResults;
  List<Place> get suggestedPlaces => _suggestedPlaces;
  GeoCoordinates? get destinationCoords => _destinationCoords;

  GeoCoordinates? _destinationCoords;

  /// Total number of days in the trip (1-based). Defaults to 1 when trip is
  /// not yet loaded or has no dates.
  int get dayCount {
    final t = _trip;
    if (t == null) return 1;
    final span = t.endDate.difference(t.startDate).inDays + 1;
    return span < 1 ? 1 : span;
  }

  /// Places belonging to the currently selected day, ordered by `order`,
  /// with `distanceFromPrevKm` recomputed from the in-day sequence.
  List<TripPlace> get placesForSelectedDay => _placesForDay(_selectedDay);

  List<TripPlace> placesForDay(int dayIndex) => _placesForDay(dayIndex);

  List<TripPlace> _placesForDay(int dayIndex) {
    final filtered =
        _allPlaces.where((p) => p.dayIndex == dayIndex).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    final result = <TripPlace>[];
    for (var i = 0; i < filtered.length; i++) {
      if (i == 0) {
        result.add(filtered[i].copyWith(distanceFromPrevKm: null));
      } else {
        final prev = filtered[i - 1].location;
        final curr = filtered[i].location;
        double? km;
        if (prev != null && curr != null) {
          km = haversineKm(prev, curr);
        }
        result.add(filtered[i].copyWith(distanceFromPrevKm: km));
      }
    }
    return result;
  }

  void selectDay(int dayIndex) {
    if (dayIndex == _selectedDay) return;
    _selectedDay = dayIndex;
    notifyListeners();
  }

  void queueSearch(String query) {
    _searchDebounce?.cancel();
    final trimmed = query.trim();
    _lastQuery = trimmed;
    if (trimmed.isEmpty) {
      _searchResults = const <Place>[];
      notifyListeners();
      return;
    }
    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () => search.execute(trimmed),
    );
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    _lastQuery = '';
    if (_searchResults.isEmpty) return;
    _searchResults = const <Place>[];
    notifyListeners();
  }

  Future<Result<void>> _load() async {
    final result = await _tripsRepository.getTrip(tripId);
    switch (result) {
      case Ok<Trip?>():
        _trip = result.value;
        notifyListeners();
        _subscribeToPlaces();
        if (_trip != null) {
          unawaited(loadSuggestedPlaces.execute());
          unawaited(_refreshDestinationCoords());
        }
        return const Result.ok(null);
      case Error<Trip?>():
        _log.warning('load trip failed: ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<void> _refreshDestinationCoords() async {
    final coords = await _resolveDestinationCoords();
    if (coords == null) return;
    _destinationCoords = coords;
    notifyListeners();
  }

  void _subscribeToPlaces() {
    _placesSub?.cancel();
    _placesSub = _tripsRepository.streamTripPlaces(tripId).listen(
      (list) {
        _allPlaces = list;
        notifyListeners();
      },
      onError: (Object e, StackTrace st) {
        _log.warning('streamTripPlaces failed: $e');
      },
    );
  }

  Future<Result<List<Place>>> _search(String query) async {
    final t = _trip;
    final bias = t?.destinationPlaceId == null
        ? null
        : await _resolveDestinationCoords();
    final result = await _placesRepository.searchText(
      query,
      biasLocation: bias,
      maxResultCount: 10,
    );
    switch (result) {
      case Ok<List<Place>>():
        if (query == _lastQuery) {
          _searchResults = result.value;
          notifyListeners();
        }
        return result;
      case Error<List<Place>>():
        _log.warning('search failed: ${result.error}');
        return result;
    }
  }

  Future<GeoCoordinates?> _resolveDestinationCoords() async {
    final t = _trip;
    if (t == null) return null;
    final placeId = t.destinationPlaceId;
    if (placeId != null && placeId.isNotEmpty) {
      final r = await _placesRepository.getDetails(placeId);
      if (r is Ok<Place>) return r.value.location;
    }
    final r = await _placesRepository.searchText(
      t.destination,
      maxResultCount: 1,
    );
    if (r is Ok<List<Place>> && r.value.isNotEmpty) {
      return r.value.first.location;
    }
    return null;
  }

  Future<Result<String>> _addPlace(String placeId) async {
    final detailsResult = await _placesRepository.getDetails(placeId);
    if (detailsResult is Error<Place>) {
      _log.warning('addPlace getDetails failed: ${detailsResult.error}');
      return Result.error(detailsResult.error);
    }
    final place = (detailsResult as Ok<Place>).value;

    final dayPlaces = _placesForDay(_selectedDay);
    final nextOrder = dayPlaces.length;
    double? distanceFromPrev;
    if (dayPlaces.isNotEmpty && dayPlaces.last.location != null &&
        place.location != null) {
      distanceFromPrev = haversineKm(
        dayPlaces.last.location!,
        place.location!,
      );
    }

    return _tripsRepository.addTripPlace(
      tripId,
      placeId: place.id,
      dayIndex: _selectedDay,
      order: nextOrder,
      displayName: place.displayName,
      location: place.location,
      distanceFromPrevKm: distanceFromPrev,
    );
  }

  Future<Result<void>> _removePlace(String tripPlaceId) async {
    return _tripsRepository.removeTripPlace(tripId, tripPlaceId);
  }

  Future<Result<void>> _updateTripMeta(TripMetaUpdate update) async {
    final current = _trip;
    if (current == null) {
      return Result.error(Exception('Trip not loaded'));
    }
    final next = current.copyWith(
      destination: update.destination ?? current.destination,
      destinationPlaceId:
          update.destinationPlaceId ?? current.destinationPlaceId,
      budget: update.budget ?? current.budget,
      startDate: update.startDate ?? current.startDate,
      endDate: update.endDate ?? current.endDate,
    );
    final result = await _tripsRepository.updateTrip(next);
    switch (result) {
      case Ok<void>():
        _trip = next;
        notifyListeners();
        if (update.destination != null ||
            update.destinationPlaceId != null) {
          _destinationCoords = null;
          unawaited(loadSuggestedPlaces.execute());
          unawaited(_refreshDestinationCoords());
        }
        return const Result.ok(null);
      case Error<void>():
        _log.warning('updateTripMeta failed: ${result.error}');
        return result;
    }
  }

  String photoUrl(String photoRef, {int maxWidthPx = 200}) =>
      _placesRepository.photoUrl(photoRef, maxWidthPx: maxWidthPx);

  Future<Result<List<Place>>> _loadSuggestedPlaces() async {
    final coords = await _resolveDestinationCoords();
    if (coords == null) {
      _suggestedPlaces = const <Place>[];
      notifyListeners();
      return const Result.ok(<Place>[]);
    }
    final result = await _placesRepository.searchNearby(
      location: coords,
      radiusMeters: 5000,
      includedTypes: const <String>[
        'tourist_attraction',
        'museum',
        'restaurant',
      ],
      maxResultCount: 10,
    );
    switch (result) {
      case Ok<List<Place>>():
        _suggestedPlaces = result.value;
        notifyListeners();
        return result;
      case Error<List<Place>>():
        _log.warning('loadSuggestedPlaces failed: ${result.error}');
        return result;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _placesSub?.cancel();
    super.dispose();
  }
}
