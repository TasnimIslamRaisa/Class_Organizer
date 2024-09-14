import 'dart:async';

import 'package:class_organizer/preference/logout.dart';
import 'package:class_organizer/teacher/panel/teacher_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
// import '../../../data/logInModel.dart';
// import '../../../data/network_caller.dart';
// import '../../../data/network_response.dart';
// import '../../../data/urls.dart';
import '../../../db/database_helper.dart';
import '../../../models/user.dart' as local;
import '../../../style/app_color.dart';
import '../../../utility/app_constant.dart';
import '../../../web/internet_connectivity.dart';
import '../../Home_Screen.dart';
import '../../widgets/background_widget.dart';
// import '../controller/auth_controller.dart';
import 'SignUpScreen.dart';
import 'email_verification_screen.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

final _auth = firebase_auth.FirebaseAuth.instance;
final _databaseRef = FirebaseDatabase.instance.ref();
  

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool signInApiInProgress = false;
  bool showPassWord = false;
  String? selectedRole;
  int uType = 0;

  bool isConnected = false;
  late StreamSubscription subscription;
  final internetChecker = InternetConnectivity();
  StreamSubscription<InternetConnectionStatus>? connectionSubscription;

  @override
void initState() {
  super.initState();
  checkLoginStatus();

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
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SafeArea(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    Text(
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
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
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: passWordController,
                      obscureText: showPassWord == false,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            showPassWord = !showPassWord;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: Icon(showPassWord
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Your Password ";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Sign In As',
                        suffixStyle: TextStyle(
                          color: AppColors.subtitleColor,
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      items: const [
                        DropdownMenuItem(value: '3', child: Text('Student',)),
                        DropdownMenuItem(value: '2', child: Text('Teacher')),
                        // DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        // Add more departments as needed
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Select Any Option ";
                        }
                        // if (value != passWordController.text) {
                        //   return "Passwords do not match";
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    Visibility(
                      visible: signInApiInProgress==false,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: onTabNextButton,
                        child: const Icon(Icons.arrow_right),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              onTabForgotPasswordButton();
                            },
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            // style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                  letterSpacing: 0.4),
                              text: "Don't have an account?",
                              children: [
                                TextSpan(
                                  text: "  Sign-Up",
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      onTabSignUpButton();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

void showSnackBarMsg(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  Future<void> signUp() async {
    signInApiInProgress = true;
    if (mounted) {
      setState(() {});
    }


  String email = emailController.text.trim();
  String password = passWordController.text.trim();

  if(selectedRole=="3"){
    uType = 3;
  }else{
    uType = 2;
  }

    if(await InternetConnectionChecker().hasConnection){

      try {
        firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

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

            if (mounted) {
              if(selectedRole=="3"){
                uType = 3;
                if(uType==user.utype){
                  
                  await Logout().setLoggedIn(true);
                  await Logout().saveUser(user.toMap(), key: "user_logged_in");
                  await Logout().saveUserDetails(user, key: "user_data");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                }else{
                  showSnackBarMsg(context, 'You are the wrong guy!');
                }
              }else{
                uType = 2;
                if(uType==user.utype){
                  await Logout().setLoggedIn(true);
                  await Logout().saveUser(user.toMap(), key: "user_logged_in");
                  await Logout().saveUserDetails(user, key: "user_data");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeacherPanel(),
                      ),
                    );
                }else{
                  showSnackBarMsg(context, 'You are the wrong guy!');
                }
              }
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
          signInApiInProgress = false;
        });
      }

    }else{
      // User? user = await DatabaseHelper().checkUserByPhone(email, password);

      local.User? user = await DatabaseHelper().checkUserLogin(email, password,uType);

          signInApiInProgress = true;
          if (mounted) {
            setState(() {});
          }

          if (user != null) {

            if (mounted) {

              if(selectedRole=="3"){
                uType = 3;
                if(uType==user.utype){
                      await Logout().setLoggedIn(true);
                      await Logout().saveUser(user.toMap(), key: "user_logged_in");
                      await Logout().saveUserDetails(user,key: "user_data");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                }else{
                  showSnackBarMsg(context, 'You are the wrong guy!!');
                }
              }else{
                uType = 2;
                if(uType==user.utype){
                      await Logout().setLoggedIn(true);
                      await Logout().saveUser(user.toMap(), key: "user_logged_in");
                      await Logout().saveUserDetails(user,key: "user_data");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeacherPanel(),
                      ),
                    );
                }else{
                  showSnackBarMsg(context, 'You are the wrong guy!');
                }
              }


            }
          } else {

            if (mounted) {
              showSnackBarMsg(context, 'Email or password is not correct!');
            }
          }

    }



    // Map<String, dynamic> requestdata = {
    //   "email": emailController.text.trim(),
    //   "password": passWordController.text,
    // };
    // final NetworkResponse response =
    // await NetworkCaller.postRequest(Urls.login, body: requestdata);
    // if (response.isSuccess) {
    //   LogInModel  loginModel=LogInModel.fromJson(response.responseData);
    //   await AuthController.saveUserAccessToken(loginModel.token!);
    //   await AuthController.saveUserdata(loginModel.userModel!);
    //   if(mounted){
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const MainAppScreen(),
    //       ),
    //     );
    //   }
    // } else {
    //   if(mounted){
    //     showSnackBarMsg(
    //         context, response.errorMsg ?? 'Email or password is not correct!');
    //   }
    // }
  }

  void onTabNextButton() {

    if (_formkey.currentState!.validate()) {
      signUp();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const HomeScreen(),
      //   ),
      // );
    }
  }

  void onTabSignUpButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
        (route)=>false,
    );
  }

  void onTabForgotPasswordButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }




  void checkLoginStatus() async {

  bool isLoggedIn = await Logout().isLoggedIn();

  if (isLoggedIn) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  } else {
    // User is not logged in, stay on the sign-in screen
  }
}

Future<bool> checkInternetConnection() async {
  bool isConnected = await internetChecker.hasInternetConnection();
  return isConnected;
}

}
