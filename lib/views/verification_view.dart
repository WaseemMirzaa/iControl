import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_name/views/widgets/widgets/reuse_button.dart';
import '../controllers/auth_controller.dart'; // Adjust import path as needed

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final AuthController authController = Get.find<AuthController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading/Pending animation
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orangeAccent),
                        ),
                      ),
                      Icon(
                        Icons.mark_email_unread_rounded,
                        size: 40,
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Verification Pending',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Your verification is in progress.\nPlease wait while we verify your email address.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Button
                CustomButton(
                  text: 'CHECK VERIFICATION STATUS',
                  onPressed: () async {
                    // Call the controller method to check the verification status
                    await authController.checkEmailVerificationStatus();
                  },
                  isLoading: authController.isLoading,
                  gradientColors: const [Colors.orange, Colors.red],
                  height: 60.0,
                  borderRadius: 12.0,
                  fontSize: 18.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
