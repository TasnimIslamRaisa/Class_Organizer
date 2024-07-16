import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroThree extends StatelessWidget {
  const IntroThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'animation/hello.json',
              height: 300,
              reverse: true,
              repeat: true,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Class Organizer",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Class Organizer description here.....",
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,       
            ),
          ),
        ],
      ),
    ));
  }
}
