// foodgo_app/lib/models/cart_item.dart

import 'dish.dart'; // <<<--- THIS IS THE CRUCIAL IMPORT FOR THIS FILE!

// CartItem represents a single item (dish) along with its quantity in the shopping cart.
class CartItem {
  final Dish dish;    // The actual dish object being added to the cart.
  int quantity;       // The quantity of this dish in the cart.

  // Constructor for CartItem.
  // Requires a Dish object and an initial quantity.
  CartItem({
    required this.dish,
    this.quantity = 1, // Default quantity to 1 if not specified
  });

  // Getter to calculate the total price for this cart item.
  // It's the dish's price multiplied by its quantity.
  double get totalPrice => dish.price * quantity;

  // You can optionally add a copyWith method for easier state updates
  // or conversion to/from JSON if you were integrating with a backend.
  // For this basic example, we'll keep it simple.
}