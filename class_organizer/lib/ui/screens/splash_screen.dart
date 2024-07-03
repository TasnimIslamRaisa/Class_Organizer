import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:class_organizer/utility/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Home_Screen.dart';
import '../widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _isGlowing = false;
  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    //bool isUserLoggedIn = await AuthController.checkAuthState();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _startGlowAnimation();
    moveToNextScreen();
  }
  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
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
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
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
        ),),
    );
  }
}
