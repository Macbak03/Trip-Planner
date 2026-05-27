abstract final class Routes {
  static const auth = '/auth';
  static const home = '/home';
  static const tripDetails = '/trip/:id';
  static const placeDetails = '/trip/:tripId/place/:placeId';

  static String tripDetailsPath(String id) => '/trip/$id';
  static String placeDetailsPath(
    String tripId,
    String placeId, {
    int? dayIndex,
  }) {
    final base = '/trip/$tripId/place/$placeId';
    if (dayIndex == null) return base;
    return '$base?day=$dayIndex';
  }
}
