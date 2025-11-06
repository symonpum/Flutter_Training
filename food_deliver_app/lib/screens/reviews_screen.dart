import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ReviewsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Review>> _reviewsFuture;
  late TabController _tabController;

  double _selectedRating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _loadReviews() {
    setState(() {
      _reviewsFuture = ReviewService.instance.fetchForRestaurant(
        widget.restaurantId,
      );
    });
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0 || _controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide rating and comment')),
      );
      return;
    }

    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      restaurantId: widget.restaurantId,
      orderId: null,
      userId: 'user_1',
      userName: 'Anonymous',
      rating: _selectedRating,
      comment: _controller.text,
      createdAt: DateTime.now(),
      helpful: 0,
      foodQuality: _selectedRating.toInt(),
      deliverySpeed: _selectedRating.toInt(),
      customerService: _selectedRating.toInt(),
    );

    await ReviewService.instance.postReview(newReview);
    _controller.clear();
    setState(() {
      _selectedRating = 0;
    });
    _tabController.animateTo(0);
    _loadReviews();
  }

  List<Widget> _buildStars(double rating, {double size = 20}) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;
    return List.generate(5, (i) {
      if (i < fullStars) {
        return Icon(Icons.star, color: Colors.orange, size: size);
      } else if (i == fullStars && hasHalfStar) {
        return Icon(Icons.star_half, color: Colors.orange, size: size);
      } else {
        return Icon(Icons.star_border, color: Colors.orange, size: size);
      }
    });
  }

  String _getRatingLabel(double rating) {
    if (rating <= 1.5) return 'Poor';
    if (rating <= 2.5) return 'Fair';
    if (rating <= 3.5) return 'Good';
    if (rating <= 4.5) return 'Very Good';
    return 'Excellent';
  }

  Widget _buildReviewCard(Review review) {
    final daysAgo = DateTime.now().difference(review.createdAt).inDays;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green,
              child: Text(
                review.userName.isNotEmpty
                    ? review.userName[0].toUpperCase()
                    : 'A',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(children: _buildStars(review.rating, size: 18)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    daysAgo == 0
                        ? 'Today'
                        : daysAgo == 1
                        ? '1 day ago'
                        : '$daysAgo days ago',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(review.comment),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Helpful (${review.helpful})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdown(List<Review> reviews) {
    final breakdown = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      final star = r.rating.round().clamp(1, 5);
      breakdown[star] = (breakdown[star] ?? 0) + 1;
    }
    final total = reviews.length;

    final entries = breakdown.entries.toList().reversed;

    return Column(
      children: entries.map((entry) {
        final fraction = total > 0 ? entry.value / total : 0.0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                child: Text(
                  '${entry.key}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.star, color: Colors.orange, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: LinearProgressIndicator(
                  value: fraction,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.orange,
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 16,
                child: Text(
                  '${entry.value}',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews - ${widget.restaurantName}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Reviews'),
            Tab(text: 'Write Review'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Reviews tab
          FutureBuilder<List<Review>>(
            future: _reviewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading reviews: ${snapshot.error}'),
                );
              }

              final reviews = snapshot.data ?? [];
              final avgRating = reviews.isEmpty
                  ? 0.0
                  : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                        reviews.length;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Rating Summary Section
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column: Large rating display (like a circle)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(children: _buildStars(avgRating, size: 24)),
                              const SizedBox(height: 8),
                              Text(
                                '${reviews.length} reviews',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          // Right column: Rating breakdown
                          Expanded(child: _buildBreakdown(reviews)),
                        ],
                      ),
                    ),

                    // Write Review button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _tabController.animateTo(1),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'Write a Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // List of reviews
                    Column(
                      children: reviews.isEmpty
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'No reviews yet',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ]
                          : reviews.map(_buildReviewCard).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),

          // Write Review tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rate your experience',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap a star to rate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final isSelected = i < _selectedRating;
                            return IconButton(
                              icon: Icon(
                                isSelected ? Icons.star : Icons.star_border,
                                color: Colors.orange,
                                size: 40,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedRating = (i + 1).toDouble();
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedRating > 0)
                          Text(
                            _getRatingLabel(_selectedRating),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Write your review',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText: 'Write your review',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
