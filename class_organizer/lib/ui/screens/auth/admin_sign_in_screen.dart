import 'package:class_organizer/ui/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../style/app_color.dart';
import '../../../utility/app_constant.dart';
import '../../widgets/background_widget.dart';
import 'SignUpScreen.dart';
import 'email_verification_screen.dart';

class AdminSignInScreen extends StatefulWidget {
  const AdminSignInScreen({super.key});

  @override
  State<AdminSignInScreen> createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
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
                          return "Enter Your Email ";
                        }
                        if (AppConstant.emailRegExp.hasMatch(value!) == false) {
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
                    Visibility(
                      visible: signInApiInProgress == false,
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

  Future<void> signUp() async {
    // signInApiInProgress = true;
    // if (mounted) {
    //   setState(() {});
    // }
    // Map<String, dynamic> requestdata = {
    //   "email": emailController.text.trim(),
    //   "password": passWordController.text,
    // };
    // final NetworkResponse response =
    //     await NetworkCaller.postRequest(Urls.login, body: requestdata);
    // signInApiInProgress = true;
    // if (mounted) {
    //   setState(() {});
    // }
    // if (response.isSuccess) {
    //   LogInModel loginModel = LogInModel.fromJson(response.responseData);
    //   await AuthController.saveUserAccessToken(loginModel.token!);
    //   await AuthController.saveUserdata(loginModel.userModel!);
    //   if (mounted) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const MainAppScreen(),
    //       ),
    //     );
    //   }
    // } else {
    //   if (mounted) {
    //     showSnackBarMsg(
    //         context, response.errorMsg ?? 'Email or password is not correct!');
    //   }
    // }
  }

  void onTabNextButton() {
    if (_formkey.currentState!.validate()) {
      // signUp();
      // For now, navigate to MainAppScreen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  void onTabSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
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

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }
}
