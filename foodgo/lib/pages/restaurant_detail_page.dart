// foodgo_app/lib/pages/restaurant_detail_page.dart

import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/dish.dart';
import '../data/app_data.dart';
import '../utils/app_constants.dart';
import '../widgets/dish_card.dart';
import 'dish_detail_page.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  String _selectedCategory = 'All';

  List<Dish> _getDishesForRestaurant() {
    final dishes = appDishData
        .where((dish) => dish.restaurantId == widget.restaurant.id)
        .toList();

    if (_selectedCategory == 'All') {
      return dishes;
    } else {
      return dishes
          .where((dish) => dish.category == _selectedCategory)
          .toList();
    }
  }

  List<String> _getRestaurantCategories() {
    final categories = appDishData
        .where((dish) => dish.restaurantId == widget.restaurant.id)
        .map((dish) => dish.category)
        .toSet()
        .toList();
    categories.sort();
    return ['All', ...categories];
  }

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
    'All': Icons.food_bank,
  };

  IconData _getCategoryIcon(String category) {
    return _categoryIcons[category] ?? Icons.restaurant_menu;
  }

  @override
  Widget build(BuildContext context) {
    final restaurantCategories = _getRestaurantCategories();
    final dishesToDisplay = _getDishesForRestaurant();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: AppConstants.backgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppConstants.lightGrey,
                    child: Center(
                      child: Icon(Icons.broken_image,
                          color: AppConstants.grey,
                          size: AppConstants.largeSpacing),
                    ),
                  );
                },
              ),
              title: Text(
                widget.restaurant.name,
                style: AppConstants.titleStyle
                    .copyWith(color: AppConstants.white),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: AppConstants.primaryYellow,
                              size: AppConstants.defaultSpacing),
                          const SizedBox(
                              width: AppConstants.smallSpacing / 4),
                          Text(
                            '${widget.restaurant.rating} (${widget.restaurant.totalRatings} ratings)',
                            style: AppConstants.bodyTextStyle
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.delivery_dining,
                              color: AppConstants.textColor,
                              size: AppConstants.defaultSpacing),
                          const SizedBox(
                              width: AppConstants.smallSpacing / 4),
                          Text(
                            widget.restaurant.estimatedDeliveryTime,
                            style: AppConstants.bodyTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  Text(
                    widget.restaurant.cuisine,
                    style: AppConstants.subtitleStyle
                        .copyWith(color: AppConstants.lightTextColor),
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  Text(
                    widget.restaurant.address,
                    style: AppConstants.bodyTextStyle
                        .copyWith(color: AppConstants.lightTextColor),
                  ),
                  const SizedBox(height: AppConstants.defaultSpacing),
                  Divider(color: AppConstants.dividerColor),
                  const SizedBox(height: AppConstants.defaultSpacing),
                  Text(
                    'Menu Categories',
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultSpacing),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurantCategories.length,
                      itemBuilder: (context, index) {
                        final category = restaurantCategories[index];
                        final isSelected =
                            (_selectedCategory == category);
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: AppConstants.smallSpacing),
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Icon(_getCategoryIcon(category), size: 18),
                                const SizedBox(
                                    width: AppConstants.smallSpacing / 2),
                                Text(category),
                              ],
                            ),
                            selected: isSelected,
                            selectedColor: AppConstants.primaryOrange
                                .withOpacity(0.2),
                            backgroundColor: AppConstants.cardColor,
                            labelStyle: AppConstants.bodyTextStyle.copyWith(
                              color: isSelected
                                  ? AppConstants.primaryOrange
                                  : AppConstants.textColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppConstants.primaryOrange
                                  : AppConstants.dividerColor,
                              width: 1.5,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  Text(
                    _selectedCategory == 'All'
                        ? 'All Dishes'
                        : _selectedCategory,
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultSpacing),
                  if (dishesToDisplay.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.all(AppConstants.defaultSpacing),
                      child: Center(
                        child: Text(
                          'No dishes available in this category.',
                          style: AppConstants.subtitleStyle
                              .copyWith(color: AppConstants.lightTextColor),
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppConstants.defaultSpacing,
                        mainAxisSpacing: AppConstants.defaultSpacing,
                        childAspectRatio: 0.40,
                      ),
                      itemCount: dishesToDisplay.length,
                      itemBuilder: (context, index) {
                        final dish = dishesToDisplay[index];
                        return DishCard(
                          dish: dish,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DishDetailPage(dish: dish),
                              ),
                            );
                          },
                          onBuyNowTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${dish.name} added to cart!'),
                                backgroundColor:
                                    AppConstants.successGreen,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  const SizedBox(
                      height: AppConstants.extraLargeSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
