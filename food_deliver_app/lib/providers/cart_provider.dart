import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

class CartProvider {
  CartProvider._internal();
  static final CartProvider _instance = CartProvider._internal();

  /// Notifies widgets when cart changes - LIVE UPDATES
  /// Using ValueNotifier only (follows course guidelines)
  static final ValueNotifier<CartProvider> instanceNotifier = ValueNotifier(
    _instance,
  );

  factory CartProvider() => _instance;

  final Map<String, CartLine> _items = {};
  String? _restaurantId;
  String? _restaurantName;
  double _minimumOrder = 0.0;

  // ==================== GETTERS ====================
  List<CartLine> get items => _items.values.toList();
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  double get minimumOrder => _minimumOrder;

  double get subtotal =>
      _items.values.fold(0.0, (sum, line) => sum + line.totalPrice);

  int get totalItems =>
      _items.values.fold(0, (sum, line) => sum + line.quantity);

  int get itemCount => _items.length;

  // Calculate delivery fee (flat $2.99)
  double get deliveryFee => 2.99;

  // Calculate tax (8%)
  double get tax => subtotal * 0.08;

  // Calculate total
  double get total => subtotal + deliveryFee + tax;

  // Check if below minimum order
  bool get isBelowMinimum => subtotal < _minimumOrder;

  bool get isEmpty => _items.isEmpty;

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

    final key = item.id;
    if (_items.containsKey(key)) {
      _items[key]!.quantity += qty;
      if (note != null && note.isNotEmpty) _items[key]!.note = note;
    } else {
      _items[key] = CartLine(item: item, quantity: qty, note: note);
    }

    // ✅ TRIGGER LIVE UPDATE - ValueNotifier only
    _notifyListeners();
  }

  // ==================== REMOVE ITEM ====================
  /// Remove item from cart
  void removeItem(String id) {
    _items.remove(id);
    if (_items.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _minimumOrder = 0.0;
    }

    // ✅ TRIGGER LIVE UPDATE
    _notifyListeners();
  }

  // ==================== CHANGE QUANTITY ====================
  /// Change quantity by delta (increase or decrease)
  void changeQuantity(String id, int delta) {
    final line = _items[id];
    if (line == null) return;

    line.quantity += delta;

    // Remove item if quantity becomes 0 or less
    if (line.quantity <= 0) {
      _items.remove(id);
    }

    if (_items.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _minimumOrder = 0.0;
    }

    // ✅ TRIGGER LIVE UPDATE
    _notifyListeners();
  }

  // ==================== UPDATE NOTE ====================
  /// Update special instructions for item
  void updateNote(String id, String note) {
    if (_items.containsKey(id)) {
      _items[id]!.note = note.isNotEmpty ? note : null;

      // ✅ TRIGGER LIVE UPDATE
      _notifyListeners();
    }
  }

  // ==================== CLEAR CART ====================
  /// Clear entire cart
  void clear() {
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    _minimumOrder = 0.0;

    // ✅ TRIGGER LIVE UPDATE
    _notifyListeners();
  }

  // ==================== HELPER ====================
  /// Get item by id
  CartLine? getItem(String id) => _items[id];

  /// Private method to notify all listeners using ValueNotifier
  void _notifyListeners() {
    // Update ValueNotifier for ValueListenableBuilder widgets
    // This triggers immediate rebuild for all listeners
    instanceNotifier.value = _instance;
  }
}

class CartLine {
  final FoodItem item;
  int quantity;
  String? note;

  CartLine({required this.item, this.quantity = 1, this.note});

  double get totalPrice => item.price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartLine &&
          runtimeType == other.runtimeType &&
          item.id == other.item.id;

  @override
  int get hashCode => item.id.hashCode;
}
