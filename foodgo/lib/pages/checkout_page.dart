// foodgo_app/lib/pages/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For accessing CartService

import '../services/cart_service.dart'; // Our cart management service
import '../utils/app_constants.dart';   // Global constants for styling
import 'order_tracking_page.dart';     // To navigate after placing order (next up!)
import 'home_page.dart';               // Navigate back to home if cart is empty

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  // Mock delivery fee for demonstration
  final double _deliveryFee = 5.00;

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    // If the cart is empty, navigate back to home page or show a message
    if (cartService.items.isEmpty) {
      // You could also show a message and a button to go to home/browse restaurants
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your cart is empty. Please add items to proceed.'),
            backgroundColor: AppConstants.warningYellow,
            duration: const Duration(seconds: 3),
          ),
        );
      });
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: const Center(child: CircularProgressIndicator()), // Or a more elaborate empty state
      );
    }

    double subtotal = cartService.cartTotal;
    double total = subtotal + _deliveryFee; // Calculate total including delivery fee

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Delivery Address Section ---
            Text(
              'Delivery Address',
              style: AppConstants.titleStyle,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Card(
              color: AppConstants.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: ListTile(
                leading: Icon(Icons.location_on, color: AppConstants.primaryOrange),
                title: Text(
                  '123 Food Street, Delicious City', // Mock Address
                  style: AppConstants.bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Apt 4B, Near FoodGo HQ',
                  style: AppConstants.captionStyle.copyWith(color: AppConstants.lightTextColor),
                ),
                trailing: TextButton(
                  onPressed: () {
                    // TODO: Navigate to Address selection page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Address selection coming soon!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'Change',
                    style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.primaryOrange),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),

            // --- Payment Method Section ---
            Text(
              'Payment Method',
              style: AppConstants.titleStyle,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Card(
              color: AppConstants.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: ListTile(
                leading: Icon(Icons.credit_card, color: AppConstants.primaryOrange),
                title: Text(
                  '**** **** **** 1234', // Mock Payment Method
                  style: AppConstants.bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Visa',
                  style: AppConstants.captionStyle.copyWith(color: AppConstants.lightTextColor),
                ),
                trailing: TextButton(
                  onPressed: () {
                    // TODO: Navigate to Payment Method selection page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment method selection coming soon!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'Change',
                    style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.primaryOrange),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),

            // --- Order Summary Section ---
            Text(
              'Order Summary',
              style: AppConstants.titleStyle,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Card(
              color: AppConstants.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultSpacing),
                child: Column(
                  children: [
                    // List of items
                    ...cartService.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppConstants.smallSpacing / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${item.dish.name}',
                                  style: AppConstants.bodyTextStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: AppConstants.bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )).toList(),
                    const SizedBox(height: AppConstants.defaultSpacing),
                    Divider(color: AppConstants.dividerColor),
                    const SizedBox(height: AppConstants.defaultSpacing),
                    // Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: AppConstants.bodyTextStyle),
                        Text('\$${subtotal.toStringAsFixed(2)}', style: AppConstants.bodyTextStyle),
                      ],
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    // Delivery Fee
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee', style: AppConstants.bodyTextStyle),
                        Text('\$${_deliveryFee.toStringAsFixed(2)}', style: AppConstants.bodyTextStyle),
                      ],
                    ),
                    const SizedBox(height: AppConstants.defaultSpacing),
                    Divider(color: AppConstants.dividerColor),
                    const SizedBox(height: AppConstants.defaultSpacing),
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppConstants.headlineStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: AppConstants.priceStyle, // Use price style for total
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),

            // --- Place Order Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement actual order placement logic (API call, clear cart etc.)
                  // For now, clear cart and navigate to order tracking
                  cartService.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order placed successfully! Total: \$${total.toStringAsFixed(2)}'),
                      backgroundColor: AppConstants.successGreen,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  // Navigate to Order Tracking Page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const OrderTrackingPage()),
                    (Route<dynamic> route) => false, // Remove all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultSpacing),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                child: Text(
                  'Place Order',
                  style: AppConstants.buttonTextStyle.copyWith(color: Colors.white),
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