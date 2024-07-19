import 'dart:async';


import 'package:avatar_glow/avatar_glow.dart';
import 'package:class_organizer/pages/login/admin_login.dart';
import 'package:class_organizer/ui/screens/controller/app_controller.dart';
import 'package:class_organizer/utility/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/on_screen.dart';
import '../pages/login/login_page.dart';

class SplashScreenV1 extends StatefulWidget {
  const SplashScreenV1({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    return SplashScreenV1State();
  }
}

class SplashScreenV1State extends State<SplashScreenV1> {
  late Timer _timer;
  bool _isGlowing = false;


  @override
  void initState() {
    super.initState();
    _startGlowAnimation();
    goToScreen();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  void _startGlowAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _isGlowing = !_isGlowing; // Toggle the glow state
      });
    });
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
          child: AvatarGlow(
            animate: _isGlowing,
            duration: const Duration(seconds: 2),
            glowColor: Colors.blue,
            //endRadius: 140.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.none,
                ),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 80.0,
                child: ClipOval(
                    child: SvgPicture.asset(
                      AssetsPath.logoSvgPath,
                      width: 250,
                    ),
                  ),

              ),
            ),
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
    final userType = prefs.getString("user_type")??"user";
    Timer(
        const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => onboarding ? (userType=="user"? const LoginPage() : const AdminLogin()) : OnScreen())));
  }
}
