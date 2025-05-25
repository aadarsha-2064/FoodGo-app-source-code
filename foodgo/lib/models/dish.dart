// foodgo_app/lib/models/dish.dart

import 'package:flutter/material.dart'; // For Color type if needed for dish-specific styling

// The Dish model represents a single food item in the FoodGo app.
// It contains all the necessary details for displaying and ordering a dish.
class Dish {
  final String id; // Unique identifier for the dish
  final String name; // Name of the dish (e.g., "Margherita Pizza")
  final String imageUrl; // URL or asset path for the dish's image
  final String description; // A brief description of the dish
  final double price; // Price of the dish
  final String category; // Category of the dish (e.g., "Pizza", "Pasta", "Dessert")
  final bool isVegetarian; // Whether the dish is vegetarian
  final bool isSpicy; // Whether the dish is spicy
  final double rating; // Average user rating for the dish
  final int totalRatings; // Total number of ratings for the dish
  final List<String> ingredients; // List of ingredients in the dish
  final String restaurantId; // ID of the restaurant that offers this dish

  // Constructor for the Dish model. All fields are required for data integrity.
  Dish({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.category,
    this.isVegetarian = false, // Default to false if not specified
    this.isSpicy = false, // Default to false if not specified
    this.rating = 0.0, // Default rating
    this.totalRatings = 0, // Default total ratings
    required this.ingredients,
    required this.restaurantId,
  });

  // --- Serialization: Convert Dish object to a Map (e.g., for JSON or database) ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'category': category,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'rating': rating,
      'totalRatings': totalRatings,
      'ingredients': ingredients,
      'restaurantId': restaurantId,
    };
  }

  // --- Deserialization: Create a Dish object from a Map (e.g., from JSON or database) ---
  // Factory constructor for creating a `Dish` instance from a map.
  // Useful when fetching data from a backend or local storage.
  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(), // Handles both int and double from JSON
      category: map['category'] as String,
      isVegetarian: map['isVegetarian'] as bool? ?? false, // Handle null case with default
      isSpicy: map['isSpicy'] as bool? ?? false, // Handle null case with default
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0, // Handle null case with default
      totalRatings: map['totalRatings'] as int? ?? 0, // Handle null case with default
      ingredients: List<String>.from(map['ingredients'] as List),
      restaurantId: map['restaurantId'] as String,
    );
  }
}