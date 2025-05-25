// foodgo_app/lib/models/restaurant.dart

import 'package:flutter/material.dart'; // Using for Color type if needed for restaurant specific colors

// The Restaurant model represents a single restaurant in the FoodGo app.
// It holds essential information that users will see when Browse for food.
class Restaurant {
  final String id; // Unique identifier for the restaurant
  final String name; // Name of the restaurant (e.g., "Spice Route Indian Cuisine")
  final String imageUrl; // URL or asset path for the restaurant's logo or banner image
  final String cuisine; // Type of cuisine (e.g., "Indian", "Nepali", "Italian")
  final double rating; // Average user rating (e.g., 4.5)
  final int totalRatings; // Total number of ratings received
  final String address; // Physical address of the restaurant
  final String estimatedDeliveryTime; // e.g., "30-45 mins"
  final double deliveryFee; // Cost for delivery
  final double minOrderValue; // Minimum order required for delivery
  final bool isFeatured; // Whether the restaurant should be highlighted (e.g., on homepage)
  final bool isOpen; // Current operational status of the restaurant

  // Constructor for the Restaurant model. All fields are required to ensure data integrity.
  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.rating,
    required this.totalRatings,
    required this.address,
    required this.estimatedDeliveryTime,
    required this.deliveryFee,
    required this.minOrderValue,
    this.isFeatured = false, // Default to false if not specified
    this.isOpen = true, // Default to true if not specified
  });

  // --- Serialization: Convert Restaurant object to a Map (e.g., for JSON or database storage) ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'cuisine': cuisine,
      'rating': rating,
      'totalRatings': totalRatings,
      'address': address,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'deliveryFee': deliveryFee,
      'minOrderValue': minOrderValue,
      'isFeatured': isFeatured,
      'isOpen': isOpen,
    };
  }

  // --- Deserialization: Create a Restaurant object from a Map (e.g., from JSON or database) ---
  // Factory constructor for creating a `Restaurant` instance from a map.
  // This is useful when fetching data from a backend or local storage.
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      cuisine: map['cuisine'] as String,
      rating: (map['rating'] as num).toDouble(), // Handles both int and double from JSON
      totalRatings: map['totalRatings'] as int,
      address: map['address'] as String,
      estimatedDeliveryTime: map['estimatedDeliveryTime'] as String,
      deliveryFee: (map['deliveryFee'] as num).toDouble(),
      minOrderValue: (map['minOrderValue'] as num).toDouble(),
      isFeatured: map['isFeatured'] as bool? ?? false, // Handle null case with default
      isOpen: map['isOpen'] as bool? ?? true, // Handle null case with default
    );
  }
}