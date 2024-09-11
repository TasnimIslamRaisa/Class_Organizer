import 'dart:async';
import 'package:class_organizer/ui/screens/auth/set_password_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../style/app_color.dart';
import '../../widgets/background_widget.dart';
import '../controller/otp_controller.dart';
import 'SignInScreen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final OTPController otpController = Get.put(OTPController());

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

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
                    "PIN Verification",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "A 6 digit verification pin has been sent to your email address",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  PinCodeTextField(
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      selectedFillColor: AppColors.secondaryColor,
                      inactiveFillColor: AppColors.secondaryColor,
                    ),
                    keyboardType: TextInputType.number,
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: _otpController,
                    appContext: context,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: onTabVerifyButton,
                    child: const Text("Verify",),
                  ),
                  const SizedBox( height: 45,),
                  Obx(()=>Center(
                    child: RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            text: "This code will expire in : ",
                            children:  [
                              TextSpan(
                                  text: '${otpController.countdown.value}s',

                                  style:const TextStyle(
                                    color: Colors.lightBlueAccent,
                                  )
                              ),
                            ]
                        )
                    ),
                  )),
                  const SizedBox(height: 6,),
                  Obx(
                        () => Center(
                          child: TextButton(
                                                onPressed: otpController.isResendEnabled.value
                            ? otpController.resendCode
                            : null,
                                                child: const Text("Resend Code",
                            style:const TextStyle(
                          color: Colors.lightBlueAccent,
                                                )),
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

  void onTabVerifyButton() {
    // Commented out API-related code
    // Replace with navigation to SetPasswordScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SetPasswordScreen(),
      ),
    );
  }

  void onTabSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    errorController.close(); // Close the StreamController to prevent memory leaks
    super.dispose();
  }
}
