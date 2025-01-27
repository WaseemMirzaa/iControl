import 'package:get/get.dart';
import 'package:app_name/controllers/auth_controller.dart';
import 'package:app_name/controllers/user_controller.dart';
import 'package:app_name/controllers/splash_controller.dart';
import 'package:app_name/service/auth_service.dart';
import 'package:app_name/service/user_service.dart';

class DependencyInjection {
  static void init() {
    // Register services first
    Get.put(AuthService()); // Register AuthService
    Get.put(UserService()); // Register UserService

    // Then register controllers that depend on these services
    Get.put(UserController()); // Register UserController
    Get.put(AuthController()); // Register AuthController
    Get.put(SplashController()); // Register SplashController
  }
}
