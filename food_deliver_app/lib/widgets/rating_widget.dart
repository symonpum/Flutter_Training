import 'package:flutter/material.dart';
import '../models/review.dart';

class RatingWidget extends StatelessWidget {
  final double averageRating;
  final int reviewCount;
  final List<Review> reviews;
  final VoidCallback onWriteReview;

  const RatingWidget({
    super.key,
    required this.averageRating,
    required this.reviewCount,
    required this.reviews,
    required this.onWriteReview,
  });

  Map<int, int> _calculateBreakdown() {
    final Map<int, int> breakdown = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      final star = r.rating.round().clamp(1, 5);
      breakdown[star] = (breakdown[star] ?? 0) + 1;
    }
    return breakdown;
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

  @override
  Widget build(BuildContext context) {
    final breakdown = _calculateBreakdown();

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Average rating section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(children: _buildStars(averageRating, size: 22)),
                const SizedBox(height: 6),
                Text(
                  '$reviewCount reviews',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Star breakdown chart (reversed order)
            Column(
              children: breakdown.entries.toList().reversed.map((entry) {
                final star = entry.key;
                final count = entry.value;
                final fraction = reviewCount > 0 ? count / reviewCount : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star ★', style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: fraction,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.green,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('$count', style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Reviews list
            if (reviews.isNotEmpty)
              Column(
                children: reviews.map((review) {
                  final daysAgo = DateTime.now()
                      .difference(review.createdAt)
                      .inDays;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row: name + stars + rating + date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: _buildStars(
                                      review.rating,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    review.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                  );
                }).toList(),
              )
            else
              const Text(
                'No reviews yet',
                style: TextStyle(color: Colors.black54),
              ),

            const SizedBox(height: 12),

            // Write review button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onWriteReview,
                icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                label: const Text(
                  'Write a Review',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
