
import 'package:flutter/material.dart';

import '../../style/app_color.dart';

ThemeData lightTheme(){
  return ThemeData(
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor),
      labelMedium : TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.subtitleColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.secondaryColor,
      filled: true,
      hintStyle: const TextStyle(
        color: AppColors.subtitleColor,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: AppColors.secondaryColor,
            backgroundColor: AppColors.primaryColor,
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: AppColors.subtitleColor,
          textStyle:const TextStyle(
            fontWeight: FontWeight.w600,
          )
      ),
    ),
  );
}
