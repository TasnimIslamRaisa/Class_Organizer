import 'dart:async';

class AutoFunctionCaller {
  Timer? _timer;

  void startTimer({required Duration interval, required Function functionToCall}) {
    // Check if there's an existing timer running
    if (_timer == null || !_timer!.isActive) {
      // Start the timer to call the function at the given interval
      _timer = Timer.periodic(interval, (Timer timer) {
        functionToCall(); // Call the passed function every time the timer ticks
      });
    }else{
      stopTimer();
    }
  }

  void stopTimer() {
    // Cancel the timer if it's active
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null; // Set the timer to null after canceling
    }
  }
}

void someFunctionToCall() {
  print("Function called at ${DateTime.now()}");
}

void main() {
  AutoFunctionCaller functionCaller = AutoFunctionCaller();

  // Start calling the function every 5 seconds
  functionCaller.startTimer(
    interval: Duration(seconds: 5),
    functionToCall: someFunctionToCall,
  );

  // Optionally stop the timer after a certain condition is met
  Future.delayed(Duration(seconds: 20), () {
    print("Stopping timer...");
    functionCaller.stopTimer();
  });
}
