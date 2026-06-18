import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/repositories/auth/auth_notifier.dart';
import 'package:trip_planner/routing/routes.dart';
import 'package:trip_planner/ui/auth/view_models/auth_viewmodel.dart';
import 'package:trip_planner/ui/auth/widgets/auth_screen.dart';
import 'package:trip_planner/ui/home/view_models/home_viewmodel.dart';
import 'package:trip_planner/ui/home/widgets/home_screen.dart';
import 'package:trip_planner/ui/core/widgets/app_top_bar.dart';
import 'package:trip_planner/ui/place_details/view_models/place_details_viewmodel.dart';
import 'package:trip_planner/ui/place_details/widgets/place_details_screen.dart';
import 'package:trip_planner/ui/settings/view_models/settings_viewmodel.dart';
import 'package:trip_planner/ui/settings/widgets/settings_screen.dart';
import 'package:trip_planner/ui/trip_details/view_models/trip_details_viewmodel.dart';
import 'package:trip_planner/ui/trip_details/widgets/trip_details_screen.dart';

GoRouter router(AuthNotifier authNotifier) => GoRouter(
  initialLocation: Routes.auth,
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final isAuthenticated = authNotifier.isAuthenticated;
    final isLoginRoute = state.matchedLocation == Routes.auth;

    // If not authenticated and not on login page, redirect to login
    if (!isAuthenticated && !isLoginRoute) {
      return Routes.auth;
    }

    // If authenticated and on login page, redirect to home
    if (isAuthenticated && isLoginRoute) {
      return Routes.home;
    }

    // No redirect needed
    return null;
  },

  routes: [
    // Routes without the universal top bar (auth + settings).
    GoRoute(
      path: Routes.auth,
      builder: (context, state) {
        final viewModel = AuthViewModel(authRepository: context.read());
        return AuthScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) {
        final viewModel = SettingsViewModel(authRepository: context.read());
        return SettingsScreen(viewModel: viewModel);
      },
    ),

    // Authenticated content routes wrapped with the universal [AppTopBar].
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            final viewModel = HomeViewModel(
              authRepository: context.read(),
              tripsRepository: context.read(),
              placesRepository: context.read(),
            );
            return HomeScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.tripDetails,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final viewModel = TripDetailsViewModel(
              tripId: id,
              tripsRepository: context.read(),
              placesRepository: context.read(),
              directionsService: context.read(),
            );
            return TripDetailsScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.placeDetails,
          builder: (context, state) {
            final tripId = state.pathParameters['tripId']!;
            final placeId = state.pathParameters['placeId']!;
            final dayStr = state.uri.queryParameters['day'];
            final day = dayStr == null ? null : int.tryParse(dayStr);
            final viewModel = PlaceDetailsViewModel(
              placeId: placeId,
              tripId: tripId,
              dayIndex: day,
              placesRepository: context.read(),
              tripsRepository: context.read(),
            );
            return PlaceDetailsScreen(viewModel: viewModel);
          },
        ),
      ],
    ),
  ],
);
