import 'package:class_organizer/splash/splash_screen_v1.dart';
import 'package:class_organizer/ui/screens/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassOrganizerApp extends StatelessWidget {
  const ClassOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ThemeController
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(()=>GetMaterialApp(
      title: 'Class Organizer',
      debugShowCheckedModeBanner:false ,
      theme: themeController.themeData.value, // Observe theme changes
      home: const SplashScreenV1(),

    ),);
  }
}
