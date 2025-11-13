import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

// GoF Pattern: Singleton & Observer
class CartProvider {
  // --- Singleton Implementation ---
  static final CartProvider _instance = CartProvider._internal();

  factory CartProvider() {
    return _instance;
  }

  CartProvider._internal();

  // --- Observer Pattern: ValueNotifier as Subject ---
  final ValueNotifier<List<CartLine>> cartNotifier = ValueNotifier([]);

  // Restaurant Context for the cart
  String? _restaurantId;
  String? _restaurantName;
  double _minimumOrder = 0.0;

  // Fees & Tax Rates for the cart
  double _taxRate = 0.08;
  double _deliveryFee = 2.99;
  double _platformFee = 0.0;

  // Event callbacks for logging/analytics or UI updates outside of listeners
  void Function(FoodItem item, int qty)? onItemAdded;
  void Function(String id)? onItemRemoved;
  void Function(String id, int qty)? onQuantityChanged;
  void Function()? onCartCleared;

  // Get current cart items and restaurant
  List<CartLine> get items => cartNotifier.value;
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  double get minimumOrder => _minimumOrder;

  double get subtotal =>
      cartNotifier.value.fold(0.0, (sum, line) => sum + line.totalPrice);

  int get totalItems =>
      cartNotifier.value.fold(0, (sum, line) => sum + line.quantity);

  int get itemCount => cartNotifier.value.length;

  double get tax => subtotal * _taxRate;
  double get deliveryFee => _deliveryFee;
  double get platformFee => _platformFee;
  double get total => subtotal + deliveryFee + tax + platformFee;

  bool get isBelowMinimum => subtotal < _minimumOrder;
  bool get isEmpty => cartNotifier.value.isEmpty;

  // Converts the current cart lines into a list of FoodItem models
  // with quantity and note injected via copyWith.
  List<FoodItem> toOrderFoodItems() {
    return cartNotifier.value
        .map(
          (line) =>
              line.item.copyWith(quantity: line.quantity, note: line.note),
        )
        .toList();
  }

  // Add item to cart with restaurant context
  void addItem(
    FoodItem item, {
    int qty = 1,
    String? note,
    String? restaurantId,
    String? restaurantName,
    double minOrder = 0.0,
  }) {
    // If added from different restaurant > clear cart
    if (_restaurantId != null && _restaurantId != restaurantId) {
      _items.clear();
    }

    _restaurantId = restaurantId;
    _restaurantName = restaurantName;
    _minimumOrder = minOrder;

    // Check if item already exists in cart
    final List<CartLine> currentCart = List.from(cartNotifier.value);
    final existingIndex = currentCart.indexWhere(
      (line) => line.item.id == item.id,
    );

    if (existingIndex >= 0) {
      // Item exists, update quantity
      currentCart[existingIndex].quantity += qty;
      if (note != null && note.isNotEmpty) {
        currentCart[existingIndex].note = note;
      }
    } else {
      // New item added to cart
      currentCart.add(CartLine(item: item, quantity: qty, note: note));
    }

    // Trigger callbacks if any
    if (onItemAdded != null) onItemAdded!(item, qty);

    // Notify all listeners about the change in cart
    cartNotifier.value = currentCart;
  }

  // Remove item from cart
  void removeItem(String id) {
    final List<CartLine> currentCart = List.from(cartNotifier.value);
    currentCart.removeWhere((line) => line.item.id == id);

    if (currentCart.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _minimumOrder = 0.0;
    }

    if (onItemRemoved != null) onItemRemoved!(id);

    cartNotifier.value = currentCart;
  }

  // Change quantity by increase or decrease quantity
  // delta can be positive or negative to adjust quantity
  void changeQuantity(String id, int delta) {
    final List<CartLine> currentCart = List.from(cartNotifier.value);
    final index = currentCart.indexWhere((line) => line.item.id == id);

    if (index < 0) return;

    currentCart[index].quantity += delta;

    // Remove item from cart if the quantity becomes 0 or less than 0
    if (currentCart[index].quantity <= 0) {
      currentCart.removeAt(index);
      if (onItemRemoved != null) onItemRemoved!(id);
    } else {
      if (onQuantityChanged != null) {
        onQuantityChanged!(id, currentCart[index].quantity);
      }
    }

    if (currentCart.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _minimumOrder = 0.0;
    }

    cartNotifier.value = currentCart;
  }

  // Update special instructions (note) for item in cart
  void updateNote(String id, String note) {
    final List<CartLine> currentCart = List.from(cartNotifier.value);
    final index = currentCart.indexWhere((line) => line.item.id == id);

    if (index >= 0) {
      currentCart[index].note = note.isNotEmpty ? note : null;
      cartNotifier.value = currentCart;
    }
  }

  // ==================== SET FEES & TAX ====================
  void setTaxRate(double rate) {
    _taxRate = rate;
    // Notify listeners about the change in cart
    cartNotifier.value = List.from(cartNotifier.value);
  }

  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    cartNotifier.value = List.from(cartNotifier.value);
  }

  void setPlatformFee(double fee) {
    _platformFee = fee;
    cartNotifier.value = List.from(cartNotifier.value);
  }

  // Clear entire cart on pressing clear all button in cart
  void clear() {
    _restaurantId = null;
    _restaurantName = null;
    _minimumOrder = 0.0;

    if (onCartCleared != null) onCartCleared!();

    cartNotifier.value = [];
  }

  // Helper: Get item by id from cart (if exists) to update UI or logic
  CartLine? getItem(String id) {
    try {
      return cartNotifier.value.firstWhere((line) => line.item.id == id);
    } catch (e) {
      return null;
    }
  }

  // For backward compatibility if needed - internal access to cart items
  List<CartLine> get _items => cartNotifier.value;
}

// CartLine model to represent each line item in the cart
class CartLine {
  final FoodItem item;
  int quantity;
  String? note;
  // Constructor for CartLine model
  CartLine({required this.item, this.quantity = 1, this.note});

  double get totalPrice => item.price * quantity;

  // Create a copy of CartLine with updated fields
  CartLine copyWith({int? quantity, String? note}) {
    return CartLine(
      item: item,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  //Override equality operator and hashcode for proper comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartLine &&
          runtimeType == other.runtimeType &&
          item.id == other.item.id;

  @override
  int get hashCode => item.id.hashCode;
}
