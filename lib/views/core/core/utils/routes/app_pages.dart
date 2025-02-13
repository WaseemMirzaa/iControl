// lib/core/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:app_name/views/core/core/utils/routes/app_routes.dart';
import 'package:app_name/views/splash_view.dart';
import 'package:app_name/views/login_view.dart';
import 'package:app_name/views/signup_view.dart';
import 'package:app_name/views/forget_view.dart';
import 'package:app_name/views/home_view.dart';
import 'package:app_name/views/verification_view.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.signup, page: () => const SignupView()),
    GetPage(
        name: AppRoutes.forgotPassword, page: () => const ForgotPasswordView()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(
        name: AppRoutes.verification, page: () => const VerificationScreen()),
  ];
}
