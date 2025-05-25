import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_constants.dart';
import '../services/auth_service.dart';
import '../data/app_data.dart';

import '../widgets/restaurant_card.dart';
import '../widgets/category_card.dart';

import 'auth/login_page.dart';
import 'restaurant_detail_page.dart';
import 'cart_page.dart';
import 'user/user_dashboard_page.dart';
import '../delegates/food_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Map of food categories to their respective icons
  final Map<String, IconData> _categoryIcons = {
    'Indian': Icons.fastfood,
    'Italian': Icons.local_pizza,
    'Japanese': Icons.ramen_dining,
    'American': Icons.lunch_dining,
    'Nepali': Icons.dinner_dining,
    'Chinese': Icons.bakery_dining,
    'Vegan': Icons.eco,
    'Dessert': Icons.cake,
    'Main Course': Icons.restaurant_menu,
    'Breads': Icons.local_dining,
    'Pasta': Icons.ramen_dining,
    'Pizza': Icons.local_pizza,
    'Sushi': Icons.set_meal,
    'Sushi Rolls': Icons.set_meal,
    'Burgers': Icons.fastfood,
    'Sides': Icons.tapas,
    'Appetizers': Icons.fastfood,
    'Noodles': Icons.ramen_dining,
    'Rice': Icons.rice_bowl,
    'Salads': Icons.restaurant_menu,
    'Cakes': Icons.cake,
    'Cheesecakes': Icons.bakery_dining,
  };

  // Helper method to get icon for a category or fallback to a default icon
  IconData _getCategoryIcon(String category) {
    return _categoryIcons[category] ?? Icons.restaurant_menu;
  }

  @override
  Widget build(BuildContext context) {
    // Access AuthService instance via Provider
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,

      // AppBar with location info, search, cart and user icons
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leadingWidth: 0, // Remove default leading space
        titleSpacing: 0,

        // Title shows current delivery location with dropdown icon
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deliver to',
                style: AppConstants.captionStyle.copyWith(
                  color: AppConstants.lightTextColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Current Location',
                    style: AppConstants.subtitleStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textColor,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: AppConstants.primaryOrange),
                ],
              ),
            ],
          ),
        ),

        // Actions: search, cart, user profile buttons
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppConstants.textColor, size: 28),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FoodSearchDelegate(
                  restaurants: appRestaurantData,
                  dishes: appDishData,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: AppConstants.textColor, size: 28),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: AppConstants.textColor, size: 28),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserDashboardPage()),
              );
            },
          ),
          SizedBox(width: AppConstants.smallSpacing), // Right padding
        ],

        // Bottom search bar inside AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.largeSpacing),
          child: Padding(
            padding: AppConstants.horizontalPadding,
            child: GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: FoodSearchDelegate(
                    restaurants: appRestaurantData,
                    dishes: appDishData,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultSpacing,
                  vertical: AppConstants.smallSpacing,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  border: Border.all(color: AppConstants.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppConstants.lightTextColor),
                    SizedBox(width: AppConstants.smallSpacing),
                    Text(
                      'Search for food or restaurants...',
                      style: AppConstants.bodyTextStyle.copyWith(
                        color: AppConstants.lightTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // Main body content inside a scrollable view
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: AppConstants.defaultSpacing),

              // Section: Explore Categories (horizontal scroll)
              Padding(
                padding: AppConstants.horizontalPadding,
                child: Text(
                  'Explore Categories',
                  style: AppConstants.titleStyle,
                ),
              ),
              SizedBox(height: AppConstants.defaultSpacing),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.smallSpacing),
                  itemCount: appFoodCategories.length,
                  itemBuilder: (context, index) {
                    final category = appFoodCategories[index];
                    return CategoryCard(
                      categoryName: category,
                      categoryIcon: _getCategoryIcon(category),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tapped on $category category!'),
                            backgroundColor: AppConstants.primaryYellow,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: AppConstants.mediumSpacing),

              // Section: Featured Restaurants
              Padding(
                padding: AppConstants.horizontalPadding,
                child: Text(
                  'Featured Restaurants',
                  style: AppConstants.titleStyle,
                ),
              ),
              SizedBox(height: AppConstants.defaultSpacing),
              ...appRestaurantData.where((r) => r.isFeatured).map((restaurant) {
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                      ),
                    );
                  },
                );
              }).toList(),

              SizedBox(height: AppConstants.mediumSpacing),

              // Section: All Restaurants
              Padding(
                padding: AppConstants.horizontalPadding,
                child: Text(
                  'All Restaurants',
                  style: AppConstants.titleStyle,
                ),
              ),
              SizedBox(height: AppConstants.defaultSpacing),
              ...appRestaurantData.map((restaurant) {
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                      ),
                    );
                  },
                );
              }).toList(),

              SizedBox(height: AppConstants.extraLargeSpacing),

              // *** LOGOUT BUTTON REMOVED HERE ***
              // Previously, the logout button was here at the bottom.
              // It has been removed as per your request.

              SizedBox(height: AppConstants.extraLargeSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
