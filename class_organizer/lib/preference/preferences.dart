import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences{

  static String userType = "user_type";
  static String userTypeValue = "user";
  static bool onboarding = false;

  static SharedPreferences? sharedPreference;

  Preferences(){
    prference();
  }
  
  Future<void> prference() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreference = sharedPreferences;
  }

  static Future<void> setInstallation(String userType)async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userTypeValue = userType;
    onboarding = true;
    sharedPreferences.setBool("onboarding", onboarding);
    sharedPreferences.setString(userType, userTypeValue);
  }

  static Future<bool> checkInstalled()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("onboarding")??onboarding;
    
  }

  static Future<String> checkUserType()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("user_type")??userTypeValue;
  }

}