// foodgo_app/lib/pages/auth/login_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For accessing AuthService

import '../../services/auth_service.dart';    // Our authentication service
import '../../utils/app_constants.dart';      // Global constants for styling
import '../home_page.dart';                   // Navigate to home after successful login
import 'create_account_page.dart';            // Navigate to create account page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers for capturing user input (email and password).
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey for the form, used for validation.
  final _formKey = GlobalKey<FormState>();

  // State variable to show loading indicator during API calls.
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks when the widget is removed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle the login process.
  Future<void> _login() async {
    // Validate the form fields first.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Access the AuthService instance provided by MultiProvider.
      final authService = Provider.of<AuthService>(context, listen: false);

      // Attempt to log in the user.
      final String? errorMessage = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (errorMessage == null) {
        // Login successful.
        // Navigate to the HomePage and remove all previous routes from the stack.
        // This prevents the user from going back to the login page using the back button.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Show an error message using a SnackBar if login fails.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppConstants.errorRed, // Use our predefined error color
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor, // Use background color from constants
      body: Center(
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding, // Apply consistent screen padding
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // FoodGo Logo/Icon
                Icon(
                  Icons.fastfood, // A suitable food-related icon
                  size: 100,
                  color: AppConstants.primaryOrange, // Use primary brand color
                ),
                const SizedBox(height: AppConstants.largeSpacing),

                // Welcome Message
                Text(
                  'Welcome to FoodGo!',
                  style: AppConstants.headlineStyle.copyWith(
                    fontSize: 28, // Slightly larger for a welcome message
                    color: AppConstants.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.smallSpacing),
                Text(
                  'Sign in to order your favorite dishes.',
                  style: AppConstants.subtitleStyle.copyWith(
                    color: AppConstants.lightTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.mediumSpacing),

                // --- Email Input Field ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppConstants.bodyTextStyle, // Apply text style
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email, color: AppConstants.lightTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.defaultSpacing),

                // --- Password Input Field ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide password input
                  style: AppConstants.bodyTextStyle, // Apply text style
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, color: AppConstants.lightTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.smallSpacing),

                // --- Forgot Password Button ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement Forgot Password page navigation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Forgot Password functionality coming soon!'),
                          backgroundColor: AppConstants.warningYellow,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppConstants.bodyTextStyle.copyWith(
                        color: AppConstants.primaryOrange, // Use brand color for link
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.defaultSpacing),

                // --- Login Button ---
                _isLoading
                    ? CircularProgressIndicator(color: AppConstants.primaryOrange) // Show loading spinner
                    : SizedBox(
                        width: double.infinity, // Make button take full width
                        child: ElevatedButton(
                          onPressed: _login, // Call the login function
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                            backgroundColor: AppConstants.primaryOrange, // Use primary orange from constants
                          ),
                          child: Text(
                            'Login',
                            style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.white), // White text for contrast
                          ),
                        ),
                      ),
                const SizedBox(height: AppConstants.mediumSpacing),

                // --- Divider for "Or" ---
                Row(
                  children: [
                    Expanded(child: Divider(color: AppConstants.dividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallSpacing),
                      child: Text(
                        'OR',
                        style: AppConstants.captionStyle.copyWith(color: AppConstants.lightTextColor),
                      ),
                    ),
                    Expanded(child: Divider(color: AppConstants.dividerColor)),
                  ],
                ),
                const SizedBox(height: AppConstants.mediumSpacing),

                // --- Create Account Button ---
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to the CreateAccountPage.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                      side: BorderSide(color: AppConstants.primaryOrange, width: 2), // Orange border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                    ),
                    child: Text(
                      'Create a New Account',
                      style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.primaryOrange), // Orange text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}