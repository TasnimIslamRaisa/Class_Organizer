import 'package:class_organizer/ui/screens/splash_screen.dart';
import 'package:class_organizer/ui/widgets/lightTheme.dart';
import 'package:flutter/material.dart';

class ClassOrganizerApp extends StatelessWidget {
  const ClassOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Organizer',
      debugShowCheckedModeBanner:true ,
      theme: lightTheme(),         //To Do : here method should be replace in other file
      home: const SplashScreen(),
    );
  }



}
