import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:trip_planner/data/repositories/auth/auth_notifier.dart';
import 'package:trip_planner/data/repositories/auth/auth_repository.dart';
import 'package:trip_planner/data/services/fiebase/auth/firebase_auth_service.dart';

List<SingleChildWidget> get providers => [
  // SERVICES
  Provider<FirebaseAuth>(
    create: (_) => FirebaseAuth.instance,
  ),
  Provider<FirebaseAuthService>(
    create: (context) => FirebaseAuthService(firebaseAuth: context.read<FirebaseAuth>()),
  ),

  // REPOSITORIES
  Provider<AuthRepository>(
    create: (context) => AuthRepository(firebaseAuthService: context.read<FirebaseAuthService>()),
  ),

  ChangeNotifierProvider<AuthNotifier>(
    create: (context) => AuthNotifier(firebaseAuth: context.read<FirebaseAuth>()),
  )
];