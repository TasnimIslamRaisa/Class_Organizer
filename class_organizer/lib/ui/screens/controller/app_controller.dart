import 'package:shared_preferences/shared_preferences.dart';

class AppController{
  static const String firstTimeKey='first_time';
  static bool firstTime=true;

  // Method to set firstTimeKey to false after the first launch
  static Future<void> setFirstTimeFalse(bool tab) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(firstTimeKey, false);
    firstTime=tab;
  }

  // Method to check if it's the first time the app is being opened
  static Future<bool> isFirstTimeInstall() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstTime = sharedPreferences.getBool(firstTimeKey) ?? true;
    firstTime = isFirstTime; // Update the static variable based on the stored value
    return isFirstTime;
  }



}