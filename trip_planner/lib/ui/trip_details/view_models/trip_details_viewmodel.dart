import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/places/places_repository.dart';
import 'package:trip_planner/data/repositories/trips/trips_repository.dart';
import 'package:trip_planner/data/services/google/directions/google_directions_service.dart';
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
    required GoogleDirectionsService directionsService,
  }) : _tripsRepository = tripsRepository,
       _placesRepository = placesRepository,
       _directionsService = directionsService {
    // Restore the previously selected day for this trip. The view model is
    // recreated when navigating back from Place Details (go_router rebuilds the
    // route), so without this the day would reset to 1 on every return.
    _selectedDay = _lastSelectedDayByTrip[tripId] ?? 1;
    search = Command1(_search);
    addPlace = Command1(_addPlace);
    removePlace = Command1(_removePlace);
    loadSuggestedPlaces = Command0(_loadSuggestedPlaces);
    load = Command0(_load);
    updateTripMeta = Command1(_updateTripMeta);
    load.execute();
  }

  /// Remembers the last selected day per trip across view model recreations.
  static final Map<String, int> _lastSelectedDayByTrip = <String, int>{};

  final String tripId;
  final TripsRepository _tripsRepository;
  final PlacesRepository _placesRepository;
  final GoogleDirectionsService _directionsService;
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

  /// Top 10 suggested places that the user has NOT already added to this trip.
  /// Backed by a larger pool fetched up-front so the visible list stays roughly
  /// constant as places are added.
  List<Place> get suggestedPlaces {
    if (_suggestedPlaces.isEmpty) return const <Place>[];
    final inTrip = _allPlaces.map((tp) => tp.placeId).toSet();
    return _suggestedPlaces
        .where((p) => !inTrip.contains(p.id))
        .take(10)
        .toList();
  }

  GeoCoordinates? get destinationCoords => _destinationCoords;
  List<GeoCoordinates> get routePolyline => _routePolyline;

  GeoCoordinates? _destinationCoords;
  List<GeoCoordinates> _routePolyline = const <GeoCoordinates>[];
  String _lastRouteKey = '';

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
    _lastSelectedDayByTrip[tripId] = dayIndex;
    notifyListeners();
    unawaited(_refreshRoute());
  }

  /// Fetches a real walking route between the selected day's places via the
  /// Directions API and stores it as the displayable polyline. Falls back to
  /// an empty polyline (no route drawn) if Directions is unavailable.
  /// De-duplicates by a key built from ordered place IDs to avoid re-requests.
  Future<void> _refreshRoute() async {
    final places = placesForSelectedDay
        .where((p) => p.location != null)
        .toList();
    final key = '$_selectedDay|${places.map((p) => p.placeId).join(',')}';
    if (key == _lastRouteKey) return;
    _lastRouteKey = key;
    if (places.length < 2) {
      if (_routePolyline.isNotEmpty) {
        _routePolyline = const <GeoCoordinates>[];
        notifyListeners();
      }
      return;
    }
    final waypoints = places.map((p) => p.location!).toList();
    final result = await _directionsService.getRouteWalking(waypoints);
    if (_lastRouteKey != key) return; // stale response, day/list changed
    _routePolyline = result;
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
        unawaited(_refreshRoute());
      },
      onError: (Object e, StackTrace st) {
        _log.warning('streamTripPlaces failed: $e');
      },
    );
  }

  Future<Result<List<Place>>> _search(String query) async {
    final coords = await _resolveDestinationCoords();
    final result = await _placesRepository.searchText(
      query,
      biasLocation: coords,
      maxResultCount: 10,
      // Hard-restrict to a ~80km circle around the trip destination, so
      // searching e.g. in Spain doesn't surface places from Poland.
      restrictLocation: coords != null,
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

  /// Reverse-lookup: given a map tap coordinate, returns the closest place's
  /// Google Place ID if a POI sits within ~25 m of the tap. Used to make taps
  /// on Google POI labels navigate to place details, since
  /// `google_maps_flutter` doesn't expose a dedicated `onPoiClick`.
  ///
  /// `rankPreference: DISTANCE` makes the API return the closest place first;
  /// we then additionally verify with Haversine that the hit really is close
  /// enough (15 m), so empty-area taps don't accidentally navigate to a
  /// faraway place that just happened to be inside the search radius.
  Future<String?> findPlaceIdAtLocation(
    double latitude,
    double longitude,
  ) async {
    final tap = GeoCoordinates(latitude: latitude, longitude: longitude);
    final result = await _placesRepository.searchNearby(
      location: tap,
      radiusMeters: 25,
      maxResultCount: 1,
      rankByDistance: true,
    );
    if (result is! Ok<List<Place>> || result.value.isEmpty) return null;
    final place = result.value.first;
    final loc = place.location;
    if (loc == null) return null;
    final distanceM = haversineKm(tap, loc) * 1000;
    if (distanceM > 15) return null;
    return place.id;
  }

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
      // Over-fetch so we can hide added places and still keep the visible
      // grid populated. The getter trims to 10.
      maxResultCount: 20,
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
