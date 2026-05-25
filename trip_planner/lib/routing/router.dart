import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/repositories/auth/auth_notifier.dart';
import 'package:trip_planner/routing/routes.dart';
import 'package:trip_planner/ui/auth/view_models/auth_viewmodel.dart';
import 'package:trip_planner/ui/auth/widgets/auth_screen.dart';
import 'package:trip_planner/ui/home/view_models/home_viewmodel.dart';
import 'package:trip_planner/ui/home/widgets/home_screen.dart';
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
    GoRoute(
      path: Routes.auth,
      builder: (context, state) {
        final viewModel = AuthViewModel(authRepository: context.read());
        return AuthScreen(viewModel: viewModel);
      },
    ),
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
        return TripDetailsScreen(tripId: id);
      },
    ),
  ],
);
