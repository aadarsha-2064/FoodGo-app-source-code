// foodgo_app/lib/pages/user/user_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For accessing AuthService

import '../../services/auth_service.dart'; // Our authentication service
import '../../utils/app_constants.dart';   // Global constants for styling
import '../auth/login_page.dart';          // Navigate to login after logout

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthService to get current user data and perform logout.
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser; // Get the currently logged-in user

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor, // Use app background color
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor, // Match background
        elevation: 0, // No shadow for a flat look
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          onPressed: () => Navigator.of(context).pop(), // Go back
        ),
      ),
      body: user == null
          ? Center(
              child: Text(
                'Please log in to view your profile.',
                style: AppConstants.subtitleStyle.copyWith(color: AppConstants.lightTextColor),
              ),
            )
          : SingleChildScrollView(
              padding: AppConstants.screenPadding, // Apply consistent padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- User Profile Picture Placeholder ---
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppConstants.primaryOrange.withOpacity(0.2),
                    child: Icon(
                      Icons.person_rounded,
                      size: 70,
                      color: AppConstants.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- User Name ---
                  Text(
                    user.username, // Display the username
                    style: AppConstants.headlineStyle.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: AppConstants.smallSpacing / 2),

                  // --- User Email ---
                  Text(
                    user.email, // Display the user's email
                    style: AppConstants.bodyTextStyle.copyWith(color: AppConstants.lightTextColor),
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),

                  Divider(color: AppConstants.dividerColor),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- Account Options List ---
                  // Edit Profile
                  ListTile(
                    leading: Icon(Icons.edit, color: AppConstants.textColor),
                    title: Text('Edit Profile', style: AppConstants.bodyTextStyle),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppConstants.lightTextColor),
                    onTap: () {
                      // TODO: Implement Edit Profile Page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Edit Profile coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(color: AppConstants.dividerColor, indent: AppConstants.defaultSpacing, endIndent: AppConstants.defaultSpacing),
                  // Order History
                  ListTile(
                    leading: Icon(Icons.history, color: AppConstants.textColor),
                    title: Text('Order History', style: AppConstants.bodyTextStyle),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppConstants.lightTextColor),
                    onTap: () {
                      // TODO: Implement Order History Page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order History coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(color: AppConstants.dividerColor, indent: AppConstants.defaultSpacing, endIndent: AppConstants.defaultSpacing),
                  // Payment Methods
                  ListTile(
                    leading: Icon(Icons.payment, color: AppConstants.textColor),
                    title: Text('Payment Methods', style: AppConstants.bodyTextStyle),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppConstants.lightTextColor),
                    onTap: () {
                      // TODO: Implement Payment Methods Page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Payment Methods coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(color: AppConstants.dividerColor, indent: AppConstants.defaultSpacing, endIndent: AppConstants.defaultSpacing),
                  // Addresses
                  ListTile(
                    leading: Icon(Icons.location_on, color: AppConstants.textColor),
                    title: Text('Addresses', style: AppConstants.bodyTextStyle),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppConstants.lightTextColor),
                    onTap: () {
                      // TODO: Implement Addresses Page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Addresses management coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(color: AppConstants.dividerColor, indent: AppConstants.defaultSpacing, endIndent: AppConstants.defaultSpacing),
                  // Settings
                  ListTile(
                    leading: Icon(Icons.settings, color: AppConstants.textColor),
                    title: Text('Settings', style: AppConstants.bodyTextStyle),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppConstants.lightTextColor),
                    onTap: () {
                      // TODO: Implement Settings Page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('App Settings coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(color: AppConstants.dividerColor),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- Logout Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: AppConstants.buttonTextStyle.copyWith(color: Colors.white),
                      ),
                      onPressed: () async {
                        await authService.logout(); // Perform logout
                        // Navigate back to the login page and remove all previous routes
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.errorRed, // Red for logout
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.extraLargeSpacing), // Bottom padding
                ],
              ),
            ),
    );
  }
}