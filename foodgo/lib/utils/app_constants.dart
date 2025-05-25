// foodgo_app/lib/utils/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // --- Dark Mode Tracking (used for theming) ---
  static bool _isDarkMode = false;
  static void setDarkMode(bool value) => _isDarkMode = value;
  static bool get isDarkMode => _isDarkMode;

  // --- Colors ---
  static Color get primaryOrange => const Color(0xFFFF6B00);
  static Color get primaryYellow => const Color(0xFFFFA200);
  static Color get backgroundColor => _isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
  static Color get cardColor => _isDarkMode ? const Color(0xFF2C2C2C) : Colors.white;
  static Color get textColor => _isDarkMode ? Colors.white : Colors.black87;
  static Color get lightTextColor => _isDarkMode ? Colors.white70 : Colors.grey.shade600;

  static const Color successGreen = Color(0xFF28A745);
  static const Color errorRed = Color(0xFFDC3545);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color infoBlue = Color(0xFF17A2B8);
  static const Color grey = Colors.grey;
  static const Color white = Colors.white;

  static Color get lightGrey => _isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
  static Color get dividerColor => _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

  // --- Spacing & Dimensions ---
  static const double defaultSpacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 24.0;
  static const double largeSpacing = 32.0;
  static const double extraLargeSpacing = 48.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double buttonHeight = 50.0;

  // --- Padding (Now using `const`) ---
  static const EdgeInsets screenPadding = EdgeInsets.all(defaultSpacing);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: defaultSpacing);
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: defaultSpacing);

  // FIX: Initialize extraSmallSpacing with a const double value
  static const double extraSmallSpacing = 4.0; 

  // --- Text Styles (Dynamic because they depend on theme color) ---
  static TextStyle get headlineStyle => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle get titleStyle => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      );

  static TextStyle get subtitleStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: lightTextColor,
      );

  static TextStyle get bodyTextStyle => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      );

  static TextStyle get buttonTextStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle get captionStyle => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: lightTextColor,
      );

  static TextStyle get priceStyle => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryOrange,
      );
}