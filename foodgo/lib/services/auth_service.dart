// foodgo_app/lib/services/auth_service.dart

import 'package:flutter/material.dart';
import '../models/user.dart'; // Import the new User model

// This is a simple in-memory authentication service.
// In a real app, this would connect to a backend API (e.g., Firebase, your own server).
class AuthService extends ChangeNotifier {
  // A map to simulate user storage.
  // Keys are email addresses, values are maps containing 'password' and 'username'.
  final Map<String, Map<String, String>> _users = {};

  // Stores the currently logged-in user object. Null if no user is logged in.
  User? _currentUser;
  // Getter to publicly access the current user object.
  User? get currentUser => _currentUser;

  // Flag to indicate if an authentication operation is in progress.
  bool _isLoading = false;
  // Getter to publicly access the loading state.
  bool get isLoading => _isLoading;

  // Checks if a user is currently logged in.
  bool get isAuthenticated => _currentUser != null;

  // Constructor: In a real app, you might try to auto-login here
  // by checking persisted tokens. For this mock, it starts unauthenticated.
  AuthService() {
    // Simulate initial loading if you were checking for persisted session
    // _setLoading(true);
    // Future.delayed(Duration(seconds: 1), () {
    //   _setLoading(false);
    //   // Check for persisted user here
    // });
  }

  // Helper to set loading state and notify listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --- User Registration ---
  // Attempts to create a new user account.
  // Returns a success message or an error message.
  Future<String?> createUser({
    required String email,
    required String username,
    required String password,
  }) async {
    _setLoading(true); // Set loading true
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call delay.

    // Basic validation: Check if email, username, or password are empty.
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      _setLoading(false);
      return 'Email, username, and password cannot be empty.';
    }

    // Check if the email already exists in our mock database.
    if (_users.containsKey(email)) {
      _setLoading(false);
      return 'Account with this email already exists.';
    }

    // Check if the username already exists (optional, but good for uniqueness).
    if (_users.values.any((user) => user['username'] == username)) {
      _setLoading(false);
      return 'This username is already taken.';
    }

    // Simulate successful user creation.
    _users[email] = {'password': password, 'username': username}; // Store username
    print('User created: $email, Username: $username'); // For debugging

    // --- IMPORTANT CHANGE: REMOVED AUTOMATIC LOGIN HERE ---
    // _currentUser = User(email: email, username: username); // This line was removed
    // The user will now be redirected to the login page to explicitly log in.

    _setLoading(false); // Set loading false
    return null; // No error, creation successful.
  }

  // --- User Login ---
  // Attempts to log in a user with provided credentials.
  // Returns a success message or an error message.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true); // Set loading true
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call delay.

    // Basic validation: Check if email or password are empty.
    if (email.isEmpty || password.isEmpty) {
      _setLoading(false);
      return 'Email and password cannot be empty.';
    }

    // Check if the email exists in our mock database.
    if (!_users.containsKey(email)) {
      _setLoading(false);
      return 'No account found with this email.';
    }

    // Verify the password.
    if (_users[email]?['password'] != password) {
      _setLoading(false);
      return 'Incorrect password.';
    }

    // Simulate successful login.
    _currentUser = User(email: email, username: _users[email]!['username']!); // Set currentUser
    print('User logged in: $email, Username: ${_currentUser!.username}'); // For debugging
    _setLoading(false); // Set loading false
    return null; // No error, login successful.
  }

  // --- User Logout ---
  // Logs out the current user.
  Future<void> logout() async {
    _setLoading(true); // Set loading true
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call delay.

    _currentUser = null; // Clear the current user.
    print('User logged out.'); // For debugging
    _setLoading(false); // Set loading false
  }

  // --- Password Reset (Mock) ---
  Future<String?> resetPassword(String email) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (_users.containsKey(email)) {
      print('Password reset link sent to $email (mock)');
      _setLoading(false);
      return null; // Success
    } else {
      _setLoading(false);
      return 'No account found with this email address.';
    }
  }
}