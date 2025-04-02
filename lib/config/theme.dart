// lib/config/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors for light theme
  static const Color lightPrimary = Color(0xFF2A86FF);
  static const Color lightAccent = Color(0xFF24C1FA);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Color(0xFF1D2939);
  static const Color lightSecondaryTextColor = Color(0xFF667085);
  static const Color lightIconColor = Color(0xFF344054);
  static const Color lightDividerColor = Color(0xFFEAECF0);

  // Colors for dark theme
  static const Color darkPrimary = Color(0xFF2B80ED);
  static const Color darkAccent = Color(0xFF1EA7E6);
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkCardColor = Color(0xFF1F2937);
  static const Color darkTextColor = Colors.white;
  static const Color darkSecondaryTextColor = Color(0xFFD1D5DB);
  static const Color darkIconColor = Color(0xFFE5E7EB);
  static const Color darkDividerColor = Color(0xFF374151);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightAccent,
      surface: lightCardColor,
    ),
    cardColor: lightCardColor,
    dividerColor: lightDividerColor,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: lightTextColor,
      displayColor: lightTextColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightCardColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: lightIconColor),
      titleTextStyle: GoogleFonts.inter(
        color: lightTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: lightCardColor,
      selectedIconTheme: const IconThemeData(color: lightPrimary),
      unselectedIconTheme: const IconThemeData(color: lightSecondaryTextColor),
      selectedLabelTextStyle: GoogleFonts.inter(
        color: lightPrimary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        color: lightSecondaryTextColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightDividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightDividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightPrimary),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkAccent,
      surface: darkCardColor,
    ),
    cardColor: darkCardColor,
    dividerColor: darkDividerColor,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: darkTextColor,
      displayColor: darkTextColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkCardColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: darkIconColor),
      titleTextStyle: GoogleFonts.inter(
        color: darkTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: darkCardColor,
      selectedIconTheme: const IconThemeData(color: darkPrimary),
      unselectedIconTheme: const IconThemeData(color: darkSecondaryTextColor),
      selectedLabelTextStyle: GoogleFonts.inter(
        color: darkPrimary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        color: darkSecondaryTextColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1F2937),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkDividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkDividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkPrimary),
      ),
    ),
  );
}