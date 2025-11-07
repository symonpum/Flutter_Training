import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

// GoF Pattern: Singleton & Observer
// Singleton: Ensures a single, globally accessible cart state throughout the app.
// Observer: ValueNotifier acts as the "Subject". UI widgets listen to it and rebuild upon changes.
class CartProvider {
  // --- Singleton Implementation sample from ecommerce App---
  static final CartProvider _instance = CartProvider._internal();

  factory CartProvider() {
    return _instance;
  }

  CartProvider._internal();

  // --- Observer Pattern: ValueNotifier as Subject ---
  // UI widgets listen to this notifier and rebuild when cart changes
  final ValueNotifier<List<CartLine>> cartNotifier = ValueNotifier([]);

  // Restaurant context
  String? _restaurantId;
  String? _restaurantName;
  double _minimumOrder = 0.0;

  // Fees & Tax
  double _taxRate = 0.08;
  double _deliveryFee = 2.99;
  double _platformFee = 0.0;

  // Event callbacks for logging/analytics
  void Function(FoodItem item, int qty)? onItemAdded;
  void Function(String id)? onItemRemoved;
  void Function(String id, int qty)? onQuantityChanged;
  void Function()? onCartCleared;

  // ==================== GETTERS ====================
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

  // ==================== ADD ITEM ====================
  /// Add item to cart with restaurant context
  void addItem(
    FoodItem item, {
    int qty = 1,
    String? note,
    String? restaurantId,
    String? restaurantName,
    double minOrder = 0.0,
  }) {
    // If from different restaurant, clear cart
    if (_restaurantId != null && _restaurantId != restaurantId) {
      _items.clear();
    }

    _restaurantId = restaurantId;
    _restaurantName = restaurantName;
    _minimumOrder = minOrder;

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
      // New item
      currentCart.add(CartLine(item: item, quantity: qty, note: note));
    }

    // Trigger callbacks
    if (onItemAdded != null) onItemAdded!(item, qty);

    // Notify all listeners
    cartNotifier.value = currentCart;
  }

  // ==================== REMOVE ITEM ====================
  /// Remove item from cart
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

  // ==================== CHANGE QUANTITY ====================
  /// Change quantity by delta (increase or decrease)
  void changeQuantity(String id, int delta) {
    final List<CartLine> currentCart = List.from(cartNotifier.value);
    final index = currentCart.indexWhere((line) => line.item.id == id);

    if (index < 0) return;

    currentCart[index].quantity += delta;

    // Remove item if quantity becomes 0 or less
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

  // ==================== UPDATE NOTE ====================
  /// Update special instructions for item
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
    // Notify listeners about the change
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

  // ==================== CLEAR CART ====================
  /// Clear entire cart
  void clear() {
    _restaurantId = null;
    _restaurantName = null;
    _minimumOrder = 0.0;

    if (onCartCleared != null) onCartCleared!();

    cartNotifier.value = [];
  }

  // ==================== HELPER ====================
  /// Get item by id
  CartLine? getItem(String id) {
    try {
      return cartNotifier.value.firstWhere((line) => line.item.id == id);
    } catch (e) {
      return null;
    }
  }

  // For backward compatibility if needed
  List<CartLine> get _items => cartNotifier.value;
}

/// CartLine model
class CartLine {
  final FoodItem item;
  int quantity;
  String? note;

  CartLine({required this.item, this.quantity = 1, this.note});

  double get totalPrice => item.price * quantity;

  CartLine copyWith({int? quantity, String? note}) {
    return CartLine(
      item: item,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartLine &&
          runtimeType == other.runtimeType &&
          item.id == other.item.id;

  @override
  int get hashCode => item.id.hashCode;
}
