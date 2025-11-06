import 'package:flutter/material.dart';
import '../models/food_item.dart';

class CartProvider {
  CartProvider._internal();
  static final CartProvider _instance = CartProvider._internal();
  static final ValueNotifier<CartProvider> instanceNotifier = ValueNotifier(
    _instance,
  );
  factory CartProvider() => _instance;

  final Map<String, _Line> _items = {};

  List<_Line> get items => _items.values.toList();
  double get subtotal => _items.values.fold(0.0, (s, l) => s + l.totalPrice);
  int get totalItems => _items.values.fold(0, (s, l) => s + l.quantity);

  void addItem(FoodItem item, {int qty = 1, String? note}) {
    final key = item.id;
    if (_items.containsKey(key)) {
      _items[key]!.quantity += qty;
      if (note != null) _items[key]!.note = note;
    } else {
      _items[key] = _Line(item: item, quantity: qty, note: note);
    }
    instanceNotifier.value = _instance;
  }

  void removeItem(String id) {
    _items.remove(id);
    instanceNotifier.value = _instance;
  }

  void changeQuantity(String id, int delta) {
    final line = _items[id];
    if (line == null) return;
    line.quantity += delta;
    if (line.quantity <= 0) _items.remove(id);
    instanceNotifier.value = _instance;
  }

  void clear() {
    _items.clear();
    instanceNotifier.value = _instance;
  }
}

class _Line {
  final FoodItem item;
  int quantity;
  String? note;
  _Line({required this.item, this.quantity = 1, this.note});
  double get totalPrice => item.price * quantity;
}
