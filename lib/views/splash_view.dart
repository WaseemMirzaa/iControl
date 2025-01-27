import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_name/views/core/core/utils/constants/temp_language.dart';

import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return const Scaffold(
          body: Center(
            child: Text(
              TempLanguage.lblSwipe,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
