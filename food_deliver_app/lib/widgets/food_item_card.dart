import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;

  const FoodItemCard({super.key, required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left column: Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.image.isNotEmpty
                  ? Image.network(
                      item.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.fastfood,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),

            const SizedBox(width: 12),

            // Right column: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),

                  const SizedBox(height: 8),

                  // Rating + reviews + chips row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Food Modifier chips
                      Row(
                        children: [
                          if (item.isSpicy)
                            Chip(
                              label: const Text(
                                'Spicy',
                                style: TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.red.shade50,
                              labelStyle: const TextStyle(color: Colors.red),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (item.isVegetarian)
                            Chip(
                              label: const Text(
                                'Vegetarian',
                                style: TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.green.shade50,
                              labelStyle: const TextStyle(color: Colors.green),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (item.isVegan)
                            Chip(
                              label: const Text(
                                'Vegan',
                                style: TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.purple.shade50,
                              labelStyle: const TextStyle(color: Colors.purple),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),

                      // Rating + reviews
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${item.reviewCount})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Add button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(80, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
