import 'package:trip_planner/data/repositories/auth/auth_notifier.dart';
import 'package:trip_planner/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/config/dependencies.dart';
import 'package:trip_planner/utils/google_maps_web_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // Web only: load the Maps JS API (key from .env) before the first map is
  // built. No-op on mobile (native Maps SDKs are configured per platform).
  await loadGoogleMapsJsApi(dotenv.maybeGet('GOOGLE_MAPS_WEB_API_KEY') ?? '');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }
  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: router(authNotifier),
    );
  }
}
