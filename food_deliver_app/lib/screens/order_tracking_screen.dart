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
              'Order Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _statusStep('Order Confirmed', true),
            _statusStep(
              'Preparing Food',
              status == 'Preparing' ||
                  status == 'Out for Delivery' ||
                  status == 'Delivered',
            ),
            _statusStep(
              'Out for Delivery',
              status == 'Out for Delivery' || status == 'Delivered',
            ),
            _statusStep('Delivered', status == 'Delivered'),

            const SizedBox(height: 24),

            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final i = items[index];
                  return ListTile(
                    leading: const Icon(Icons.fastfood, color: Colors.green),
                    title: Text(i.name),
                    subtitle: Text('\$${i.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support not implemented yet'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Contact Support'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _statusStep(String label, bool completed) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
