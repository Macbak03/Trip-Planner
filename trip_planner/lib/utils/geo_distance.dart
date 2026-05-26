import 'dart:math' as math;

import 'package:trip_planner/domain/models/place/place.dart';

/// Great-circle distance between two points using the Haversine formula.
/// Returns kilometres.
double haversineKm(GeoCoordinates a, GeoCoordinates b) {
  const earthRadiusKm = 6371.0;
  final dLat = _toRad(b.latitude - a.latitude);
  final dLon = _toRad(b.longitude - a.longitude);
  final lat1 = _toRad(a.latitude);
  final lat2 = _toRad(b.latitude);

  final h =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
  final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  return earthRadiusKm * c;
}

double _toRad(double deg) => deg * math.pi / 180.0;
