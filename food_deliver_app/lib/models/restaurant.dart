import 'food_item.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final double rating;
  final int reviewCount;
  final int deliveryMinutes;
  final double deliveryFee;
  final double minOrder;
  final List<String> tags; // categories from db.json
  final bool isOpen;
  final List<FoodItem> menu;

  // Location
  final double lat;
  final double lng;

  // Extra fields
  final String phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.deliveryMinutes,
    required this.deliveryFee,
    required this.minOrder,
    this.tags = const [],
    this.isOpen = true,
    this.menu = const [],
    this.lat = 0.0,
    this.lng = 0.0,
    this.phoneNumber = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Restaurant.fromMap(Map<String, dynamic> m) {
    final categories =
        (m['categories'] as List<dynamic>?)
            ?.map((c) => c.toString())
            .toList() ??
        [];

    return Restaurant(
      id: (m['id'] ?? '').toString(),
      name: m['name'] ?? '',
      description: m['description'] ?? '',
      imageUrl: (m['imageUrl'] ?? m['image'] ?? '').toString(),
      address: m['address'] ?? '',
      rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : 0.0,
      reviewCount: (m['reviewCount'] is int)
          ? m['reviewCount'] as int
          : int.tryParse('${m['reviewCount']}') ?? 0,
      deliveryMinutes: (m['deliveryTime'] is int)
          ? m['deliveryTime'] as int
          : int.tryParse('${m['deliveryTime']}') ?? 0,
      deliveryFee: (m['deliveryFee'] is num)
          ? (m['deliveryFee'] as num).toDouble()
          : double.tryParse('${m['deliveryFee']}') ?? 0.0,
      minOrder: (m['minimumOrder'] is num)
          ? (m['minimumOrder'] as num).toDouble()
          : double.tryParse('${m['minimumOrder']}') ?? 0.0,
      tags: categories,
      isOpen: m['isOpen'] == null
          ? true
          : (m['isOpen'] == true ||
                m['isOpen'].toString().toLowerCase() == 'true'),
      menu:
          (m['menu'] as List<dynamic>?)
              ?.map((e) => FoodItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      lat: (m['latitude'] is num) ? (m['latitude'] as num).toDouble() : 0.0,
      lng: (m['longitude'] is num) ? (m['longitude'] as num).toDouble() : 0.0,
      phoneNumber: m['phoneNumber'] ?? '',
      createdAt: m['createdAt'] != null
          ? DateTime.tryParse(m['createdAt'])
          : null,
      updatedAt: m['updatedAt'] != null
          ? DateTime.tryParse(m['updatedAt'])
          : null,
    );
  }
}
