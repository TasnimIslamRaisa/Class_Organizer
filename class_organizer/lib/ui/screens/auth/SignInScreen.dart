import 'package:class_organizer/preference/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// import '../../../data/logInModel.dart';
// import '../../../data/network_caller.dart';
// import '../../../data/network_response.dart';
// import '../../../data/urls.dart';
import '../../../db/database_helper.dart';
import '../../../models/user.dart';
import '../../../style/app_color.dart';
import '../../../utility/app_constant.dart';
import '../../Home_Screen.dart';
import '../../widgets/background_widget.dart';
// import '../controller/auth_controller.dart';
import 'SignUpScreen.dart';
import 'email_verification_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool signInApiInProgress = false;
  bool showPassWord = false;

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
                        DropdownMenuItem(value: 'Student', child: Text('Student',)),
                        DropdownMenuItem(value: 'Teacher', child: Text('Teacher')),
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        // Add more departments as needed
                      ],
                      onChanged: (value) {
                        // Handle department selection
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

    User? user = await DatabaseHelper().checkUserByPhone(email, password);


    // Map<String, dynamic> requestdata = {
    //   "email": emailController.text.trim(),
    //   "password": passWordController.text,
    // };
    // final NetworkResponse response =
    // await NetworkCaller.postRequest(Urls.login, body: requestdata);
    signInApiInProgress = true;
    if (mounted) {
      setState(() {});
    }

  if (user != null) {
    await Logout().setLoggedIn(true);
    await Logout().saveUser(user.toMap(), key: "user_logged_in");

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  } else {

    if (mounted) {
      showSnackBarMsg(context, 'Email or password is not correct!');
    }
  }

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

@override
void initState() {
  super.initState();
  checkLoginStatus();
}

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }
}
