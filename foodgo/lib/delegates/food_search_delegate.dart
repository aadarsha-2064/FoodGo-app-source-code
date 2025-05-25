// foodgo_app/lib/delegates/food_search_delegate.dart

import 'package:flutter/material.dart';
import '../models/restaurant.dart';  // Import Restaurant model
import '../models/dish.dart';        // Import Dish model
import '../utils/app_constants.dart';    // Global constants for styling
import '../widgets/restaurant_card.dart'; // Reuse RestaurantCard for results
import '../widgets/dish_card.dart';       // Reuse DishCard for results
import '../pages/restaurant_detail_page.dart'; // Navigate to restaurant details
import '../pages/dish_detail_page.dart';      // Navigate to dish details

// FoodSearchDelegate handles the custom search UI and logic for FoodGo.
// It extends SearchDelegate with a return type of String (though we won't return anything specific, just navigate).
class FoodSearchDelegate extends SearchDelegate<String> {
  final List<Restaurant> restaurants; // List of all restaurants to search through
  final List<Dish> dishes;           // List of all dishes to search through

  FoodSearchDelegate({required this.restaurants, required this.dishes});

  // Override the text label for the search field.
  @override
  String get searchFieldLabel => 'Search for food or restaurants...';

  // Defines the actions that appear in the AppBar of the search page.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // A button to clear the search query.
      IconButton(
        icon: Icon(Icons.clear, color: AppConstants.textColor),
        onPressed: () {
          query = ''; // Clear the current search query
          showSuggestions(context); // Show suggestions again
        },
      ),
    ];
  }

  // Defines the leading icon in the AppBar (typically a back button).
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
      onPressed: () {
        close(context, ''); // Close the search page and return an empty string
      },
    );
  }

  // Builds the results page when the user submits a search query.
  @override
  Widget buildResults(BuildContext context) {
    // If the query is empty, show a message.
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Type to search for restaurants or dishes.',
          style: AppConstants.subtitleStyle.copyWith(color: AppConstants.lightTextColor),
        ),
      );
    }

    // Filter restaurants and dishes based on the query.
    final filteredRestaurants = restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(query.toLowerCase());
    }).toList();

    final filteredDishes = dishes.where((dish) {
      return dish.name.toLowerCase().contains(query.toLowerCase()) ||
          dish.description.toLowerCase().contains(query.toLowerCase()) ||
          dish.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: AppConstants.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Restaurant Results ---
          if (filteredRestaurants.isNotEmpty) ...[
            Text(
              'Restaurants',
              style: AppConstants.titleStyle,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            ListView.builder(
              shrinkWrap: true, // Important for nested scrolling
              physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = filteredRestaurants[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    // Close search and navigate to restaurant detail page
                    close(context, restaurant.name); // You can pass the query back if needed
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
          ],
          // --- Dish Results ---
          if (filteredDishes.isNotEmpty) ...[
            Text(
              'Dishes',
              style: AppConstants.titleStyle,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            GridView.builder(
              shrinkWrap: true, // Important for nested scrolling
              physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: AppConstants.defaultSpacing,
                mainAxisSpacing: AppConstants.defaultSpacing,
                childAspectRatio: 0.7, // Adjust as needed
              ),
              itemCount: filteredDishes.length,
              itemBuilder: (context, index) {
                final dish = filteredDishes[index];
                return DishCard(
                  dish: dish,
                  onTap: () {
                    // Close search and navigate to dish detail page
                    close(context, dish.name);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DishDetailPage(dish: dish),
                      ),
                    );
                  },
                );
              },
            ),
          ],
          // --- No Results Message ---
          if (filteredRestaurants.isEmpty && filteredDishes.isEmpty && query.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultSpacing),
                child: Text(
                  'No results found for "$query".',
                  style: AppConstants.subtitleStyle.copyWith(color: AppConstants.lightTextColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.extraLargeSpacing), // Bottom padding
        ],
      ),
    );
  }

  // Builds suggestions as the user types (real-time filtering).
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = [];

    // Combine and filter both restaurants and dishes
    final allItems = [...restaurants, ...dishes];
    for (var item in allItems) {
      if (item is Restaurant) {
        if (item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.cuisine.toLowerCase().contains(query.toLowerCase())) {
          suggestionList.add(item);
        }
      } else if (item is Dish) {
        if (item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase())) {
          suggestionList.add(item);
        }
      }
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final item = suggestionList[index];
        IconData icon;
        String title;
        String subtitle;

        if (item is Restaurant) {
          icon = Icons.restaurant;
          title = item.name;
          subtitle = item.cuisine;
        } else { // item is Dish
          icon = Icons.fastfood;
          title = item.name;
          subtitle = item.category;
        }

        return ListTile(
          leading: Icon(icon, color: AppConstants.primaryOrange),
          title: Text(
            title,
            style: AppConstants.bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subtitle,
            style: AppConstants.captionStyle.copyWith(color: AppConstants.lightTextColor),
          ),
          onTap: () {
            // Set the query to the tapped suggestion and show results immediately.
            query = title;
            showResults(context);
          },
        );
      },
    );
  }

  // Override the default AppBarTheme for the search page.
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.backgroundColor, // Match app's theme
        elevation: 0,
        titleTextStyle: AppConstants.titleStyle,
        toolbarTextStyle: AppConstants.bodyTextStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppConstants.bodyTextStyle.copyWith(color: AppConstants.lightTextColor),
        labelStyle: AppConstants.bodyTextStyle.copyWith(color: AppConstants.textColor),
        border: InputBorder.none, // No border for search input
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppConstants.primaryOrange, // Custom cursor color
        selectionColor: AppConstants.primaryOrange.withOpacity(0.3), // Custom selection color
        selectionHandleColor: AppConstants.primaryOrange, // Custom handle color
      ),
    );
  }
}