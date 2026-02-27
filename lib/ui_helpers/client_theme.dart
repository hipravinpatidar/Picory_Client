import 'package:flutter/material.dart';

class ClientTheme {
  // Primary Colors - Soft and Friendly
  static const Color primaryPurple = Color(0xFF8B7FD9);
  static const Color lightPurple = Color(0xFFB5A9F5);
  static const Color deepPurple = Color(0xFF6C5CE7);

  // Background Colors - Soft White
  static const Color softWhite = Color(0xFFFAFAFC);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F7);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFF95A5A6);

  // Accent Colors
  static const Color accentPink = Color(0xFFFF6B9D);
  static const Color accentBlue = Color(0xFF74B9FF);
  static const Color successGreen = Color(0xFF55EFC4);
  static const Color warningOrange = Color(0xFFFAB1A0);

  // Border Radius - Rounded Modern Cards
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 28.0;

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;

  // ==================== LIGHT THEME ====================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryPurple,
      secondary: lightPurple,
      surface: cardWhite,
      background: softWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onBackground: textPrimary,
    ),
    scaffoldBackgroundColor: softWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: cardWhite,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'SF Pro Display',
      ),
    ),

    // FIXED: Changed 'CardTheme' to 'CardThemeData'
    cardTheme: CardThemeData(
      color: cardWhite,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: const BorderSide(color: primaryPurple, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGray,
      hintStyle: const TextStyle(color: textLight, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    fontFamily: 'SF Pro Display',
  );

  // ==================== GRADIENT DECORATIONS ====================

  static BoxDecoration purpleGradient = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryPurple, deepPurple],
    ),
    borderRadius: BorderRadius.circular(radiusLarge),
  );

  static BoxDecoration softPurpleGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryPurple.withOpacity(0.1), lightPurple.withOpacity(0.1)],
    ),
    borderRadius: BorderRadius.circular(radiusLarge),
  );
}