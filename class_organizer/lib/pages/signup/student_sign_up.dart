import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StudentSignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentSignUpState();
  }
}

class StudentSignUpState extends State<StudentSignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: Lottie.asset(
                    'animation/edumain.json',
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.35,
                    reverse: true,
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Positioned(
                  bottom: 1,
                  child: Center(
                    child: Text(
                      "Let's get started--->",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter your required data to register your account!",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: textFeildOne("Phone", "Phone Number"),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: textFeildOne("Email", "Email/Gmail/123/petalmail"),
            ),
          ],
        ),
      ),
    ));
  }

  TextFormField textFeildOne(String label, String hint) {
    return TextFormField(
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {},
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          height: 0.5,
        ),
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 17,
          color: Color.fromARGB(255, 241, 241, 241),
          height: 0.7,
        ),
        prefixIcon: Icon(
          Icons.mobile_screen_share,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        fillColor: Color.fromARGB(255, 146, 119, 119),
        filled: true,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
          width: 0.7,
        )),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        )),
        disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        )),
        errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromARGB(255, 146, 24, 24),
          width: 1.2,
        )),
        focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromARGB(255, 146, 24, 24),
          width: 1.2,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(40)),
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
