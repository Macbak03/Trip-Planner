import 'package:logging/logging.dart';
import 'package:trip_planner/data/services/google/places/google_places_service.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/place/place_suggestion.dart';
import 'package:trip_planner/utils/result.dart';

/// Facade over [GooglePlacesService]. Wraps responses in [Result] and keeps
/// a short-lived in-memory cache of autocomplete results per query so that
/// re-typing the same prefix doesn't re-bill the user.
class PlacesRepository {
  PlacesRepository({required GooglePlacesService googlePlacesService})
    : _service = googlePlacesService;

  final GooglePlacesService _service;
  final _log = Logger('PlacesRepository');

  final Map<String, List<PlaceSuggestion>> _autocompleteCache = {};
  final Map<String, Place> _detailsCache = {};
  List<Place>? _suggestedCountriesCache;

  Future<Result<List<PlaceSuggestion>>> autocomplete(
    String query, {
    required String sessionToken,
    GeoCoordinates? biasLocation,
    List<String> includedPrimaryTypes = const <String>[],
  }) async {
    final key = _autocompleteKey(query, biasLocation, includedPrimaryTypes);
    final cached = _autocompleteCache[key];
    if (cached != null) return Result.ok(cached);
    try {
      final suggestions = await _service.autocomplete(
        query,
        sessionToken: sessionToken,
        biasLocation: biasLocation,
        includedPrimaryTypes: includedPrimaryTypes,
      );
      _autocompleteCache[key] = suggestions;
      return Result.ok(suggestions);
    } catch (e) {
      _log.warning('autocomplete failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<Place>> getDetails(
    String placeId, {
    String? sessionToken,
  }) async {
    final cached = _detailsCache[placeId];
    if (cached != null) return Result.ok(cached);
    try {
      final place = await _service.getDetails(
        placeId,
        sessionToken: sessionToken,
      );
      _detailsCache[placeId] = place;
      return Result.ok(place);
    } catch (e) {
      _log.warning('getDetails failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<List<Place>>> searchNearby({
    required GeoCoordinates location,
    required double radiusMeters,
    List<String> includedTypes = const <String>[],
    int maxResultCount = 10,
  }) async {
    try {
      final places = await _service.searchNearby(
        location: location,
        radiusMeters: radiusMeters,
        includedTypes: includedTypes,
        maxResultCount: maxResultCount,
      );
      return Result.ok(places);
    } catch (e) {
      _log.warning('searchNearby failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<List<Place>>> searchText(
    String query, {
    List<String> includedTypes = const <String>[],
    GeoCoordinates? biasLocation,
    int maxResultCount = 10,
  }) async {
    try {
      final places = await _service.searchText(
        query,
        includedTypes: includedTypes,
        biasLocation: biasLocation,
        maxResultCount: maxResultCount,
      );
      return Result.ok(places);
    } catch (e) {
      _log.warning('searchText failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  /// Resolves [countryNames] to [Place] entries via `searchText`, returning the
  /// first result per name. Result is cached for the lifetime of the repo so
  /// re-entering the Home screen does not re-bill the user.
  Future<Result<List<Place>>> getSuggestedCountries(
    List<String> countryNames,
  ) async {
    final cached = _suggestedCountriesCache;
    if (cached != null) return Result.ok(cached);
    final places = <Place>[];
    for (final name in countryNames) {
      try {
        final results = await _service.searchText(name, maxResultCount: 1);
        if (results.isNotEmpty) places.add(results.first);
      } catch (e) {
        _log.warning('getSuggestedCountries failed for $name: $e');
      }
    }
    _suggestedCountriesCache = places;
    return Result.ok(places);
  }

  String photoUrl(String photoRef, {int maxWidthPx = 800}) =>
      _service.photoUrl(photoRef, maxWidthPx: maxWidthPx);

  void clearCache() {
    _autocompleteCache.clear();
    _detailsCache.clear();
    _suggestedCountriesCache = null;
  }

  String _autocompleteKey(
    String query,
    GeoCoordinates? bias,
    List<String> types,
  ) {
    final biasKey = bias == null
        ? ''
        : '${bias.latitude.toStringAsFixed(2)},${bias.longitude.toStringAsFixed(2)}';
    return '${query.trim().toLowerCase()}|$biasKey|${types.join(",")}';
  }
}
