import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Route paths
import 'route_paths.dart';

// Shared screens
import '../../shared/screens/splash_screen.dart';

// Auth screens
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';

// Client screens
import '../../features/client/screens/home_screen.dart';
import '../../features/client/screens/explore_screen.dart';
import '../../features/client/screens/services_screen.dart';
import '../../features/client/screens/bookings_screen.dart';
import '../../features/client/screens/profile_screen.dart';
import '../../features/client/screens/service_details_screen.dart';

// Navigation
import '../navigation/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.initial,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: RoutePaths.serviceDetail,
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          return ServiceDetailsScreen(serviceId: serviceId);
        },
      ),
      
      // Main Navigation Shell
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          // Home
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const ClientHomeScreen(),
            ),
          ),
          
          // Explorer
          GoRoute(
            path: RoutePaths.explore,
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const ExploreScreen(),
            ),
          ),
          
          // Services - NOUVEAU
          GoRoute(
            path: RoutePaths.services,
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const ServicesScreen(),
            ),
          ),
          
          // Bookings
          GoRoute(
            path: RoutePaths.bookings,
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const BookingsScreen(),
            ),
          ),
          
          // Profile
          GoRoute(
            path: RoutePaths.profile,
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La page "${state.matchedLocation}" n\'existe pas.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
}