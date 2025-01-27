import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetUtils {
  static void showError(String title, String message, {int duration = 3}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  static void showSuccess(String title, String message, {int duration = 3}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  static void showInfo(String title, String message, {int duration = 3}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[900],
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  static void showWarning(String title, String message, {int duration = 3}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  static void showLoading({String message = 'Loading...'}) {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}