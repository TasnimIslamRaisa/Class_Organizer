import 'dart:async';

import 'package:get/get.dart';

class OTPController extends GetxController {
  var countdown = 120.obs;
  var isResendEnabled = false.obs;
  late Timer _timer;

  @override
  void onInit() {
    startCountdown();
    super.onInit();
  }

  void startCountdown() {
    isResendEnabled.value = false;
    countdown.value = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        isResendEnabled.value = true;
        _timer.cancel();
      }
    });
  }

  void resendCode() {
    // Add the code to resend the OTP here (e.g., API call)
    print("Resend code called");
    // Restart the countdown after resending the code
    startCountdown();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
