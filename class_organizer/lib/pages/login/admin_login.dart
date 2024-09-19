import 'dart:async';

import 'package:class_organizer/admin/panel/admin_panel.dart';
import 'package:class_organizer/pages/school/create_school.dart';
import 'package:class_organizer/preference/preferences.dart';
import 'package:class_organizer/teacher/panel/teacher_panel.dart';
import 'package:class_organizer/ui/Home_Screen.dart';
import 'package:class_organizer/ui/screens/auth/SignUpScreen.dart';
import 'package:class_organizer/ui/screens/auth/admin_sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../../db/database_helper.dart';
import '../../models/school.dart';
import '../../models/user.dart' as local;
import '../../preference/logout.dart';
import '../../ui/screens/auth/email_verification_screen.dart';
import '../../utility/app_constant.dart';
import '../../web/internet_connectivity.dart';
import '../forgot_password.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';

late bool _passwordVisible = false;

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});


  @override
  State<StatefulWidget> createState() {
    return AdminLoginState();
  }
}

class AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isConnected = false;
  late StreamSubscription subscription;
  final internetChecker = InternetConnectivity();
  StreamSubscription<InternetConnectionStatus>? connectionSubscription;

  @override
  initState() {
    super.initState();
    checkLoginStatus();
    preference();
    _passwordVisible = true;

    startListening();
    checkConnection();

    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });
  }

  void checkConnection() async {
    bool result = await internetChecker.hasInternetConnection();
    setState(() {
      isConnected = result;
    });
  }


      StreamSubscription<InternetConnectionStatus> checkConnectionContinuously() {
        return InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
          if (status == InternetConnectionStatus.connected) {
            isConnected = true;
            print('Connected to the internet');
          } else {
            isConnected = false;
            print('Disconnected from the internet');
          }
        });
      }

    void startListening() {
      connectionSubscription = checkConnectionContinuously();
    }

    void stopListening() {
      connectionSubscription?.cancel();
    }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.blue,
        body: ListView(
          children: [
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    child: Lottie.asset(
                      'animation/edu1.json',
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height / 2.2,
                      reverse: true,
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi!",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        " Admin",
                        style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Sign in to Continiue.",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                      ),
                      child: Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 45,
                                  ),
                                  TextFormField(
                                    controller: _usernameController,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: "Email/Phone",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 0.5,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.yellow,
                                        height: 0.7,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 0.7,
                                      )),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 0.7,
                                      )),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Color.fromARGB(255, 146, 24, 24),
                                        width: 1.2,
                                      )),
                                      focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Color.fromARGB(255, 146, 24, 24),
                                        width: 1.2,
                                      )),
                                    ),
                                    validator: (value) {
                                        if (value?.trim().isEmpty ?? true) {
                                          return "Enter Your Email or Phone Number ";
                                        }
                                        // if (AppConstant.emailRegExp.hasMatch(value!) == false) {
                                        //   return "Enter a valid email address";
                                        // }
                                        if (RegExp(r'^[0-9]+$').hasMatch(value!.trim())) {
                                          // (assuming phone numbers should be at least 10 digits)
                                          if (value.length < 10) {
                                            return "Enter a valid phone number";
                                          }
                                          return null;
                                        }
                                        if (AppConstant.emailRegExp.hasMatch(value.trim()) == false) {
                                          return "Enter a valid email address";
                                        }
                                        return null;
                                      // RegExp regExp = new RegExp(
                                      //     r'^\+?(\d{1,3})?[-. \(\)]?(\d{1,4})?[-. \(\)]?\d{1,4}[-. ]?\d{1,4}[-. ]?\d{1,9}$');
                                      // if (value == null || value.isEmpty) {
                                      //   return "Please enter your mobile number...";
                                      // } else if (!regExp.hasMatch(value)) {
                                      //   return "Pleasel enter a valid phone number..";
                                      // }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _passwordVisible,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.visiblePassword,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                        icon: Icon(_passwordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_off_outlined),
                                        iconSize: 20,
                                      ),
                                      labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 0.5,
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.yellow,
                                        height: 0.7,
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 0.7,
                                      )),
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                      disabledBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 0.7,
                                      )),
                                      errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Color.fromARGB(255, 146, 24, 24),
                                        width: 1.2,
                                      )),
                                      focusedErrorBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                        color: Color.fromARGB(255, 146, 24, 24),
                                        width: 1.2,
                                      )),
                                    ),
                                    validator: (value) {},
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!
                                            .validate()) {

                                              String username =
                                                  _usernameController.text;
                                              String password =
                                                  _passwordController.text;

                                              adminSignIn(username, password);
                                            }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        padding: EdgeInsets.only(right: 18),
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.blue,
                                                Colors.amber
                                              ],
                                              begin: FractionalOffset(0.4, 0.3),
                                              end: FractionalOffset(0.7, 0.0),
                                              stops: [0.0, 1.8],
                                              tileMode: TileMode.clamp,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Spacer(),
                                            Text(
                                              "Sign In",
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_outlined,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmailVerificationScreen()));
                                    },
                                    child: const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminSignUp()));
                                    },
                                    child: const Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        "Not yet registered? Sign Up ->",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

    void checkLoginStatus() async {

  bool isLoggedIn = await Logout().isLoggedIn();
  int? isUser = await Logout().getUserType();

  if (isLoggedIn) {

    if(isUser != null){
      if(isUser==1){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPanel(),
          ),
        );
      }else if(isUser==2){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherPanel(),
          ),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    }

  } else {
    // User is not logged in, stay on the sign-in screen
  }
}

  Future<void> adminSignIn(String username, String password) async {

      if (mounted) {
      setState(() {});
    }

    if(await InternetConnectionChecker().hasConnection){

      try {
        firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: username, password: password);

        firebase_auth.User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          DatabaseReference userRef = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(firebaseUser.uid);

          final snapshot = await userRef.get();

          if (snapshot.exists) {
            Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
            local.User user = local.User.fromMap(userData);

                // await Logout().setLoggedIn(true);
            // await Logout().setUserType(uType);
                // await Logout().saveUser(user.toMap(), key: "user_logged_in");
                // await Logout().saveUserDetails(user,key: "user_data");

                print('user sid: ${user.phone}');

                if (mounted) {
                  checkOnlineSchool(user);
                }


          } else {
            showSnackBarMsg(context, 'User data not found!');
          }
        }
      } on firebase_auth.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBarMsg(context, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showSnackBarMsg(context, 'Wrong password provided.');
        } else {
          showSnackBarMsg(context, e.message ?? 'An error occurred.');
        }
      } finally {
        setState(() {

        });
      }

    }else{
          // local.User? user = await DatabaseHelper().checkUserByPhone(email, password);

          local.User? user = await DatabaseHelper().checkUserLogin(username, password,1);


          if (mounted) {
            setState(() {});
          }

        if (user != null) {
          await Logout().setLoggedIn(true);
          await Logout().setUserType(user.utype ?? 1);
          await Logout().saveUser(user.toMap(), key: "user_logged_in");
          await Logout().saveUserDetails(user,key: "user_data");
          
          if (mounted) {
            checkSchool(user);
          }

        } else {

          if (mounted) {
            showSnackBarMsg(context, 'Email or password is not correct!');
          }
        }
    }

}
void showSnackBarMsg(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  preference() async {
    if (await Preferences.checkUserType() == "admin") {
      print("Installed");
    } else {
      print("Not Installed");
    }
  }
  
  void checkSchool(local.User user) {
    if(user.sid == null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateSchool(),
        ),
      );
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPanel(),
        ),
      );
    }
  }

    Future<void> checkOnlineSchool(local.User user) async {
    if(user.sid == null){
      await Logout().saveUser(user.toMap(), key: "user_logged_in");
      await Logout().saveUserDetails(user,key: "user_data");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateSchool(),
        ),
      );
    }else{
          await Logout().setLoggedIn(true);
          await Logout().setUserType(user.utype ?? 1);
          await Logout().saveUser(user.toMap(), key: "user_logged_in");
          await Logout().saveUserDetails(user,key: "user_data");

          await getSchoolBySId(user.sid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPanel(),
        ),
      );
    }
  }

  Future<void> getSchoolBySId(String? sid) async {
    if (sid == null) {
      print("SID is null, unable to fetch school data.");
      return;
    }

    final DatabaseReference dbRef = FirebaseDatabase.instance.ref("schools").child(sid);

    try {
      final DataSnapshot snapshot = await dbRef.get();

      if (snapshot.exists) {
        final Map<String, dynamic> schoolData = Map<String, dynamic>.from(snapshot.value as Map);
        School school = School.fromMap(schoolData);

        await Logout().saveSchool(school.toMap(),key: "school_data");

        print("School data fetched successfully: ${school.sName}");

      } else {
        print("School with SID $sid does not exist.");
      }
    } catch (e) {
      print("Error fetching school data: $e");
    }
  }


}
