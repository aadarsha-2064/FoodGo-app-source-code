// foodgo_app/lib/pages/order_tracking_page.dart

import 'package:flutter/material.dart';
import '../utils/app_constants.dart'; // Global constants for styling
import 'home_page.dart';             // Navigate back to home
import 'user/user_dashboard_page.dart'; // Potentially navigate to order history

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  // Mock order status steps
  final List<String> _orderSteps = [
    'Order Confirmed',
    'Preparing Your Order',
    'Order Picked Up',
    'On the Way',
    'Delivered!',
  ];

  // Current mock step (can be updated by a timer or API in a real app)
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // Simulate order progress over time (for demonstration)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _currentStep = 1);
    });
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) setState(() => _currentStep = 2);
    });
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) setState(() => _currentStep = 3);
    });
    Future.delayed(const Duration(seconds: 18), () {
      if (mounted) setState(() => _currentStep = 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Track Your Order',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppConstants.textColor),
          onPressed: () {
            // Close tracking and go back to home or user dashboard
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Order ID and Estimated Delivery ---
            Center(
              child: Column(
                children: [
                  Text(
                    'Order #XYZ12345', // Mock Order ID
                    style: AppConstants.headlineStyle.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  Text(
                    'Estimated Delivery: 25-35 min', // Mock delivery time
                    style: AppConstants.subtitleStyle.copyWith(color: AppConstants.lightTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.largeSpacing),

            // --- Tracking Timeline ---
            Card(
              color: AppConstants.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultSpacing),
                child: Column(
                  children: List.generate(_orderSteps.length, (index) {
                    bool isActive = index <= _currentStep;
                    bool isLast = index == _orderSteps.length - 1;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isActive ? AppConstants.successGreen : AppConstants.lightGrey,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isActive ? Icons.check : Icons.circle_outlined,
                                color: isActive ? Colors.white : AppConstants.grey,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: AppConstants.defaultSpacing),
                            Text(
                              _orderSteps[index],
                              style: AppConstants.bodyTextStyle.copyWith(
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                color: isActive ? AppConstants.textColor : AppConstants.lightTextColor,
                              ),
                            ),
                          ],
                        ),
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0), // Align with vertical line
                            child: SizedBox(
                              height: AppConstants.defaultSpacing,
                              child: VerticalDivider(
                                color: isActive ? AppConstants.successGreen : AppConstants.lightGrey,
                                thickness: 2,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.largeSpacing),

            // --- Action Buttons ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone, color: Colors.white),
                label: Text(
                  'Contact Support',
                  style: AppConstants.buttonTextStyle.copyWith(color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling FoodGo support...'),
                      backgroundColor: AppConstants.primaryOrange,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // TODO: Implement actual phone call or chat support
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(Icons.refresh, color: AppConstants.primaryOrange),
                label: Text(
                  'Reorder Same Items',
                  style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.primaryOrange),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reordering functionality coming soon!'),
                      backgroundColor: AppConstants.warningYellow,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // TODO: Implement reorder logic
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppConstants.primaryOrange, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.extraLargeSpacing),
          ],
        ),
      ),
    );
  }
}