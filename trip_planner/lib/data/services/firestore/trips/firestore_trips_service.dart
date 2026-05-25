import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';

class FirestoreTripsService {
  FirestoreTripsService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _trips =>
      _firestore.collection('trips');

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

  Trip _toTrip(String id, Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data);
    map['id'] = id;
    return Trip.fromJson(map);
  }
}
