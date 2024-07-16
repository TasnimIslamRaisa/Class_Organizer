import 'dart:async';


import 'package:class_organizer/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/on_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    goToScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   title: const Text("Welcome to Class Organizer"),
      //   centerTitle: true,
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/edu.jpg",
            fit: BoxFit.cover,
          ),
          Center(
            child: Lottie.asset(
              'animation/hello1.json',
              reverse: true,
              repeat: true,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Lottie.asset(
              'animation/9.json',
              width: MediaQuery.sizeOf(context).height,
              height: MediaQuery.sizeOf(context).width,
              reverse: true,
              repeat: true,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ));
  }
  
  void goToScreen() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final onboarding = prefs.getBool("onboarding")??false; 
    Timer(
        const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => onboarding ? LoginPage() : OnScreen())));
  }
}
