import 'dart:developer';

import 'package:app_name/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_name/controllers/user_controller.dart';
import 'package:app_name/model/user_model.dart';

import 'package:app_name/service/user_service.dart';
import 'package:app_name/views/core/core/utils/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();
  final UserController _userController = Get.find<UserController>();

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserStatus();
    });
  }

  Future<void> checkUserStatus() async {
    try {
      isLoading.value = true;

      // Check if the user is logged in
      if (!_authService.isLoggedIn()) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      // Fetch the current user from FirebaseAuth
      User? currentUser = _authService.getCurrentUser();

      if (currentUser == null) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      // Fetch user document from Firestore
      UserModel? user = await _userService.getUserById(currentUser.uid);

      if (user == null) {
        // If no user document exists in Firestore, log out and navigate to Login
        await _authService.signOut();
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      // Update the current user in UserController
      _userController.updateUser(user);

      // Check if the user's email is verified
      if (user.isVerified == true) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.verification);
      }
    } catch (e) {
      log('Error checking user status: $e');
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }
}
