import 'package:class_organizer/splash/splash_screen_v1.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
class ClassOrganizerApp extends StatelessWidget {
  const ClassOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Class Organizer',
      debugShowCheckedModeBanner:false ,
      theme: Provider.of(context).ThemeData,
      home: const SplashScreenV1(),

    );
  }
}
