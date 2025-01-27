// lib/core/routes/app_routes.dart
abstract class AppRoutes {
  // Root route
  static const String initial = '/';

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verification = '/auth/verification';

  // Main app routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
