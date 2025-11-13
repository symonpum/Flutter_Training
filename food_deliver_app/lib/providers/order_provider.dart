import 'package:flutter/material.dart';
import '../models/order.dart';

// Singleton OrderProvider to manage the current order state
class OrderProvider {
  OrderProvider._internal();
  static final OrderProvider _instance = OrderProvider._internal();
  static final ValueNotifier<OrderProvider> instanceNotifier = ValueNotifier(
    _instance,
  );
  // Factory constructor to return the singleton instance
  factory OrderProvider() => _instance;

  Order? _current;
  Order? get current => _current;

  // Set the current order
  void setCurrent(Order o) {
    _current = o;
    instanceNotifier.value = _instance;
  }

  // Update the status of the current order
  void updateStatus(OrderStatus s) {
    if (_current != null) {
      _current!.status = s;
      instanceNotifier.value = _instance;
    }
  }

  // Clear the current order
  void clear() {
    _current = null;
    instanceNotifier.value = _instance;
  }
}
