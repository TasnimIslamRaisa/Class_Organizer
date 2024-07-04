import 'package:class_organizer/style/app_color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello!"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Container(
          child:  const Text("Your App Starts Here",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
      ),
    );
  }
}
