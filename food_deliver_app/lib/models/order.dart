import 'address.dart';
import 'food_item.dart';

// Create order status enum to track order progress
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  pickedUp,
  enroute,
  delivered,
  cancelled,
}

// Define Order model to represent a food delivery order
class Order {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final List<FoodItem> items; // Uses FoodItem model for order items
  final Address deliveryAddress;
  final double subtotal;
  final double deliveryFee;
  final double total;
  OrderStatus status;
  final DateTime createdAt;

  // Constructor for Order model to initialize order properties
  Order({
    required this.id,
    this.restaurantId,
    this.restaurantName,
    required this.items,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  // Factory method to create Order instance from a map representation
  factory Order.fromMap(Map<String, dynamic> m) {
    return Order(
      id: (m['id'] ?? '').toString(),
      restaurantId: m['restaurantId'] as String?,
      restaurantName: m['restaurantName'] as String?,
      items:
          (m['items'] as List<dynamic>?)
              ?.map((e) => FoodItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryAddress: Address.fromMap(m['deliveryAddress'] ?? {}),
      subtotal: (m['subtotal'] is num)
          ? (m['subtotal'] as num).toDouble()
          : 0.0,
      deliveryFee: (m['deliveryFee'] is num)
          ? (m['deliveryFee'] as num).toDouble()
          : 0.0,
      total: (m['total'] is num) ? (m['total'] as num).toDouble() : 0.0,
      status: _statusFromString(m['status'] ?? 'pending'),
      createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Order status conversion methods from/to string representation to support serialization
  // use switch case to map string values to enum values
  static OrderStatus _statusFromString(String s) {
    switch (s) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'pickedUp':
        return OrderStatus.pickedUp;
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

  // use switch case to map enum values to string values
  static String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.pickedUp:
        return 'pickedUp';
      case OrderStatus.enroute:
        return 'enroute';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  // Method to convert Order instance to a map representation for serialization
  // maps enum status to string using _statusToString method
  Map<String, dynamic> toMap() => {
    'id': id,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'items': items.map((e) => e.toMap()).toList(),
    'deliveryAddress': deliveryAddress.toMap(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'total': total,
    'status': _statusToString(status),
    'createdAt': createdAt.toIso8601String(),
  };
}
