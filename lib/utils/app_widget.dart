import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class AppWidgets {
  static Widget customButton({
    required String text,
    required VoidCallback onPressed,
    Gradient? gradient,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient ??
              const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null) Icon(icon, color: Colors.white),
              if (icon != null)
                const SizedBox(width: 8), // Space between icon and text
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
