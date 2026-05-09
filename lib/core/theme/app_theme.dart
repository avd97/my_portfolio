import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/custom_colors.dart';

class AppTheme {

  // ================= LIGHT COLORS =================

  static const Color lightPrimary = Color(0xFF00897B);
  static const Color lightBackground = Colors.white;
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightText = Colors.black87;
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightServiceCardBorder = Color(0xffffa08a);
  static const Color lightServiceCardBg = Color(0xffffe8e2);
  static const List<Color> lightServiceButtonGradient = [
    Color(0xFF00FF22),
    Color(0xFF99FF00),
    Color(0xFFFFF100),
  ];

  // ================= DARK COLORS =================

  static const Color darkPrimary = Color(0xFF26A69A);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Colors.white;
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkServiceCardBorder = Color(0xFFB86A5A);
  static const Color darkServiceCardBg = Color(0xFF2A1F1C);
  static const List<Color> darkServiceButtonGradient = [
    Color(0xFF006D14),
    Color(0xFF3E7A00),
    Color(0xFF8A7A00),
  ];

  // ================= COMMON =================

  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: lightBackground,

    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      surface: lightCard,
      onPrimary: Colors.white,
      onSurface: lightText,
      secondary: lightServiceCardBg,
      outline: lightServiceCardBorder,
    ),

    // ================= APP BAR =================

    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightText,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // ================= DIALOG =================

    dialogTheme: DialogThemeData(
      backgroundColor: lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ================= CARD =================

    cardColor: lightCard,

    // ================= ICON =================

    iconTheme: const IconThemeData(
      color: lightPrimary,
    ),

    // ================= TEXT =================

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: lightText,
        fontWeight: FontWeight.bold,
      ),

      titleMedium: TextStyle(
        color: lightText,
      ),

      bodyLarge: TextStyle(
        color: lightText,
      ),

      bodyMedium: TextStyle(
        color: lightText,
      ),
    ),

    // ================= INPUT =================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: lightPrimary,
          width: 1.5,
        ),
      ),
    ),

    // ================= BUTTON =================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    dividerColor: lightBorder,

    extensions: const [
      CustomColors(
        serviceCardBg: Color(0xffffe8e2),
        serviceCardBorder: Color(0xffffa08a),

        selectedServiceBg: Color(0xffeefbff),

        serviceButtonGradient: [
          Color(0xFF00FF22),
          Color(0xFF99FF00),
          Color(0xFFFFF100),
        ],
      ),
    ],
  );

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      surface: darkCard,
      onPrimary: Colors.white,
      onSurface: darkText,
      secondary: darkServiceCardBg,
      outline: darkServiceCardBorder,
    ),

    // ================= APP BAR =================

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkText,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // ================= DIALOG =================

    dialogTheme: DialogThemeData(
      backgroundColor: darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ================= CARD =================

    cardColor: darkCard,

    // ================= ICON =================

    iconTheme: const IconThemeData(
      color: darkPrimary,
    ),

    // ================= TEXT =================

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: darkText,
        fontWeight: FontWeight.bold,
      ),

      titleMedium: TextStyle(
        color: darkText,
      ),

      bodyLarge: TextStyle(
        color: darkText,
      ),

      bodyMedium: TextStyle(
        color: darkText,
      ),
    ),

    // ================= INPUT =================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF252525),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: darkPrimary,
          width: 1.5,
        ),
      ),
    ),

    // ================= BUTTON =================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    dividerColor: darkBorder,

    extensions: const [
      CustomColors(
        serviceCardBg: Color(0xFF2A1F1C),
        serviceCardBorder: Color(0xFFB86A5A),

        selectedServiceBg: Color(0xFF1E2A30),

        serviceButtonGradient: [
          Color(0xFF006D14),
          Color(0xFF3E7A00),
          Color(0xFF8A7A00),
        ],
      ),
    ],
  );
}