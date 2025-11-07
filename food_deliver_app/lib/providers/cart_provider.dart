import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

class CartProvider {
  CartProvider._internal();
  static final CartProvider _instance = CartProvider._internal();

  static final ValueNotifier<CartProvider> instanceNotifier = ValueNotifier(
    _instance,
  );

  factory CartProvider() => _instance;

  final Map<String, CartLine> _items = {};
  String? _restaurantId;
  String? _restaurantName;
  double _minimumOrder = 0.0;

  double _taxRate = 0.08; // default tax
  double _deliveryFee = 2.99; // default delivery fee
  double _platformFee = 0.0; // default platform fee

  // ==================== EVENTS / LOGGING ====================
  void Function(FoodItem item, int qty)? onItemAdded;
  void Function(String id)? onItemRemoved;
  void Function(String id, int qty)? onQuantityChanged;
  void Function()? onCartCleared;

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

  double get tax => subtotal * _taxRate;
  double get deliveryFee => _deliveryFee;
  double get platformFee => _platformFee;
  double get total => subtotal + deliveryFee + tax + platformFee;

  bool get isBelowMinimum => subtotal < _minimumOrder;
  bool get isEmpty => _items.isEmpty;

  // ==================== ADD ITEM ====================
  void addItem(
    FoodItem item, {
    int qty = 1,
    String? note,
    String? restaurantId,
    String? restaurantName,
    double minOrder = 0.0,
  }) {
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

    if (onItemAdded != null) onItemAdded!(item, qty);

    _notifyListeners();
  }

  // ==================== REMOVE ITEM ====================
  void removeItem(String id) {
    _items.remove(id);
    if (_items.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _minimumOrder = 0.0;
    }

    if (onItemRemoved != null) onItemRemoved!(id);

    _notifyListeners();
  }

  // ==================== CHANGE QUANTITY ====================
  void changeQuantity(String id, int delta) {
    final line = _items[id];
    if (line == null) return;

    line.quantity += delta;
    if (line.quantity <= 0) {
      _items.remove(id);
      if (onItemRemoved != null) onItemRemoved!(id);
    } else {
      if (onQuantityChanged != null) onQuantityChanged!(id, line.quantity);
    }

    if (_items.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _minimumOrder = 0.0;
    }

    _notifyListeners();
  }

  // ==================== CLEAR CART ====================
  void clear() {
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    _minimumOrder = 0.0;

    if (onCartCleared != null) onCartCleared!();

    _notifyListeners();
  }

  // ==================== NOTES ====================
  void updateNote(String id, String note) {
    if (_items.containsKey(id)) {
      _items[id]!.note = note.isNotEmpty ? note : null;
      _notifyListeners();
    }
  }

  // ==================== FEES ====================
  void setTaxRate(double rate) {
    _taxRate = rate;
    _notifyListeners();
  }

  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    _notifyListeners();
  }

  void setPlatformFee(double fee) {
    _platformFee = fee;
    _notifyListeners();
  }

  // ==================== SERIALIZATION ====================
  Map<String, dynamic> toJson() {
    return {
      'restaurantId': _restaurantId,
      'restaurantName': _restaurantName,
      'minimumOrder': _minimumOrder,
      'taxRate': _taxRate,
      'deliveryFee': _deliveryFee,
      'platformFee': _platformFee,
      'items': _items.map((key, line) => MapEntry(key, line.toJson())),
    };
  }

  static CartProvider fromJson(Map<String, dynamic> json) {
    final cart = CartProvider();
    cart._restaurantId = json['restaurantId'];
    cart._restaurantName = json['restaurantName'];
    cart._minimumOrder = (json['minimumOrder'] ?? 0.0).toDouble();
    cart._taxRate = (json['taxRate'] ?? 0.0).toDouble();
    cart._deliveryFee = (json['deliveryFee'] ?? 0.0).toDouble();
    cart._platformFee = (json['platformFee'] ?? 0.0).toDouble();

    final itemsJson = json['items'] as Map<String, dynamic>? ?? {};
    cart._items.clear();
    itemsJson.forEach((key, value) {
      cart._items[key] = CartLine.fromJson(value);
    });

    cart._notifyListeners();
    return cart;
  }

  String toJsonString() => jsonEncode(toJson());

  static CartProvider fromJsonString(String jsonStr) =>
      fromJson(jsonDecode(jsonStr));

  // ==================== HELPER ====================
  CartLine? getItem(String id) => _items[id];

  void _notifyListeners() {
    instanceNotifier.value = _instance;
  }
}

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

  Map<String, dynamic> toJson() {
    return {'item': item.toJson(), 'quantity': quantity, 'note': note};
  }

  static CartLine fromJson(Map<String, dynamic> json) {
    return CartLine(
      item: FoodItem.fromJson(json['item']),
      quantity: json['quantity'] ?? 1,
      note: json['note'],
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
