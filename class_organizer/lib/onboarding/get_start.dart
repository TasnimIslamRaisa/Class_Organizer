import 'package:class_organizer/pages/login/admin_login.dart';
import 'package:class_organizer/ui/screens/auth/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login/login_page.dart';

class GetStart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return GetStartState();

  }
  
}

class GetStartState extends State<GetStart>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: const BoxDecoration(
                  color: Colors.white,

                ),

              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 48, 60, 230),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(80))
                ),
                child: Center(
                  child: Lottie.asset(
                    'animation/edu1.json',
                    width: MediaQuery.sizeOf(context).height,
                    height: MediaQuery.sizeOf(context).width,
                    reverse: true,
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.999,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 48, 60, 230),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.999,
              padding: const EdgeInsets.only(top: 40, bottom: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
              ),
              child: Column(
                children: [
                  const Text("Learning is Everything!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, letterSpacing: 1, wordSpacing: 2),),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text("Let's Explore as...",style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),),
                  ),
                  const SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: ()async{
                          final press = await SharedPreferences.getInstance();
                          press.setBool("onboarding", true);
                          press.setString("user_type", "user");
                          if(!mounted)return;
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const SignInScreen()));
                        }, style: const ButtonStyle(
                          

                        ), child: const Text("USER")),
                        ElevatedButton(onPressed: ()async{
                          final press = await SharedPreferences.getInstance();
                          press.setBool("onboarding", true);
                          press.setString("user_type", "admin");
                          if(!mounted)return;
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const AdminLogin()));
                        }, child: const Text("ADMIN")),
                      ],
                    ),
                  )
              ],),
            ),
          ),
        ],),)
    ),));
  }
}