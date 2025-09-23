import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Route paths
import 'route_paths.dart';

// Shared screens
import '../../shared/screens/splash_screen.dart';

// Auth screens
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';

// Navigation
import '../navigation/main_navigation.dart';

// Screen placeholders (will be replaced with real screens)
import '../../shared/screens/placeholder_screens.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.initial,
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
      
      // Main Navigation Shell
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.explore,
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: RoutePaths.bookings,
            builder: (context, state) => const BookingsScreen(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}