import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/domain/models/trip/trip_place.dart';

class FirestoreTripsService {
  FirestoreTripsService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _trips =>
      _firestore.collection('trips');

  CollectionReference<Map<String, dynamic>> _places(String tripId) =>
      _trips.doc(tripId).collection('places');

  Stream<List<Trip>> streamMyTrips(String uid) {
    return _trips
        .where('ownerId', isEqualTo: uid)
        .orderBy('startDate')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => _toTrip(d.id, d.data())).toList(),
        );
  }

  Future<Trip?> getTrip(String id) async {
    final doc = await _trips.doc(id).get();
    if (!doc.exists) return null;
    return _toTrip(doc.id, doc.data()!);
  }

  Future<String> createTrip(Trip trip) async {
    final ref = trip.id.isEmpty ? _trips.doc() : _trips.doc(trip.id);
    final data = trip.toJson()..remove('id');
    await ref.set(data);
    return ref.id;
  }

  Future<void> updateTrip(Trip trip) async {
    final data = trip.toJson()..remove('id');
    await _trips.doc(trip.id).set(data, SetOptions(merge: true));
  }

  Future<void> deleteTrip(String id) async {
    await _trips.doc(id).delete();
  }

  Stream<List<TripPlace>> streamTripPlaces(String tripId) {
    return _places(tripId).snapshots().map((snap) {
      final places =
          snap.docs.map((d) => _toTripPlace(d.id, d.data())).toList();
      places.sort((a, b) {
        final dayCmp = a.dayIndex.compareTo(b.dayIndex);
        if (dayCmp != 0) return dayCmp;
        return a.order.compareTo(b.order);
      });
      return places;
    });
  }

  Future<String> addTripPlace(String tripId, TripPlace tripPlace) async {
    final ref = tripPlace.id.isEmpty
        ? _places(tripId).doc()
        : _places(tripId).doc(tripPlace.id);
    final data = tripPlace.toJson()..remove('id');
    await ref.set(data);
    await _trips.doc(tripId).set(<String, dynamic>{
      'placeIds': FieldValue.arrayUnion(<String>[tripPlace.placeId]),
    }, SetOptions(merge: true));
    return ref.id;
  }

  Future<void> removeTripPlace(String tripId, String tripPlaceId) async {
    final doc = await _places(tripId).doc(tripPlaceId).get();
    final placeId = doc.data()?['placeId'] as String?;
    await _places(tripId).doc(tripPlaceId).delete();
    if (placeId != null) {
      await _trips.doc(tripId).set(<String, dynamic>{
        'placeIds': FieldValue.arrayRemove(<String>[placeId]),
      }, SetOptions(merge: true));
    }
  }

  Future<void> reorderDayPlaces(
    String tripId,
    int dayIndex,
    List<String> orderedIds,
  ) async {
    final batch = _firestore.batch();
    for (var i = 0; i < orderedIds.length; i++) {
      batch.set(
        _places(tripId).doc(orderedIds[i]),
        <String, dynamic>{'dayIndex': dayIndex, 'order': i},
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  Trip _toTrip(String id, Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data);
    map['id'] = id;
    return Trip.fromJson(map);
  }

  TripPlace _toTripPlace(String id, Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data);
    map['id'] = id;
    return TripPlace.fromJson(map);
  }
}
