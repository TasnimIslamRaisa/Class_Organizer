import 'package:class_organizer/style/themes/lightTheme.dart';
import 'package:class_organizer/ui/Home_Screen.dart';
import 'package:class_organizer/ui/screens/on_loading_screens/first_loading_screen.dart';
import 'package:class_organizer/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class ClassOrganizerApp extends StatelessWidget {
  const ClassOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Organizer',
      debugShowCheckedModeBanner:true ,
      theme: lightTheme(),
      home: const SplashScreen(),
      routes: {
        '/home':(context)=>const HomeScreen(),
        '/firstLoadingScreen' :(context) =>const FirstLoadingScreen(),
      },
    );
  }



}
