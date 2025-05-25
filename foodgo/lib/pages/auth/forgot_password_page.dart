// foodgo_app/lib/pages/auth/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For accessing AuthService

import '../../services/auth_service.dart'; // Our authentication service
import '../../utils/app_constants.dart';   // Global constants for styling

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Function to handle password reset request.
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final String? errorMessage = await authService.resetPassword(_emailController.text.trim());

      setState(() {
        _isLoading = false;
      });

      if (errorMessage == null) {
        // Password reset email sent successfully.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset link sent to ${_emailController.text}. Please check your email.'),
            backgroundColor: AppConstants.successGreen,
            duration: const Duration(seconds: 5),
          ),
        );
        Navigator.of(context).pop(); // Go back to login page
      } else {
        // Show an error message.
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
          'Forgot Password',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          onPressed: () => Navigator.of(context).pop(),
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
                  Icons.lock_reset,
                  size: 100,
                  color: AppConstants.primaryOrange,
                ),
                const SizedBox(height: AppConstants.largeSpacing),
                Text(
                  'Enter your email to receive a password reset link.',
                  style: AppConstants.subtitleStyle.copyWith(
                    color: AppConstants.lightTextColor,
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
                    hintText: 'Enter your registered email',
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
                const SizedBox(height: AppConstants.mediumSpacing),
                _isLoading
                    ? CircularProgressIndicator(color: AppConstants.primaryOrange)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                            backgroundColor: AppConstants.primaryOrange,
                          ),
                          child: Text(
                            'Reset Password',
                            style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.white),
                          ),
                        ),
                      ),
                const SizedBox(height: AppConstants.defaultSpacing),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Remembered your password? Login',
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