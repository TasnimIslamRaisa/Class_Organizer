import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade600, // Slightly adjusted
    secondary: Colors.grey.shade200, // Slightly adjusted for contrast
    inversePrimary: Colors.black54,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black87, // Slightly darker for better contrast
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black54, // Slightly darker
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    hintStyle: const TextStyle(
      color: Colors.black45,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      foregroundColor: Colors.white,
      backgroundColor: Colors.grey.shade600,
      fixedSize: const Size.fromWidth(double.maxFinite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black54,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);
