import 'package:flutter/material.dart';

class DungeonTheme {
  // Pixel Art / RPG 느낌의 컬러 팔레트
  static const Color background = Color(0xFF1E1E2E);
  static const Color surface = Color(0xFF2D2D44);
  static const Color primary = Color(0xFFF9A826); // 던전의 황금빛
  static const Color secondary = Color(0xFFE63946); // 몬스터 피격/경고
  static const Color textMain = Color(0xFFF8F9FA); // 가독성을 위한 밝은 텍스트
  static const Color textMuted = Color(0xFFADB5BD);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),
      fontFamily: 'NotoSansKR', // 가독성을 위한 기본 폰트
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0, // RPG 게임 타이틀 느낌
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black, width: 2), // 도트 느낌의 테두리
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
