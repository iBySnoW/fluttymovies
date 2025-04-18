import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color accentGold = Color(0xFFFFB800);
  static const Color lightPurple = Color(0xFF8B85FF);
  static const Color darkPurple = Color(0xFF4A41FF);
  static const Color cineLight = Color(0xFFF8F9FA);
  static const Color movieNight = Color(0xFF121212);
  static const Color greyReel = Color(0xFF8E8E93);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [darkPurple, lightPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Thème clair
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: cineLight,
    colorScheme: ColorScheme.light(
      primary: primaryPurple,
      secondary: accentGold,
      tertiary: lightPurple,
      background: cineLight,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: movieNight,
      onSurface: movieNight,
      onTertiary: Colors.white,
    ),
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: movieNight,
        letterSpacing: -0.5,
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: movieNight,
        letterSpacing: -0.5,
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: movieNight,
        letterSpacing: -0.25,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: movieNight.withOpacity(0.87),
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: movieNight.withOpacity(0.87),
        letterSpacing: 0.25,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        color: greyReel,
        letterSpacing: 0.4,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );

  // Thème sombre
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: movieNight,
    colorScheme: ColorScheme.dark(
      primary: primaryPurple,
      secondary: accentGold,
      tertiary: lightPurple,
      background: movieNight,
      surface: const Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      onTertiary: Colors.white,
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.25,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFFAFAFB2),
        letterSpacing: 0.4,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2C2C2E),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
} 