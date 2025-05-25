// foodgo_app/lib/pages/dish_detail_page.dart

import 'package:flutter/material.dart';
import '../models/dish.dart'; // Import the Dish model
import '../utils/app_constants.dart'; // Global constants for styling
// import '../services/cart_service.dart'; // Will be used later for cart functionality
// import 'package:provider/provider.dart'; // Will be used later for accessing CartService

class DishDetailPage extends StatefulWidget {
  final Dish dish; // The dish object passed to this page

  const DishDetailPage({super.key, required this.dish});

  @override
  State<DishDetailPage> createState() => _DishDetailPageState();
}

class _DishDetailPageState extends State<DishDetailPage> {
  int _quantity = 1; // State to manage the quantity of the dish to add

  // Function to increment the quantity
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Function to decrement the quantity, minimum is 1
  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  // Function to handle adding the dish to cart
  void _addToCart() {
    // TODO: Implement actual cart logic using CartService
    // For now, just show a confirmation SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_quantity}x ${widget.dish.name} added to cart!'),
        backgroundColor: AppConstants.successGreen, // Use success color
        duration: const Duration(seconds: 2),
      ),
    );
    // In a real app, you'd do something like:
    // Provider.of<CartService>(context, listen: false).addItem(widget.dish, _quantity);
    // Navigator.of(context).pop(); // Go back after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor, // Use app background color
      body: CustomScrollView(
        slivers: [
          // --- Custom AppBar with Dish Image ---
          SliverAppBar(
            expandedHeight: 280.0, // Height when fully expanded
            floating: false, // AppBar stays at the top
            pinned: true, // AppBar remains visible after scrolling
            backgroundColor: AppConstants.backgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.dish.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppConstants.lightGrey,
                    child: Center(
                      child: Icon(Icons.broken_image, color: AppConstants.grey, size: AppConstants.largeSpacing),
                    ),
                  );
                },
              ),
              title: Text(
                widget.dish.name,
                style: AppConstants.titleStyle.copyWith(color: AppConstants.white, shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2.0, 2.0),
                  ),
                ]), // White title with shadow on image
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: AppConstants.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Dish Name and Price ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.dish.name,
                          style: AppConstants.headlineStyle, // Larger font for dish name
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${widget.dish.price.toStringAsFixed(2)}', // Formatted price
                        style: AppConstants.priceStyle, // Specific style for price
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultSpacing),

                  // --- Dish Description ---
                  Text(
                    widget.dish.description,
                    style: AppConstants.bodyTextStyle.copyWith(color: AppConstants.lightTextColor),
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- Dietary Information (Vegetarian, Spicy) ---
                  Row(
                    children: [
                      if (widget.dish.isVegetarian) ...[
                        Icon(Icons.eco, color: AppConstants.successGreen, size: AppConstants.defaultSpacing),
                        const SizedBox(width: AppConstants.smallSpacing / 2),
                        Text('Vegetarian', style: AppConstants.captionStyle),
                        const SizedBox(width: AppConstants.defaultSpacing),
                      ],
                      if (widget.dish.isSpicy) ...[
                        Icon(Icons.local_fire_department, color: AppConstants.errorRed, size: AppConstants.defaultSpacing),
                        const SizedBox(width: AppConstants.smallSpacing / 2),
                        Text('Spicy', style: AppConstants.captionStyle),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  Divider(color: AppConstants.dividerColor),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- Ingredients List ---
                  Text(
                    'Ingredients',
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultSpacing),
                  // Display ingredients as a comma-separated list
                  Text(
                    widget.dish.ingredients.join(', '),
                    style: AppConstants.bodyTextStyle,
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  Divider(color: AppConstants.dividerColor),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- Quantity Selector ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: AppConstants.primaryOrange, size: 32),
                        onPressed: _decrementQuantity,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultSpacing),
                        child: Text(
                          '$_quantity',
                          style: AppConstants.headlineStyle.copyWith(fontSize: 28),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: AppConstants.primaryOrange, size: 32),
                        onPressed: _incrementQuantity,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),

                  // --- Add to Cart Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(
                        'Add to Cart - \$${(widget.dish.price * _quantity).toStringAsFixed(2)}', // Total price
                        style: AppConstants.buttonTextStyle.copyWith(color: AppConstants.white),
                      ),
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryOrange, // Use primary brand color
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
          ),
        ],
      ),
    );
  }
}