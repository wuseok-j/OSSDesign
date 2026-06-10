import 'package:flutter/material.dart';

class DungeonTheme {
  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFF9A826),
      scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      cardColor: const Color(0xFF2D2D44),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E2C),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF9A826),
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      fontFamily: 'Roboto', // Replace with GoogleFonts if available later
    );
  }
}
