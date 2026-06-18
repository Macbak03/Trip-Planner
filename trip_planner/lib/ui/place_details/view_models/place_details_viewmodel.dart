import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/places/places_repository.dart';
import 'package:trip_planner/data/repositories/trips/trips_repository.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/place/place_review.dart';
import 'package:trip_planner/domain/models/trip/trip_place.dart';
import 'package:trip_planner/utils/command.dart';
import 'package:trip_planner/utils/geo_distance.dart';
import 'package:trip_planner/utils/result.dart';

class PlaceDetailsViewModel extends ChangeNotifier {
  PlaceDetailsViewModel({
    required this.placeId,
    required PlacesRepository placesRepository,
    this.tripId,
    this.dayIndex,
    TripsRepository? tripsRepository,
  }) : _placesRepository = placesRepository,
       _tripsRepository = tripsRepository {
    load = Command0(_load);
    addToTrip = Command0(_addToTrip);
    removeFromTrip = Command0(_removeFromTrip);
    load.execute();
    // When opened from a trip, watch its places so the action button can flip
    // between "Add" and "Remove" as this place is added to / removed from the
    // currently-selected day.
    if (canAddToTrip) {
      _tripPlacesSub = _tripsRepository!.streamTripPlaces(tripId!).listen((
        places,
      ) {
        _tripPlaces = places;
        notifyListeners();
      });
    }
  }

  final String placeId;
  final String? tripId;
  final int? dayIndex;
  final PlacesRepository _placesRepository;
  final TripsRepository? _tripsRepository;
  final _log = Logger('PlaceDetailsViewModel');

  late final Command0<Place> load;
  late final Command0<String> addToTrip;
  late final Command0<void> removeFromTrip;

  Place? _place;
  int _currentReviewIndex = 0;
  List<TripPlace> _tripPlaces = const <TripPlace>[];
  StreamSubscription<List<TripPlace>>? _tripPlacesSub;

  Place? get place => _place;
  List<PlaceReview> get reviews => _place?.reviews ?? const <PlaceReview>[];
  int get currentReviewIndex => _currentReviewIndex;

  /// True only when the screen was opened from a trip context, so the
  /// Add/Remove action button should be visible.
  bool get canAddToTrip => tripId != null && _tripsRepository != null;

  /// The day this place would be added to / removed from. Mirrors the default
  /// used by [_addToTrip].
  int get _effectiveDay => dayIndex ?? 1;

  /// True when this place is already in the trip's currently-selected day, so
  /// the action button should show "Remove" instead of "Add".
  bool get isInCurrentDay => _tripPlaces.any(
    (tp) => tp.placeId == placeId && tp.dayIndex == _effectiveDay,
  );

  void setCurrentReviewIndex(int index) {
    if (index == _currentReviewIndex) return;
    _currentReviewIndex = index;
    notifyListeners();
  }

  String photoUrl(String photoRef, {int maxWidthPx = 1200}) =>
      _placesRepository.photoUrl(photoRef, maxWidthPx: maxWidthPx);

  Future<Result<Place>> _load() async {
    final result = await _placesRepository.getDetails(placeId);
    switch (result) {
      case Ok<Place>():
        _place = result.value;
        _currentReviewIndex = 0;
        notifyListeners();
        return result;
      case Error<Place>():
        _log.warning('load place failed: ${result.error}');
        return result;
    }
  }

  Future<Result<String>> _addToTrip() async {
    final tId = tripId;
    final repo = _tripsRepository;
    final p = _place;
    if (tId == null || repo == null) {
      return Result.error(Exception('No trip context'));
    }
    if (p == null) {
      return Result.error(Exception('Place not loaded'));
    }
    final day = dayIndex ?? 1;
    // Read the current list once so we can compute the next order in the day
    // and distance from the previously-added place.
    final existing = await repo.streamTripPlaces(tId).first;
    final dayPlaces =
        existing.where((tp) => tp.dayIndex == day).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    double? distance;
    if (dayPlaces.isNotEmpty &&
        dayPlaces.last.location != null &&
        p.location != null) {
      distance = haversineKm(dayPlaces.last.location!, p.location!);
    }
    final result = await repo.addTripPlace(
      tId,
      placeId: p.id,
      dayIndex: day,
      order: dayPlaces.length,
      displayName: p.displayName,
      location: p.location,
      distanceFromPrevKm: distance,
    );
    if (result is Error<String>) {
      _log.warning('addToTrip failed: ${result.error}');
    }
    return result;
  }

  /// Removes this place from the currently-selected day. If it was somehow added
  /// more than once to that day, all matching entries are removed.
  Future<Result<void>> _removeFromTrip() async {
    final tId = tripId;
    final repo = _tripsRepository;
    if (tId == null || repo == null) {
      return Result.error(Exception('No trip context'));
    }
    final day = _effectiveDay;
    final matches = _tripPlaces
        .where((tp) => tp.placeId == placeId && tp.dayIndex == day)
        .toList();
    for (final tp in matches) {
      final result = await repo.removeTripPlace(tId, tp.id);
      if (result is Error<void>) {
        _log.warning('removeFromTrip failed: ${result.error}');
        return result;
      }
    }
    return Result.ok(null);
  }

  /// Returns true if the place is already added to the trip context (any day).
  /// Used by the UI to flip the FAB to a disabled "Added" state.
  Future<bool> isAlreadyInTrip() async {
    final tId = tripId;
    final repo = _tripsRepository;
    if (tId == null || repo == null) return false;
    final existing = await repo.streamTripPlaces(tId).first;
    return existing.any((TripPlace tp) => tp.placeId == placeId);
  }

  @override
  void dispose() {
    _tripPlacesSub?.cancel();
    super.dispose();
  }
}
