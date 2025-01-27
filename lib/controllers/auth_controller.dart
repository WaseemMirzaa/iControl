import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_name/controllers/user_controller.dart';
import 'package:app_name/model/user_model.dart';
import 'package:app_name/service/auth_service.dart';
import 'package:app_name/service/user_service.dart';
import 'package:app_name/utils/app_utils.dart';
import 'package:app_name/views/core/core/utils/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final _userController = Get.find<UserController>();

  final RxBool confirm = false.obs;
  final RxBool isLoading = false.obs;

  // Login Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // SignUp Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailControllerSignUp = TextEditingController();
  final TextEditingController passwordControllerSignUp =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNodeSignUp = FocusNode();
  FocusNode passwordFocusNodeSignUp = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  final TextEditingController resetEmailController = TextEditingController();

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        WidgetUtils.showError('Input Error', 'All fields are required');
        return;
      }

      if (!_isValidEmail(email)) {
        WidgetUtils.showError('Invalid Email', 'Enter a valid email address');
        return;
      }

      if (password.length < 6) {
        WidgetUtils.showError(
            'Weak Password', 'Password must be 6+ characters');
        return;
      }

      if (!confirm.value) {
        WidgetUtils.showError(
            'Terms & Conditions', 'Please accept terms and conditions');
        return;
      }

      if (await _userService.isEmailExists(email)) {
        WidgetUtils.showError('Email Taken', 'Try a different email or login');
        return;
      }

      final UserCredential result =
          await _authService.signUpWithEmailAndPassword(email, password);

      if (result.user != null) {
        final UserModel newUser = UserModel(
          email: email.trim(),
          displayName: name,
          isVerified: false,
          uid: result.user!.uid,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _userService.createUser(result.user!.uid, newUser);

        // final Map<String, dynamic> permissions = {
        //   "directory": true,
        //   "page": true,
        // };
        // await _userService.addPermissions(email.trim(), permissions);


        _userController.updateUser(newUser);
        Get.offAllNamed(AppRoutes.verification);
      }
    } catch (e) {
      WidgetUtils.showError('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      if (email.isEmpty || password.isEmpty || !_isValidEmail(email)) {
        WidgetUtils.showError('Invalid Input', 'Provide valid credentials');
        return;
      }

      final UserCredential result =
          await _authService.signInWithEmailAndPassword(email, password);

      if (result.user != null) {
        await _userService.updateUserLoginTime(result.user!.uid);
        final userModel = await _userService.getUserById(result.user!.uid);
        if (userModel != null) {
          _userController.updateUser(userModel);
          emailController.clear();
          passwordController.clear();
          Get.offAllNamed(AppRoutes.home);
        }
      }
    } catch (e) {
      log('Error: $e');
      WidgetUtils.showError('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkEmailVerificationStatus() async {
    try {
      isLoading.value = true;

      final user = _authService.getCurrentUser();
      if (user == null) {
        WidgetUtils.showError('Auth Error', 'No authenticated user found');
        return;
      }

      // Fetch user data from the database to check 'isVerified' field
      final userModel = await _userService.getUserById(user.uid);
      if (userModel == null) {
        WidgetUtils.showError('User Error', 'No user data found');
        return;
      }

      // Check if the 'isVerified' field in the database is true
      if (userModel.isVerified != null && userModel.isVerified!) {
        // Proceed with updating the verification status and navigating
        await _userService.updateUserVerificationStatus(user.uid, true);

        // Update user data in the controller
        _userController.updateUser(userModel);
        WidgetUtils.showSuccess('Verified', 'Your email is verified.');
        Get.offAllNamed(AppRoutes.home);
      } else {
        WidgetUtils.showError(
            'Verification Pending', 'Please verify your email.');
      }
    } catch (e) {
      WidgetUtils.showError('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _userController.clearUser();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      WidgetUtils.showError('Logout Error', e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;

      if (email.isEmpty || !_isValidEmail(email)) {
        WidgetUtils.showError(
            'Invalid Email', 'Please enter a valid email address');
        return;
      }

      if (!await _userService.isEmailExists(email)) {
        WidgetUtils.showError('Not Found', 'No account with this email');
        return;
      }

      await _authService.sendPasswordResetEmail(email);
      resetEmailController.clear();
      WidgetUtils.showSuccess(
          'Reset Email Sent', 'Password reset email sent to $email');
    } catch (e) {
      WidgetUtils.showError('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
