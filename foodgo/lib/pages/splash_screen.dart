// foodgo_app/lib/pages/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/app_constants.dart';
import 'home_page.dart';
import 'auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); // Call this method when the screen initializes
  }

  Future<void> _checkAuthStatus() async {
    // Simulate some loading time for the splash screen
    await Future.delayed(const Duration(seconds: 2)); // Show splash screen for 2 seconds

    // Access the AuthService
    final authService = Provider.of<AuthService>(context, listen: false);

    // After the delay, check if a user is authenticated
    if (authService.isAuthenticated) {
      // If authenticated, navigate to the HomePage and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      // If not authenticated, navigate to the LoginPage and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryOrange, // Use your primary brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delivery_dining, // Or any other suitable app icon
              size: 150,
              color: AppConstants.white, // Icon color for contrast
            ),
            const SizedBox(height: AppConstants.largeSpacing),
            Text(
              'FoodGo',
              style: AppConstants.headlineStyle.copyWith(
                fontSize: 48,
                color: AppConstants.white, // Text color for contrast
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.white), // Loading indicator color
            ),
          ],
        ),
      ),
    );
  }
}