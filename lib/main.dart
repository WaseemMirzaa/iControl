// lib/main.dart
import 'package:app_name/controllers/home_controller.dart';
import 'package:app_name/controllers/user_controller.dart';
import 'package:app_name/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_name/views/core/core/utils/di/dependency_injection.dart';
import 'package:app_name/views/core/core/utils/routes/app_pages.dart';
import 'package:app_name/views/core/core/utils/routes/app_routes.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  DependencyInjection.init();
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App Name',
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
