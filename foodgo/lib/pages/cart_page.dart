// foodgo_app/lib/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For accessing CartService

import '../services/cart_service.dart'; // Our cart management service
import '../utils/app_constants.dart';   // Global constants for styling
import '../widgets/dish_card.dart';     // Reusing DishCard for cart items

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CartService provided by Provider.
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor, // Use app background color
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor, // Match background
        elevation: 0, // No shadow for a flat look
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          onPressed: () => Navigator.of(context).pop(), // Go back
        ),
      ),
      body: cartService.items.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty.',
                style: AppConstants.subtitleStyle.copyWith(color: AppConstants.lightTextColor),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartService.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartService.items[index];
                      return Dismissible(
                        key: Key(cartItem.dish.id), // Unique key for Dismissible
                        direction: DismissDirection.endToStart, // Swipe from right to left
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: AppConstants.errorRed,
                          padding: const EdgeInsets.only(right: AppConstants.defaultSpacing),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          // Remove the item from the cart
                          cartService.removeItem(cartItem.dish);
                          // Show a snackbar to confirm removal
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${cartItem.dish.name} removed from cart.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Padding(
                          padding: AppConstants.screenPadding,
                          child: Row(
                            children: [
                              // --- Dish Image (using DishCard for consistency) ---
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: DishCard(
                                  dish: cartItem.dish,
                                  onTap: () {
                                    // TODO: Navigate to DishDetailPage if needed
                                  },
                                ),
                              ),
                              const SizedBox(width: AppConstants.defaultSpacing),

                              // --- Dish Details and Quantity ---
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.dish.name,
                                      style: AppConstants.titleStyle.copyWith(fontSize: 18),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppConstants.smallSpacing / 2),
                                    Text(
                                      '\$${cartItem.dish.price.toStringAsFixed(2)}',
                                      style: AppConstants.priceStyle,
                                    ),
                                    const SizedBox(height: AppConstants.smallSpacing),
                                    // --- Quantity Adjuster ---
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            // Decrease quantity, remove if it becomes 0
                                            if (cartItem.quantity > 1) {
                                              cartService.updateItemQuantity(cartItem.dish, cartItem.quantity - 1);
                                            }
                                          },
                                        ),
                                        Text(
                                          cartItem.quantity.toString(),
                                          style: AppConstants.bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                            // Increase quantity
                                            cartService.updateItemQuantity(cartItem.dish, cartItem.quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // --- Total Price for this item ---
                              Padding(
                                padding: const EdgeInsets.only(left: AppConstants.defaultSpacing),
                                child: Text(
                                  '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                                  style: AppConstants.priceStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // --- Cart Total and Checkout Button ---
                Padding(
                  padding: AppConstants.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(color: AppConstants.dividerColor),
                      const SizedBox(height: AppConstants.defaultSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cart Total:',
                            style: AppConstants.titleStyle,
                          ),
                          Text(
                            '\$${cartService.cartTotal.toStringAsFixed(2)}',
                            style: AppConstants.priceStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.defaultSpacing),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement Checkout Page navigation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout functionality coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
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
                          'Proceed to Checkout',
                          style: AppConstants.buttonTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: AppConstants.extraLargeSpacing), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}