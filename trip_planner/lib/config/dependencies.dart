import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:trip_planner/data/repositories/auth/auth_notifier.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/data/repositories/trips/trips_repository.dart';
import 'package:trip_planner/data/services/firebase/auth/firebase_auth_service.dart';
import 'package:trip_planner/data/services/firestore/trips/firestore_trips_service.dart';

List<SingleChildWidget> get providers => [
  // SERVICES
  Provider<FirebaseAuth>(
    create: (_) => FirebaseAuth.instance,
  ),
  Provider<FirebaseFirestore>(
    create: (_) => FirebaseFirestore.instance,
  ),
  Provider<FirebaseAuthService>(
    create: (context) =>
        FirebaseAuthService(firebaseAuth: context.read<FirebaseAuth>()),
  ),
  Provider<FirestoreTripsService>(
    create: (context) =>
        FirestoreTripsService(firestore: context.read<FirebaseFirestore>()),
  ),

  // REPOSITORIES
  Provider<AuthRepository>(
    create: (context) =>
        AuthRepository(firebaseAuthService: context.read<FirebaseAuthService>()),
  ),
  Provider<TripsRepository>(
    create: (context) => TripsRepository(
      firestoreTripsService: context.read<FirestoreTripsService>(),
      authRepository: context.read<AuthRepository>(),
    ),
  ),

  ChangeNotifierProvider<AuthNotifier>(
    create: (context) => AuthNotifier(firebaseAuth: context.read<FirebaseAuth>()),
  ),
];
