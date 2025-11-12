import 'dart:convert';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final String restaurantId;

  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isSpicy;

  final double rating;
  final int reviewCount;
  final int calories;
  final int preparationTime;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.restaurantId,
    this.isAvailable = true,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isSpicy = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.calories = 0,
    this.preparationTime = 0,
  });

  // ==================== FACTORIES ====================
  factory FoodItem.fromMap(Map<String, dynamic> m) {
    return FoodItem(
      id: (m['id'] ?? '').toString(),
      name: m['name'] ?? m['title'] ?? '',
      description: m['description'] ?? '',
      price: (m['price'] is num) ? (m['price'] as num).toDouble() : 0.0,
      image: m['imageUrl'] ?? m['image'] ?? '',
      category: m['category'] ?? '',
      restaurantId: (m['restaurantId'] ?? '').toString(),
      isAvailable: m['isAvailable'] ?? true,
      isVegetarian: m['isVegetarian'] ?? false,
      isVegan: m['isVegan'] ?? false,
      isSpicy: m['isSpicy'] ?? false,
      rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : 0.0,
      reviewCount: (m['reviewCount'] is int)
          ? m['reviewCount'] as int
          : int.tryParse('${m['reviewCount']}') ?? 0,
      calories: (m['calories'] is int)
          ? m['calories'] as int
          : int.tryParse('${m['calories']}') ?? 0,
      preparationTime: (m['preparationTime'] is int)
          ? m['preparationTime'] as int
          : int.tryParse('${m['preparationTime']}') ?? 0,
    );
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      FoodItem.fromMap(json);

  static FoodItem fromJsonString(String jsonStr) =>
      FoodItem.fromJson(jsonDecode(jsonStr));

  // ==================== TO JSON ====================
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': image,
    'category': category,
    'restaurantId': restaurantId,
    'isAvailable': isAvailable,
    'isVegetarian': isVegetarian,
    'isVegan': isVegan,
    'isSpicy': isSpicy,
    'rating': rating,
    'reviewCount': reviewCount,
    'calories': calories,
    'preparationTime': preparationTime,
  };

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => jsonEncode(toJson());

  // ==================== EQUALITY ====================
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
