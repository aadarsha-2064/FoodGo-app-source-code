// foodgo_app/lib/services/cart_service.dart

import 'package:flutter/material.dart';
import '../models/dish.dart';    // Import the Dish model
import '../models/cart_item.dart'; // <<<--- THIS IS THE CRUCIAL IMPORT FOR THIS FILE!

// CartService manages the state of the user's shopping cart.
// It extends ChangeNotifier to notify listeners (UI widgets) when the cart changes.
class CartService extends ChangeNotifier {
  // A private list to store the items currently in the cart.
  final List<CartItem> _items = [];

  // Public getter to access the items in the cart (read-only).
  List<CartItem> get items => List.unmodifiable(_items); // Return an unmodifiable list

  // Calculates the total number of unique items in the cart.
  int get itemCount => _items.length;

  // Calculates the total price of all items in the cart.
  double get cartTotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.totalPrice; // Sum up the total price of each CartItem
    }
    return total;
  }

  // --- Add a dish to the cart ---
  // If the dish is already in the cart, its quantity is updated.
  // Otherwise, a new CartItem is added.
  void addItem(Dish dish, int quantity) {
    // Check if the item already exists in the cart.
    // We compare by dish ID to ensure we're looking for the same dish.
    int existingIndex = _items.indexWhere((item) => item.dish.id == dish.id);

    if (existingIndex != -1) {
      // If the item exists, update its quantity.
      _items[existingIndex].quantity += quantity;
    } else {
      // If the item is new, add it as a new CartItem.
      _items.add(CartItem(dish: dish, quantity: quantity));
    }
    notifyListeners(); // Notify UI that the cart has changed.
  }

  // --- Remove a dish from the cart ---
  // Removes a specific dish from the cart entirely.
  void removeItem(Dish dish) {
    _items.removeWhere((item) => item.dish.id == dish.id);
    notifyListeners(); // Notify UI.
  }

  // --- Update the quantity of an item in the cart ---
  // If the new quantity is 0 or less, the item is removed.
  void updateItemQuantity(Dish dish, int newQuantity) {
    int existingIndex = _items.indexWhere((item) => item.dish.id == dish.id);

    if (existingIndex != -1) {
      if (newQuantity <= 0) {
        // If quantity is 0 or less, remove the item.
        _items.removeAt(existingIndex);
      } else {
        // Otherwise, update the quantity.
        _items[existingIndex].quantity = newQuantity;
      }
      notifyListeners(); // Notify UI.
    }
  }

  // --- Get the quantity of a specific dish in the cart ---
  int getDishQuantity(Dish dish) {
    final item = _items.firstWhere(
      (cartItem) => cartItem.dish.id == dish.id,
      orElse: () => CartItem(dish: dish, quantity: 0), // Return a dummy item with 0 quantity if not found
    );
    return item.quantity;
  }

  // --- Clear the entire cart ---
  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify UI.
  }
}