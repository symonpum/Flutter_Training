import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewService {
  ReviewService._internal();
  static final ReviewService instance = ReviewService._internal();

  final String baseUrl =
      'https://unledged-temple-undebilitative.ngrok-free.dev';

  Future<List<Review>> fetchForRestaurant(String restaurantId) async {
    final url = Uri.parse('$baseUrl/reviews?restaurantId=$restaurantId');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final raw = json.decode(res.body) as List<dynamic>;
      return raw
          .map((m) => Review.fromJson(m as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load reviews: ${res.statusCode} ${res.reasonPhrase}',
      );
    }
  }

  Future<Review> postReview(Review review) async {
    final url = Uri.parse('$baseUrl/reviews');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return Review.fromJson(json.decode(res.body) as Map<String, dynamic>);
    } else {
      throw Exception(
        'Failed to post review: ${res.statusCode} ${res.reasonPhrase}',
      );
    }
  }
}
