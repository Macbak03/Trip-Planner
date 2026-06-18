import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:trip_planner/domain/models/place/place.dart';

/// REST client for the legacy Google Directions API. Reuses the same API key
/// as Maps/Places. The Directions API must be enabled in the GCP project for
/// requests to succeed; otherwise the service returns an empty polyline and
/// the caller falls back to no route.
class GoogleDirectionsService {
  GoogleDirectionsService({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final http.Client _http;
  final _log = Logger('GoogleDirectionsService');

  static const _base = 'https://maps.googleapis.com/maps/api/directions/json';

  String get _apiKey {
    return dotenv.maybeGet('GOOGLE_PLACES_API_KEY') ?? '';
  }

  /// Fetches a walking-mode route through [waypoints] (in order) and returns
  /// the decoded overview polyline. Returns an empty list when no provider can
  /// supply a route — the caller treats that as "no route available" rather
  /// than an error.
  ///
  /// Prefers the modern Routes API on every platform: the legacy Directions
  /// web-service is blocked by CORS in the browser and is often unavailable on
  /// newer GCP projects (which only ship the Routes API). On mobile, if the
  /// Routes API returns nothing, falls back to the legacy Directions API.
  Future<List<GeoCoordinates>> getRouteWalking(
    List<GeoCoordinates> waypoints,
  ) async {
    if (waypoints.length < 2) {
      _log.fine('getRouteWalking: fewer than 2 waypoints, no route to draw');
      return const <GeoCoordinates>[];
    }
    final viaRoutes = await _getRouteWalkingViaRoutesApi(waypoints);
    if (viaRoutes.isNotEmpty) return viaRoutes;
    if (!kIsWeb) {
      final viaLegacy = await _getRouteWalkingViaLegacyDirections(waypoints);
      if (viaLegacy.isNotEmpty) return viaLegacy;
    }
    _log.warning(
      'getRouteWalking: no route returned for ${waypoints.length} waypoints. '
      'Check that the Routes API (web key GOOGLE_ROUTES_WEB_API_KEY / mobile '
      'key GOOGLE_PLACES_API_KEY) and/or the legacy Directions API are enabled '
      'for the configured key and allow this app/referrer.',
    );
    return const <GeoCoordinates>[];
  }

  /// Legacy Directions web-service path (mobile only — blocked by CORS on web).
  Future<List<GeoCoordinates>> _getRouteWalkingViaLegacyDirections(
    List<GeoCoordinates> waypoints,
  ) async {
    final origin = waypoints.first;
    final destination = waypoints.last;
    final middle = waypoints.sublist(1, waypoints.length - 1);
    final uri = Uri.parse(_base).replace(queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      if (middle.isNotEmpty)
        'waypoints': middle
            .map((p) => '${p.latitude},${p.longitude}')
            .join('|'),
      'mode': 'walking',
      'key': _apiKey,
    });
    try {
      final res = await _http.get(uri);
      if (res.statusCode != 200) {
        _log.warning('directions failed ${res.statusCode}: ${res.body}');
        return const <GeoCoordinates>[];
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final status = data['status'] as String?;
      if (status != 'OK') {
        _log.warning('directions non-OK status: $status (${data['error_message']})');
        return const <GeoCoordinates>[];
      }
      final routes = data['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty) return const <GeoCoordinates>[];
      final overview =
          (routes.first as Map<String, dynamic>)['overview_polyline']
              as Map<String, dynamic>?;
      final encoded = overview?['points'] as String?;
      if (encoded == null || encoded.isEmpty) return const <GeoCoordinates>[];
      return _decodePolyline(encoded);
    } catch (e) {
      _log.warning('directions threw: $e');
      return const <GeoCoordinates>[];
    }
  }

  /// Web path: the modern Routes API (`routes.googleapis.com`) which, unlike the
  /// legacy Directions web-service, returns CORS headers so it can be called
  /// directly from the browser. Uses the dedicated web Routes key. Returns an
  /// empty list on any failure (caller treats it as "no route").
  Future<List<GeoCoordinates>> _getRouteWalkingViaRoutesApi(
    List<GeoCoordinates> waypoints,
  ) async {
    // Web uses the referrer-restricted web Routes key; mobile reuses the Places
    // key (used for the other REST calls) and falls back to the web key.
    final key = kIsWeb
        ? (dotenv.maybeGet('GOOGLE_ROUTES_WEB_API_KEY') ?? '')
        : (dotenv.maybeGet('GOOGLE_PLACES_API_KEY') ??
              dotenv.maybeGet('GOOGLE_ROUTES_WEB_API_KEY') ??
              '');
    if (key.isEmpty) return const <GeoCoordinates>[];
    final middle = waypoints.sublist(1, waypoints.length - 1);
    final body = <String, dynamic>{
      'origin': _routesWaypoint(waypoints.first),
      'destination': _routesWaypoint(waypoints.last),
      if (middle.isNotEmpty) 'intermediates': middle.map(_routesWaypoint).toList(),
      'travelMode': 'WALK',
      'polylineEncoding': 'ENCODED_POLYLINE',
    };
    try {
      final res = await _http.post(
        Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': key,
          'X-Goog-FieldMask': 'routes.polyline.encodedPolyline',
        },
        body: jsonEncode(body),
      );
      if (res.statusCode != 200) {
        _log.warning('routes failed ${res.statusCode}: ${res.body}');
        return const <GeoCoordinates>[];
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty) return const <GeoCoordinates>[];
      final polyline = (routes.first as Map<String, dynamic>)['polyline']
          as Map<String, dynamic>?;
      final encoded = polyline?['encodedPolyline'] as String?;
      if (encoded == null || encoded.isEmpty) return const <GeoCoordinates>[];
      return _decodePolyline(encoded);
    } catch (e) {
      _log.warning('routes threw: $e');
      return const <GeoCoordinates>[];
    }
  }

  Map<String, dynamic> _routesWaypoint(GeoCoordinates p) => {
    'location': {
      'latLng': {'latitude': p.latitude, 'longitude': p.longitude},
    },
  };

  /// Standard Google encoded-polyline decoder.
  /// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  List<GeoCoordinates> _decodePolyline(String encoded) {
    final result = <GeoCoordinates>[];
    var index = 0;
    var lat = 0;
    var lng = 0;
    while (index < encoded.length) {
      var shift = 0;
      var dLat = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        dLat |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (dLat & 1) != 0 ? ~(dLat >> 1) : (dLat >> 1);
      shift = 0;
      var dLng = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        dLng |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (dLng & 1) != 0 ? ~(dLng >> 1) : (dLng >> 1);
      result.add(GeoCoordinates(latitude: lat / 1e5, longitude: lng / 1e5));
    }
    return result;
  }

  void dispose() {
    _http.close();
  }
}
