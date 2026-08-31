import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Primary Colors
  static const Color primaryColor = Color(0xFFE53935);
  static const Color secondaryColor = Color(0xFFFF6F61);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color scaffoldColor = Colors.white;
  static const Color textColor = Color(0xFF212121);
  static const Color subtitleColor = Colors.grey;
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      primaryColor: primaryColor,

      scaffoldBackgroundColor: scaffoldColor,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          foregroundColor: primaryColor,
          side: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),

        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),

        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),

        bodyLarge: TextStyle(
          fontSize: 16,
          color: textColor,
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          color: subtitleColor,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),

      dividerColor: Colors.grey.shade300,
    );
  }
}