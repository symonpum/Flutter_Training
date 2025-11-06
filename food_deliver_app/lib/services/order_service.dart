import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  final String baseUrl =
      'https://unledged-temple-undebilitative.ngrok-free.dev/';

  Future<Map<String, dynamic>> fetchOrderRaw(String id) async {
    final url = Uri.parse('$baseUrl/orders/$id');
    final res = await http.get(url);
    if (res.statusCode == 200)
      return json.decode(res.body) as Map<String, dynamic>;
    throw Exception('Order fetch failed');
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    final url = Uri.parse('$baseUrl/orders');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      final map = json.decode(res.body) as Map<String, dynamic>;
      final id = map['id'].toString();
      _simulateStatusCycle(id);
      return map;
    }
    throw Exception('Order creation failed');
  }

  Future<void> _simulateStatusCycle(String id) async {
    Future.delayed(
      const Duration(seconds: 3),
      () => _patchStatus(id, 'confirmed'),
    );
    Future.delayed(
      const Duration(seconds: 8),
      () => _patchStatus(id, 'preparing'),
    );
    Future.delayed(
      const Duration(seconds: 13),
      () => _patchStatus(id, 'enroute'),
    );
    Future.delayed(
      const Duration(seconds: 25),
      () => _patchStatus(id, 'delivered'),
    );
  }

  Future<void> _patchStatus(String id, String status) async {
    final url = Uri.parse('$baseUrl/orders/$id');
    await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
  }
}
