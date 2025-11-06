import 'package:flutter/material.dart';
import '../models/food_item.dart';

class OrderTrackingScreen extends StatelessWidget {
  final List<FoodItem> items;
  final String orderId;
  final String status;

  const OrderTrackingScreen({
    super.key,
    required this.items,
    required this.orderId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: $status',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // ✅ fixed from i.title → i.name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (i) => Text(
                      '${i.name} - \$${i.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
