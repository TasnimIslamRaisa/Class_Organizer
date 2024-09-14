import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.black87, // Slightly lighter for better contrast
    primary: Colors.grey.shade700, // Adjusted for better visibility
    secondary: Colors.grey.shade800,
    inversePrimary: Colors.white70, // Lighter for better contrast
  ),
);
