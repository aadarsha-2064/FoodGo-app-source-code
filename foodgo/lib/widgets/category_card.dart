// foodgo_app/lib/widgets/category_card.dart

import 'package:flutter/material.dart';
import '../utils/app_constants.dart'; // Import your AppConstants

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Fixed width for each category card
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.smallSpacing),
        decoration: BoxDecoration(
          color: AppConstants.cardColor, // Dynamic card background
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppConstants.isDarkMode // Dynamic shadow color based on theme
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              size: AppConstants.iconSize + 4, // Slightly larger icon for categories
              color: AppConstants.primaryOrange, // Use primary color for icons
            ),
            const SizedBox(height: AppConstants.smallSpacing / 2),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: AppConstants.bodyTextStyle.copyWith(
                color: AppConstants.textColor, // Dynamic text color
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}