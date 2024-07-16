import 'package:class_organizer/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return GetStartState();

  }
  
}

class GetStartState extends State<GetStart>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Center(
      child: ElevatedButton(onPressed: ()async{
        final press = await SharedPreferences.getInstance();
        press.setBool("onboarding", true);
        if(!mounted)return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginPage()));
      }, child: Text("Get Started")),
    ),));
  }
}