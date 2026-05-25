import 'package:logging/logging.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/data/services/firestore/trips/firestore_trips_service.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/utils/result.dart';

class TripsRepository {
  TripsRepository({
    required FirestoreTripsService firestoreTripsService,
    required AuthRepository authRepository,
  }) : _service = firestoreTripsService,
       _authRepository = authRepository;

  final FirestoreTripsService _service;
  final AuthRepository _authRepository;
  final _log = Logger('TripsRepository');

  String? get _uid => _authRepository.getUser()?.id;

  Stream<List<Trip>> streamMyTrips() {
    final uid = _uid;
    if (uid == null) return Stream<List<Trip>>.value(const <Trip>[]);
    return _service.streamMyTrips(uid);
  }

  Future<Result<Trip?>> getTrip(String id) async {
    try {
      return Result.ok(await _service.getTrip(id));
    } catch (e) {
      _log.warning('getTrip failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<String>> createTrip({
    required String destination,
    String? destinationPlaceId,
    required double budget,
    String currency = 'PLN',
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final uid = _uid;
    if (uid == null) {
      return Result.error(Exception('Not authenticated'));
    }
    try {
      final trip = Trip(
        id: '',
        ownerId: uid,
        destination: destination,
        destinationPlaceId: destinationPlaceId,
        budget: budget,
        currency: currency,
        startDate: startDate,
        endDate: endDate,
        createdAt: DateTime.now(),
      );
      final id = await _service.createTrip(trip);
      return Result.ok(id);
    } catch (e) {
      _log.warning('createTrip failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void>> updateTrip(Trip trip) async {
    try {
      await _service.updateTrip(trip);
      return Result.ok(null);
    } catch (e) {
      _log.warning('updateTrip failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }

  /// Aggregates `types` over places attached to the user's trips and returns
  /// the top-N most frequent types. The `trips/{id}/places` sub-collection will 
  /// be introduced later, so until then this returns an empty list and the
  /// Home screen falls back to a static popular-countries list.
  Future<List<String>> getUserTopPlaceTypes({int limit = 5}) async {
    return const <String>[];
  }

  Future<Result<void>> deleteTrip(String id) async {
    try {
      await _service.deleteTrip(id);
      return Result.ok(null);
    } catch (e) {
      _log.warning('deleteTrip failed: $e');
      return Result.error(Exception(e.toString()));
    }
  }
}
