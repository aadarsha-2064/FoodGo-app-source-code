// foodgo_app/lib/widgets/dish_card.dart

import 'package:flutter/material.dart';
import '../models/dish.dart'; // Import the Dish model
import '../utils/app_constants.dart'; // Import AppConstants for consistent styling

// A custom widget to display a single dish's information in a card format.
class DishCard extends StatelessWidget {
  final Dish dish; // The dish data to display
  final VoidCallback onTap; // Callback for when the card is tapped (for entire card tap)
  final VoidCallback? onBuyNowTap; // NEW: Callback for when the "Buy Now" button is tapped

  // Constructor requires a Dish object and an onTap function.
  const DishCard({
    super.key,
    required this.dish,
    required this.onTap,
    this.onBuyNowTap, // Make this optional
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap gestures to navigate to dish details (for the whole card)
      child: Card(
        color: AppConstants.cardColor, // Use card background color from constants
        elevation: 0.5, // Subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius), // Rounded corners
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.smallSpacing / 2),
        // Use IntrinsicHeight to try and make the card's height fit its children
        // This can sometimes help with overflows when content has specific height requirements.
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Dish Image ---
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.borderRadius)), // Clip top corners
                child: Image.asset(
                  dish.imageUrl,
                  height: 120, // Fixed height for consistency
                  width: double.infinity, // Take full width
                  fit: BoxFit.cover, // Cover the area without distortion
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for image loading errors
                    return Container(
                      height: 120,
                      color: AppConstants.lightGrey,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppConstants.grey,
                          size: AppConstants.largeSpacing,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // --- Dish Info ---
              // Removed Expanded here. Let the Column within the Padding manage space.
              Padding(
                padding: const EdgeInsets.all(AppConstants.smallSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment.spaceBetween would also need Expanded children to work fully,
                  // so let's simplify to start and ensure space with SizedBoxes.
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // TOP SECTION: Dish Name and Description
                    Text(
                      dish.name,
                      style: AppConstants.titleStyle.copyWith(
                        fontSize: 16,
                        color: AppConstants.textColor, // Ensure color is set from constants
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0), // Minimal spacing

                    // Dish Description (shortened)
                    Text(
                      dish.description,
                      style: AppConstants.bodyTextStyle.copyWith(
                        color: AppConstants.lightTextColor, // Lighter text for description
                      ),
                      maxLines: 2, // Allow up to two lines
                      overflow: TextOverflow.ellipsis, // Truncate if too long
                    ),

                    // Add Spacer to push remaining content down, IF this Column itself
                    // is inside an Expanded or flexible parent.
                    // Given the IntrinsicHeight on the parent Column, Spacers aren't as effective here for "pushing"
                    // but explicit SizedBox for vertical spacing is still needed.
                    const SizedBox(height: AppConstants.smallSpacing), // Space before price/icons

                    // Price and (optional) Vegetarian/Spicy indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '\$${dish.price.toStringAsFixed(2)}', // Format price
                          style: AppConstants.priceStyle, // Use price specific style
                        ),
                        // Vegetarian/Spicy Indicators
                        Row(
                          children: [
                            if (dish.isVegetarian)
                              Icon(Icons.eco,
                                  color: AppConstants.successGreen,
                                  size: AppConstants.iconSize * 0.8),
                            if (dish.isVegetarian) SizedBox(width: AppConstants.extraSmallSpacing / 2),
                            if (dish.isSpicy)
                              Icon(Icons.local_fire_department,
                                  color: AppConstants.errorRed,
                                  size: AppConstants.iconSize * 0.8),
                            if (dish.isSpicy) SizedBox(width: AppConstants.extraSmallSpacing / 2),
                          ],
                        ),
                      ],
                    ),

                    // Spacing between price/icons and Buy Now button
                    const SizedBox(height: AppConstants.smallSpacing), // Adjusted spacing

                    // NEW: Buy Now Button
                    // Use Align to ensure the button takes available width if it's not the primary child
                    // and then constrain its height.
                    Align(
                      alignment: Alignment.bottomCenter, // Align button to bottom within available space
                      child: SizedBox(
                        width: double.infinity, // Make the button take full available width
                        height: AppConstants.buttonHeight * 0.8, // Slightly smaller button height
                        child: ElevatedButton(
                          onPressed: onBuyNowTap, // Use the new callback
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryOrange, // Use app's primary color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Buy Now',
                            style: AppConstants.buttonTextStyle.copyWith(
                              color: AppConstants.white, // Ensure white text on orange button
                              fontSize: 14, // Adjust button text size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}