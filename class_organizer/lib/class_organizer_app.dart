import 'package:class_organizer/splash/splash_screen_v1.dart';
import 'package:class_organizer/style/themes/lightTheme.dart';
import 'package:class_organizer/style/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ClassOrganizerApp extends StatelessWidget {
  const ClassOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Organizer',
      debugShowCheckedModeBanner:false ,
      theme:  Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreenV1(),

    );
  }



}
