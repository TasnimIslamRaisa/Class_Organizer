import 'package:shared_preferences/shared_preferences.dart';

class AppController{
  static const String firstTimeKey='first_time';

  // Method to check if it's the first time the app is being opened
  static Future<bool> isFirstTimeInstall() async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    return sharedPreferences.getBool(firstTimeKey) ?? true;
  }

  // Method to set firstTimeKey to false after the first launch
  static Future<void> setFirstTimeFalse() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(firstTimeKey, false);
  }
}