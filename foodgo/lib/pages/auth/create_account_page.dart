// foodgo_app/lib/pages/auth/create_account_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For accessing AuthService

import '../../services/auth_service.dart'; // Our authentication service
import '../../utils/app_constants.dart';  // Global constants for styling
import 'login_page.dart'; // Import the login page for redirection

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);

      final String? errorMessage = await authService.createUser(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully! Please log in.'),
            backgroundColor: AppConstants.successGreen,
            duration: const Duration(seconds: 3),
          ),
        );
        // Correctly navigates to LoginPage and replaces the current route
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppConstants.errorRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Your FoodGo Account',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          // MODIFICATION: Explicitly navigate to LoginPage when back button is pressed
          // This ensures that even if CreateAccountPage was pushed from another screen,
          // hitting back will take you to LoginPage.
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 100,
                  color: AppConstants.primaryOrange,
                ),
                const SizedBox(height: AppConstants.largeSpacing),
                Text(
                  'Join FoodGo for delicious food!',
                  style: AppConstants.headlineStyle.copyWith(
                    fontSize: 24,
                    color: AppConstants.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.mediumSpacing),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppConstants.bodyTextStyle,
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
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  style: AppConstants.bodyTextStyle,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a username',
                    prefixIcon: Icon(Icons.person, color: AppConstants.lightTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppConstants.bodyTextStyle,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, color: AppConstants.lightTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: AppConstants.bodyTextStyle,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icon(Icons.lock_reset, color: AppConstants.lightTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.mediumSpacing),
                _isLoading
                    ? CircularProgressIndicator(color: AppConstants.primaryOrange)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _createAccount,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                            backgroundColor: AppConstants.primaryOrange,
                          ),
                          child: Text(
                            'Create Account',
                            style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.white),
                          ),
                        ),
                      ),
                const SizedBox(height: AppConstants.defaultSpacing),
                TextButton(
                  onPressed: () {
                    // This explicitly navigates to the LoginPage and replaces the current route,
                    // preventing going back to CreateAccountPage from LoginPage.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: AppConstants.bodyTextStyle.copyWith(
                      color: AppConstants.primaryOrange,
                      decoration: TextDecoration.underline,
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