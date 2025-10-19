import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/model/list_product_model.dart';
import 'package:ecommerce_app/model/product_data_model.dart';

// GoF Pattern: Facade & Singleton
// Facade: Simplifies the complex underlying system of HTTP requests into a clean, high-level API.
// Singleton: Ensures there's only one instance of ApiService managing all network calls.
class ApiService {
  // --- Singleton Implementation ---
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();
  // ------------------------------

  final String _baseUrl =
      'https://unledged-temple-undebilitative.ngrok-free.dev';

  // Fetches all products from the server.
  Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/products'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final ListProductModel deserielizeData = ListProductModel.fromListJson(
          response.body,
        );
        return deserielizeData.products;
      } else {
        throw Exception(
          'Failed to load products. Status code: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception(
        'Network request timed out. Please check your connection.',
      );
    } catch (e) {
      // Re-throw with a more user-friendly message
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Updates the stock count of a specific product on the server.
  Future<void> updateProductStock(String productId, int newStock) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$_baseUrl/products/$productId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'stock': newStock}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update product stock. Status code: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Network request timed out.');
    } catch (e) {
      throw Exception('Failed to update product stock: $e');
    }
  }
}
