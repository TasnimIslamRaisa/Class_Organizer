import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class InternetConnectivity {
  // This function checks the current connection status
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // Connected to the internet
    } else {
      return false; // No internet connection
    }
  }


  StreamSubscription<List<ConnectivityResult>> checkConnectionContinuously(
      Function(bool) onConnectionChange) {
    return Connectivity().onConnectivityChanged.listen((result) {
      bool isConnected = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
      onConnectionChange(isConnected);
    });
  }
}
