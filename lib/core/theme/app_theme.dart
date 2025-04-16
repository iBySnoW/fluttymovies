import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales
  static const Color popcornRed = Color(0xFFFF3B30);
  static const Color sunlightGold = Color(0xFFFFD60A);
  static const Color cineLight = Color(0xFFF8F9FA);
  static const Color movieNight = Color(0xFF121212);
  static const Color freshLime = Color(0xFF34C759);
  static const Color trailerBlue = Color(0xFF0A84FF);
  static const Color greyReel = Color(0xFF8E8E93);
  
  // Nouvelles couleurs
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color softBlue = Color(0xFF5B8DEF);
  static const Color neonPink = Color(0xFFFF2D55);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [popcornRed, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Thème clair
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: popcornRed,
    scaffoldBackgroundColor: cineLight,
    colorScheme: ColorScheme.light(
      primary: popcornRed,
      secondary: accentPurple,
      tertiary: freshLime,
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
        backgroundColor: popcornRed,
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
        borderSide: const BorderSide(color: popcornRed, width: 2),
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
    primaryColor: neonPink,
    scaffoldBackgroundColor: movieNight,
    colorScheme: ColorScheme.dark(
      primary: neonPink,
      secondary: accentPurple,
      tertiary: freshLime,
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
        backgroundColor: neonPink,
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
        borderSide: const BorderSide(color: neonPink, width: 2),
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