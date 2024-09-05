import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'lightTheme.dart';  // Assuming dark mode styles are in this file

class ThemeProvider extends ChangeNotifier {
  // Initially set to light theme
  ThemeData _themeData = lightMode;

  // Getter for current theme
  ThemeData get themeData => _themeData;

  // Check if dark mode is active
  bool get isDarkMode => _themeData == darkMode;

  // Setter to change theme and notify listeners
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();  // Updates UI
  }

  // Toggle between light and dark themes
  void toggleTheme() {
    if (_themeData == lightMode ){
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
