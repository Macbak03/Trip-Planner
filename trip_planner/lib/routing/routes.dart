abstract final class Routes {
  static const auth = '/auth';
  static const home = '/home';
  static const tripDetails = '/trip/:id';

  static String tripDetailsPath(String id) => '/trip/$id';
}
