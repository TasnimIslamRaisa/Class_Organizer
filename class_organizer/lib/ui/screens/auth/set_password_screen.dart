import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../style/app_color.dart';
import '../../widgets/background_widget.dart';
import 'SignInScreen.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  Text(
                    "Set Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Minimum length of password is 8 characters with a combination of letters and numbers",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: passController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    obscureText: true, // It's a good practice to obscure password fields
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: confirmPassController,
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: onTabConfirmButton,
                    child: const Text("Confirm"),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          letterSpacing: 0.4,
                        ),
                        text: "Have an account?",
                        children: [
                          TextSpan(
                            text: "  Sign-In",
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                onTabSignInButton();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTabSignInButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  void onTabConfirmButton() {
    // If there were API-related operations, they would be commented out here.
    // For example:

    // setState(() {
    //   registrationInProgress = true;
    // });

    // Future API call would go here
    // try {
    //   final response = await ApiService.setPassword(passController.text);
    //   if (response.isSuccessful) {
    //     // Navigate to Sign-In or show success message
    //   } else {
    //     // Show error message
    //   }
    // } catch (e) {
    //   // Handle exceptions
    // }

    // Since there's no API work, we'll just navigate to the Sign-In screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
