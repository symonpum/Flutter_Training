import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product_data_model.dart';

// GoF Pattern: Singleton & Observer
// Singleton: Ensures a single, globally accessible cart state throughout the app.
// Observer: ValueNotifier acts as the "Subject". UI widgets listen to it and rebuild upon changes.
class CartService {
  // --- Singleton Implementation ---
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();
  // ------------------------------

  // The "Subject" that observers (UI widgets) will listen to.
  final ValueNotifier<List<CartItem>> cartNotifier = ValueNotifier([]);

  /// Helper to get the current quantity of a specific product in the cart.
  int getQuantityInCart(String productId) {
    final currentCart = cartNotifier.value;
    final index = currentCart.indexWhere(
      (item) => item.product.id == productId,
    );
    return (index != -1) ? currentCart[index].quantity : 0;
  }

  /// Adds a single product to the cart. A convenience method for the new, more robust function.
  void addProduct(Product product) {
    addProductWithQuantity(product, 1);
  }

  /// Adds a product with a specific quantity to the cart, or updates its quantity if it already exists.
  void addProductWithQuantity(Product product, int quantityToAdd) {
    if (quantityToAdd <= 0) return;

    final List<CartItem> currentCart = List.from(cartNotifier.value);
    final index = currentCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      // Product already in cart, update quantity if stock allows
      int newQuantity = currentCart[index].quantity + quantityToAdd;
      // Cap the quantity at the total available stock
      currentCart[index].quantity = (newQuantity > product.stock)
          ? product.stock
          : newQuantity;
    } else {
      // Product not in cart, add it if stock is available
      if (product.stock >= quantityToAdd) {
        currentCart.add(CartItem(product: product, quantity: quantityToAdd));
      }
    }
    // Notify all listeners about the change.
    cartNotifier.value = currentCart;
  }

  // Removes a product from the cart completely.
  void removeProduct(String productId) {
    final List<CartItem> currentCart = List.from(cartNotifier.value);
    currentCart.removeWhere((item) => item.product.id == productId);
    cartNotifier.value = currentCart;
  }

  // Updates the quantity of a specific item in the cart.
  void updateQuantity(String productId, int quantity) {
    final List<CartItem> currentCart = List.from(cartNotifier.value);
    int index = currentCart.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (quantity > 0 && quantity <= currentCart[index].product.stock) {
        currentCart[index].quantity = quantity;
      } else if (quantity == 0) {
        currentCart.removeAt(index);
      }
    }
    cartNotifier.value = currentCart;
  }

  // Clears all items from the cart.
  void clearCart() {
    cartNotifier.value = [];
  }

  // Calculates the total price of all items in the cart.
  double get totalCost {
    return cartNotifier.value.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
