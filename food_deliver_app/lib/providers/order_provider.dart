import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider {
  OrderProvider._internal();
  static final OrderProvider _instance = OrderProvider._internal();
  static final ValueNotifier<OrderProvider> instanceNotifier = ValueNotifier(
    _instance,
  );
  factory OrderProvider() => _instance;

  Order? _current;
  Order? get current => _current;

  void setCurrent(Order o) {
    _current = o;
    instanceNotifier.value = _instance;
  }

  void updateStatus(OrderStatus s) {
    if (_current != null) {
      _current!.status = s;
      instanceNotifier.value = _instance;
    }
  }

  void clear() {
    _current = null;
    instanceNotifier.value = _instance;
  }
}
