import 'address.dart';
import 'food_item.dart';

enum OrderStatus { pending, confirmed, preparing, enroute, delivered, cancelled }

class Order {
  final String id;
  final List<FoodItem> items;
  final Address deliveryAddress;
  final double subtotal;
  final double deliveryFee;
  final double total;
  OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> m) {
    return Order(
      id: (m['id'] ?? '').toString(),
      items: (m['items'] as List<dynamic>?)
              ?.map((e) => FoodItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryAddress: Address.fromMap(m['deliveryAddress'] ?? {}),
      subtotal: (m['subtotal'] is num) ? (m['subtotal'] as num).toDouble() : 0.0,
      deliveryFee: (m['deliveryFee'] is num) ? (m['deliveryFee'] as num).toDouble() : 0.0,
      total: (m['total'] is num) ? (m['total'] as num).toDouble() : 0.0,
      status: _statusFromString(m['status'] ?? 'pending'),
      createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  static OrderStatus _statusFromString(String s) {
    switch (s) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'enroute':
        return OrderStatus.enroute;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}