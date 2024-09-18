import 'package:class_organizer/models/school.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user.dart';
import '../pages/login/login_page.dart';

class Logout {
  static const String PREF_NAME = 'eduBoxLogin';
  static const String INSTALLER_NAME = 'eduBoxInstaller';
  static const String KEY_IS_LOGGED_IN = 'isLoggedIn';
  static const String INSTALLER_ID = 'isInstalled';
  static const String USER_ID = 'userId';
  static const String USER_PHONE = 'userPhone';
  static const String USER_EMAIL = 'userEmail';
  static const String USER_KEY = 'userKey';
  static const String SCHOOL_KEY = 'schoolKey';
  static const String KEY_USER_TYPE = "u_type";

  Future<void> saveUser(Map<String, dynamic> user, {String key = USER_KEY}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(user));
  }

  Future<void> saveUserDetails(User user, {String key = USER_KEY}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson());
  await prefs.setString(key, userJson);
}

  Future<Map<String, dynamic>?> getUser({String key = USER_KEY}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(key);
    if (userJson != null) {
      return jsonDecode(userJson);
    } else {
      return null;
    }
  }

  Future<User?> getUserDetails({String key = USER_KEY}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString(key);

  if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }
  return null;
}

  Future<void> clearUser({String key = USER_KEY, String key_key = USER_KEY}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    prefs.remove(key_key);
  }

  Future<void> getOut(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    logout(context);
  }

  void logout(BuildContext context) {
    // Navigation to the appropriate page based on login status
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()), 
      (Route<dynamic> route) => false,
    );
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(KEY_IS_LOGGED_IN, isLoggedIn);
  }
  Future<void> setUserType(int userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(KEY_USER_TYPE, userType);
  }

  Future<int?> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Logout.KEY_USER_TYPE);
  }

    Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(KEY_IS_LOGGED_IN, false);
  }

  Future<void> setInstaller(bool isInstalled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(INSTALLER_ID, isInstalled);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGED_IN) ?? false;
  }

  Future<bool> isInstalled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(INSTALLER_ID) ?? false;
  }

  static Future<void> setUserData(String key, dynamic value, {String? pref}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    }
  }

  static Future<dynamic> getUserData(String key, {dynamic defaultValue, String? pref}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? defaultValue;
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> saveSchool(Map<String, dynamic> school, {String key = SCHOOL_KEY}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(school));
  }

  Future<Map<String, dynamic>?> getSchool({String key = SCHOOL_KEY}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schoolJson = prefs.getString(key);
    if (schoolJson != null) {
      return jsonDecode(schoolJson);
    } else {
      return null;
    }
  }
  Future<School?> getSchoolDetails({String key = SCHOOL_KEY}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schoolJson = prefs.getString(key);
    if (schoolJson != null) {
      Map<String, dynamic> schoolMap = jsonDecode(schoolJson);
      return School.fromJson(schoolMap);
    } else {
      return null;
    }
  }
}
