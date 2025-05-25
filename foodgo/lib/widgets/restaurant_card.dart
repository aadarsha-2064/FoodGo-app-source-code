// foodgo_app/lib/widgets/restaurant_card.dart

import 'package:flutter/material.dart';
import '../models/restaurant.dart'; // Import the Restaurant model
import '../utils/app_constants.dart'; // Import AppConstants for consistent styling

// A custom widget to display a single restaurant's information in a card format.
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant; // The restaurant data to display
  final VoidCallback onTap; // Callback for when the card is tapped

  // Constructor requires a Restaurant object and an onTap function.
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap gestures to navigate to restaurant details
      child: Card(
        // Use colors from AppConstants for theme consistency
        color: AppConstants.cardColor,
        elevation: AppConstants.smallSpacing / 8, // Subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius), // Rounded corners
        ),
        margin: const EdgeInsets.symmetric(
            vertical: AppConstants.smallSpacing,
            horizontal: AppConstants.defaultSpacing), // Margin around each card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Restaurant Image ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.borderRadius)), // Clip top corners
              child: Image.asset(
                restaurant.imageUrl,
                height: 150, // Fixed height for consistency
                width: double.infinity, // Take full width
                fit: BoxFit.cover, // Cover the area without distortion
                errorBuilder: (context, error, stackTrace) {
                  // Fallback for image loading errors
                  return Container(
                    height: 150,
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
            // --- Restaurant Info ---
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant.name,
                    style: AppConstants.titleStyle.copyWith(
                        fontSize: 18), // Slightly smaller title for card
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.smallSpacing / 2),
                  // Cuisine Type
                  Text(
                    restaurant.cuisine,
                    style: AppConstants.subtitleStyle.copyWith(
                        color: AppConstants.lightTextColor), // Lighter text for subtitle
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  // Rating and Delivery Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: AppConstants.primaryYellow,
                              size: AppConstants.defaultSpacing), // Star icon
                          const SizedBox(width: AppConstants.smallSpacing / 4),
                          Text(
                            '${restaurant.rating} (${restaurant.totalRatings})',
                            style: AppConstants.bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w500), // Rating text
                          ),
                        ],
                      ),
                      // Estimated Delivery Time
                      Row(
                        children: [
                          Icon(Icons.delivery_dining,
                              color: AppConstants.textColor,
                              size: AppConstants.defaultSpacing), // Delivery icon
                          const SizedBox(width: AppConstants.smallSpacing / 4),
                          Text(
                            restaurant.estimatedDeliveryTime,
                            style: AppConstants.bodyTextStyle, // Delivery time text
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  // Delivery Fee
                  Row(
                    children: [
                      Icon(Icons.motorcycle,
                          color: AppConstants.textColor,
                          size: AppConstants.defaultSpacing), // Motorcycle icon for delivery fee
                      const SizedBox(width: AppConstants.smallSpacing / 4),
                      Text(
                        'Delivery Fee: \$${restaurant.deliveryFee.toStringAsFixed(2)}',
                        style: AppConstants.bodyTextStyle, // Delivery fee text
                      ),
                    ],
                  ),
                  // Optional: Display "Closed" or "Min Order" if applicable
                  if (!restaurant.isOpen) ...[
                    const SizedBox(height: AppConstants.smallSpacing),
                    Text(
                      'Closed',
                      style: AppConstants.bodyTextStyle
                          .copyWith(color: AppConstants.errorRed, fontWeight: FontWeight.bold),
                    ),
                  ] else if (restaurant.minOrderValue > 0) ...[
                    const SizedBox(height: AppConstants.smallSpacing),
                    Text(
                      'Min. Order: \$${restaurant.minOrderValue.toStringAsFixed(2)}',
                      style: AppConstants.bodyTextStyle.copyWith(color: AppConstants.lightTextColor),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}