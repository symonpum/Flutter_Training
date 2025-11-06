class Review {
  final String id;
  final String restaurantId;
  final String? orderId;
  final String? userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final int helpful;
  final int foodQuality;
  final int deliverySpeed;
  final int customerService;

  Review({
    required this.id,
    required this.restaurantId,
    this.orderId,
    this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.helpful,
    required this.foodQuality,
    required this.deliverySpeed,
    required this.customerService,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      orderId: json['orderId'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      helpful: json['helpful'] ?? 0,
      foodQuality: json['foodQuality'] ?? 0,
      deliverySpeed: json['deliverySpeed'] ?? 0,
      customerService: json['customerService'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'helpful': helpful,
      'foodQuality': foodQuality,
      'deliverySpeed': deliverySpeed,
      'customerService': customerService,
    };
  }
}
