import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/food_item.dart';

class RestaurantService {
  RestaurantService._internal();
  static final RestaurantService instance = RestaurantService._internal();

  //  Ngrok base URL to backend server (API endpoint) where restaurants data is hosted
  final String baseUrl =
      'https://unledged-temple-undebilitative.ngrok-free.dev';

  /// Fetch all restaurants, with optional search and category filters
  Future<List<Restaurant>> fetchRestaurants({
    String? query,
    String? category,
  }) async {
    final url = Uri.parse('$baseUrl/restaurants');
    final res = await http.get(
      url,
      headers: {'ngrok-skip-browser-warning': 'true'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load restaurants: ${res.statusCode}');
    }

    final List<dynamic> raw = json.decode(res.body);
    var list = raw
        .map((m) => Restaurant.fromMap(m as Map<String, dynamic>))
        .toList();

    // Search filter
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list
          .where(
            (r) =>
                r.name.toLowerCase().contains(q) ||
                r.description.toLowerCase().contains(q) ||
                r.tags.any((t) => t.toLowerCase().contains(q)),
          )
          .toList();
    }

    // Category filter
    if (category != null && category.isNotEmpty) {
      list = list
          .where(
            (r) => r.tags
                .map((t) => t.toLowerCase())
                .contains(category.toLowerCase()),
          )
          .toList();
    }

    return list;
  }

  // Fetch menu items for a given restaurant by restaurant ID
  // uses /foodItems endpoint
  Future<List<FoodItem>> fetchMenuForRestaurant(String restaurantId) async {
    // in ecommerce app using products endpoint with category filter
    // but here we use restaurantId to get menu items
    // and foodItems endpoint
    final url = Uri.parse('$baseUrl/foodItems?restaurantId=$restaurantId');
    final res = await http.get(
      url,
      headers: {'ngrok-skip-browser-warning': 'true'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load menu: ${res.statusCode}');
    }

    final List<dynamic> raw = json.decode(res.body);
    return raw.map((m) => FoodItem.fromMap(m as Map<String, dynamic>)).toList();
  }

  /// Fetch all categories across restaurants to populate category filters
  Future<List<String>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/restaurants');
    final res = await http.get(
      url,
      headers: {'ngrok-skip-browser-warning': 'true'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load categories: ${res.statusCode}');
    }

    final List<dynamic> raw = json.decode(res.body);
    final cats = raw
        .map(
          (m) => (m['categories'] as List<dynamic>? ?? []).map(
            (c) => c.toString(),
          ),
        )
        .expand((c) => c)
        .toSet()
        .toList();
    return cats;
  }
}
