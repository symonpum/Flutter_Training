import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart'; // Import Order and OrderStatus
import '../models/food_item.dart';

class OrderService {
  // Singleton pattern
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  factory OrderService() {
    return instance;
  }

  // Base URL - Update this to your server URL
  static const String baseUrl =
      'https://unledged-temple-undebilitative.ngrok-free.dev';

  // ==================== CREATE ORDER ====================
  static Future<Order> createOrder(Order order) async {
    try {
      // Use the toMap() method from the Order model
      final orderData = order.toMap();

      final url = Uri.parse('$baseUrl/orders');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Order.fromMap(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to create order: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ==================== GET ORDER ====================
  static Future<Order?> getOrderById(String orderId) async {
    try {
      final url = Uri.parse('$baseUrl/orders/$orderId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Order.fromMap(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Failed to load order: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return null;
    }
  }

  // ======================================================
  // === ERROR 1 FIX: ADDED MISSING updateOrderStatus  ===
  // ======================================================
  /// Update order status to a specific state
  static Future<void> updateOrderStatus(String id, OrderStatus status) async {
    try {
      final url = Uri.parse('$baseUrl/orders/$id');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        // Use the _statusToString helper to send the correct string
        body: jsonEncode({'status': _statusToString(status)}),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to update status: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ======================================================
  // === ERROR 2 FIX: ADDED 'pickedUp' TO SWITCH CASE ===
  // ======================================================
  /// Convert OrderStatus enum to string
  static String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.pickedUp: // <-- This was the missing case
        return 'pickedUp';
      case OrderStatus.enroute:
        return 'enroute';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      // No default needed because the enum is fully covered
    }
  }
}
