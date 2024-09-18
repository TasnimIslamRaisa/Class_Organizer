import 'package:class_organizer/splash/splash_screen_v1.dart';
import 'package:class_organizer/ui/screens/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'provider/admin_provider.dart';
import 'provider/school_provider.dart';
import 'provider/u_data_provider.dart';
import 'provider/user_provider.dart';

class ClassOrganizerApp extends StatelessWidget {
  const ClassOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ThemeController
    final ThemeController themeController = Get.put(ThemeController());
    // provider added by farhad foysal
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UDataProvider()),
        ChangeNotifierProvider(create: (_) => SchoolProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Obx(
            () => GetMaterialApp(
              title: 'Class Organizer',
              debugShowCheckedModeBanner: false,
              theme: themeController.themeData.value, // Observe theme changes
              home: const SplashScreenV1(),
            ),
      ),
    );
  }
}
