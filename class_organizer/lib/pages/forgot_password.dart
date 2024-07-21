import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordState();
  }
  
}

class ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Text("Forgot Password!"),
    ));
  }
}