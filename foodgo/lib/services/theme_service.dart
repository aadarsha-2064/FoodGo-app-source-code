// In services/theme_service.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import '../utils/app_constants.dart'; // Make sure this import is correct

class ThemeService with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeData getCurrentTheme(BuildContext context) {
    // This method getCurrentTheme *does* take context because you defined it that way.
    // And _buildDarkTheme and _buildLightTheme also take context.
    return _themeMode == ThemeMode.dark ? _buildDarkTheme(context) : _buildLightTheme(context);
  }

  // Internal method to build light theme
  ThemeData _buildLightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppConstants.primaryOrange,
      // textTheme: TextTheme(bodyMedium: AppConstants.bodyTextStyle), // Changed: no (context)
      // If AppConstants colors and styles are context-dependent, use them here too!
      scaffoldBackgroundColor: AppConstants.backgroundColor, // **FIXED: Removed (context)**
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.backgroundColor, // **FIXED: Removed (context)**
        foregroundColor: AppConstants.textColor, // **FIXED: Removed (context)**
        elevation: 0,
      ),
      // ... other theme properties
    );
  }

  // Internal method to build dark theme
  ThemeData _buildDarkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppConstants.primaryOrange,
      // textTheme: TextTheme(bodyMedium: AppConstants.bodyTextStyle), // Changed: no (context)
      scaffoldBackgroundColor: AppConstants.backgroundColor, // **FIXED: Removed (context)**
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.backgroundColor, // **FIXED: Removed (context)**
        foregroundColor: AppConstants.textColor, // **FIXED: Removed (context)**
        elevation: 0,
      ),
      // ... other theme properties
    );
  }

  void toggleTheme(ThemeMode? newThemeMode) {
    if (newThemeMode != null) {
      _themeMode = newThemeMode;
      notifyListeners();
    }
  }

  ThemeService() {
    // You might read saved theme preference here
  }
}