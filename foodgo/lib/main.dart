// foodgo_app/lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For state management

// Import our services
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'services/cart_service.dart';

// Import our pages
// We will now start with SplashScreen, so HomePage and LoginPage are imported by SplashScreen
import 'pages/splash_screen.dart'; // <--- NEW: Import your SplashScreen

// Import our utility constants
import 'utils/app_constants.dart';

void main() {
  // Ensure Flutter widgets binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // MultiProvider allows us to provide multiple services (ChangeNotifiers)
    // to the widget tree, making them accessible to any descendant widget.
    MultiProvider(
      providers: [
        // ThemeService provides the app's current theme (light/dark).
        ChangeNotifierProvider(create: (context) => ThemeService()),
        // AuthService manages user authentication (login, logout, create account).
        ChangeNotifierProvider(create: (context) => AuthService()),
        // CartService manages the user's shopping cart.
        ChangeNotifierProvider(create: (context) => CartService()),
      ],
      // The MyApp widget now directly uses MaterialApp and sets SplashScreen as home
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer widget listens to changes in ThemeService.
    // When the theme mode changes (e.g., from light to dark),
    // it rebuilds this part of the widget tree to apply the new theme.
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        // --- Crucial Step for Dynamic AppConstants Colors ---
        // When ThemeMode.system is active, we need to manually update
        // AppConstants._isDarkMode based on the device's actual brightness.
        // This ensures AppConstants' dynamic color getters (like textColor)
        // are always correct, even if the user hasn't explicitly chosen light/dark.
        if (themeService.themeMode == ThemeMode.system) {
          final Brightness platformBrightness =
              MediaQuery.of(context).platformBrightness;
          AppConstants.setDarkMode(platformBrightness == Brightness.dark);
        } else {
          // If theme mode is explicitly light or dark, AppConstants is
          // already updated by ThemeService's _updateAppConstantsTheme.
          // This line ensures consistency in case of direct rebuilds.
          AppConstants.setDarkMode(themeService.themeMode == ThemeMode.dark);
        }
        // -----------------------------------------------------

        return MaterialApp(
          title: 'FoodGo', // Application title
          debugShowCheckedModeBanner: false, // Remove the debug banner

          // This property tells MaterialApp which theme mode to use (system, light, or dark).
          themeMode: themeService.themeMode,

          // This is the theme data for the LIGHT mode.
          theme: themeService.getCurrentTheme(context),
          // This is the theme data for the DARK mode.
          darkTheme: themeService.getCurrentTheme(context),

          // --- IMPORTANT CHANGE: Start with SplashScreen ---
          // The SplashScreen will handle checking auth status and navigating
          // to either HomePage or LoginPage.
          home: const SplashScreen(), // <--- This is the key change
        );
      },
    );
  }
}