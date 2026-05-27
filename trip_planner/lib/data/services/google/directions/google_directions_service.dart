import 'dart:convert';
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
  /// the decoded overview polyline. Returns an empty list when the API is not
  /// enabled / rejects the request — the caller should treat that as "no route
  /// available" rather than an error.
  Future<List<GeoCoordinates>> getRouteWalking(
    List<GeoCoordinates> waypoints,
  ) async {
    if (waypoints.length < 2) return const <GeoCoordinates>[];
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
