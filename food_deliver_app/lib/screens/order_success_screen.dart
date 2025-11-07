import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'order_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String restaurantName;
  final double total;
  final int deliveryTime;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.restaurantName,
    required this.total,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back navigation to checkout
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),

              // ✅ Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ✅ Success Message
              const Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Thank you for your order! We're preparing it with care.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 32),

              // ✅ Order Details Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _detailRow(Icons.receipt, 'Order ID', orderId),
                    const Divider(height: 16),
                    _detailRow(Icons.restaurant, 'Restaurant', restaurantName),
                    const Divider(height: 16),
                    _detailRow(
                      Icons.schedule,
                      'Estimated Delivery',
                      '$deliveryTime minutes',
                    ),
                    const Divider(height: 16),
                    _detailRow(
                      Icons.payment,
                      'Total Amount',
                      '\$${total.toStringAsFixed(2)}',
                      isAmount: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ✅ Track Order Button (filled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final cart = CartProvider();
                      final foodItems = cart.items
                          .map((line) => line.item)
                          .toList();

                      cart.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(
                            orderId: orderId,
                            items: foodItems,
                            status: 'Order Confirmed',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.track_changes),
                    label: const Text('Track Your Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Back to Home Button (outlined)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      CartProvider().clear();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Home'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.green, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper for detail rows
  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
                  color: isAmount ? Colors.green : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
