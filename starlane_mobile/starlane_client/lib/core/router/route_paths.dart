class RoutePaths {
  // Initial route
  static const String initial = splash;

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // Main app routes
  static const String home = '/home';
  static const String explore = '/explore';
  static const String services = '/services';
  static const String bookings = '/bookings';
  static const String profile = '/profile';

  // Detail routes
  static const String activityDetail = '/activity/:id';
  static const String serviceDetail = '/service/:id';
  static const String booking = '/booking';
  static const String bookingDetail = '/booking/:id';

  // Utility methods
  static String activityDetailPath(String id) => '/activity/$id';
  static String serviceDetailPath(String id) => '/service/$id';
  static String bookingDetailPath(String id) => '/booking/$id';

  // Navigation helper to check if route is in bottom navigation
  static bool isBottomNavRoute(String route) {
    return [home, explore, services, bookings, profile].contains(route);
  }
}