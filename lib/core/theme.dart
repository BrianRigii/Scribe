import 'package:flutter/material.dart';

class ScribeTheme {
  // -----------------------
  // COLOR PALETTE
  // -----------------------
  static const Color sand = Color(0xFFF5F0E8);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color ink = Color(0xFF1A1A1A);
  static const Color olive = Color(0xFF5A6B5F);
  static const Color bronze = Color(0xFFB28A5A);
  static const Color softGrey = Color(0xFFCAC6BE);
  static const Color mutedText = Color(0xFF6B6B6B);

  // Accent / AI pulse color
  static const Color aiAccent = Color(0xFF7D9A8D);

  static const Color darkBackground = Color(0xFF0E0E0E);
  static const Color panelDark = Color(0xFF151515);
  static const Color darkCard = Color(0xFF181818);
  static const Color darkTextPrimary = Color(0xFFE8E4DE);
  static const Color darkTextSecondary = Color(0xFF9F9B94);
  static const Color darkShadow = Colors.black54;

  // -----------------------
  // LIGHT THEME
  // -----------------------
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: cream,
    useMaterial3: true,

    // -----------------------
    // TYPOGRAPHY
    // -----------------------
    fontFamily: 'Inter',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.6, color: ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: mutedText),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
    ),

    // -----------------------
    // APP BAR
    // -----------------------
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: cream,
      foregroundColor: ink,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
    ),

    // -----------------------
    // BUTTONS
    // -----------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: olive,
        foregroundColor: cream,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: aiAccent,
        foregroundColor: cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    // -----------------------
    // INPUTS
    // -----------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: sand,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: mutedText, fontSize: 14),
    ),

    // -----------------------
    // CARDS
    // -----------------------
    cardTheme: CardThemeData(
      color: cream,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // -----------------------
    // DIVIDER
    // -----------------------
    dividerTheme: const DividerThemeData(thickness: 1, color: softGrey),

    // -----------------------
    // ICONS
    // -----------------------
    iconTheme: const IconThemeData(color: ink, size: 22),

    // -----------------------
    // EFFECTS
    // -----------------------
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: darkBackground,

    // -----------------------
    // TYPOGRAPHY
    // -----------------------
    fontFamily: 'Inter',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: darkTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: darkTextPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.6, color: darkTextPrimary),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: darkTextSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
    ),

    // -----------------------
    // APPBAR
    // -----------------------
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: darkBackground,
      foregroundColor: darkTextPrimary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
    ),

    // -----------------------
    // BUTTONS
    // -----------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: olive,
        foregroundColor: sand,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: aiAccent,
        foregroundColor: sand,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    // -----------------------
    // INPUTS
    // -----------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: panelDark,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: darkTextSecondary, fontSize: 14),
    ),

    // -----------------------
    // CARDS
    // -----------------------
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: darkShadow,
    ),

    // -----------------------
    // DIVIDER
    // -----------------------
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2F2F2F),
      thickness: 1,
    ),

    // -----------------------
    // ICONS
    // -----------------------
    iconTheme: const IconThemeData(color: darkTextPrimary, size: 22),

    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}
