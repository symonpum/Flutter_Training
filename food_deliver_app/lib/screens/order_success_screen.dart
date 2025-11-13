import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'order_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String restaurantName;
  final double total;
  final int deliveryTime;
  // Constructor to accept order details to display on success screen
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
      // Prevent back navigation to checkout after order is placed successfully
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
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
              const Text(
                textAlign: TextAlign.center,
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 36,
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
                // === ORDER DETAILS Card ===
                child: Column(
                  children: [
                    _detailRow(Icons.receipt, 'Order ID', orderId),
                    const Divider(height: 8),
                    _detailRow(Icons.restaurant, 'Restaurant', restaurantName),
                    const Divider(height: 8),
                    _detailRow(
                      Icons.schedule,
                      'Estimated Delivery',
                      '$deliveryTime minutes',
                    ),
                    const Divider(height: 16),
                    _detailRow(
                      Icons.payments,
                      'Total Amount',
                      '\$${total.toStringAsFixed(2)}',
                      isAmount: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    // Navigate to Order Tracking Screen
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(
                            orderId:
                                orderId, // Only pass the ID of the order to track specific order
                          ),
                        ),
                      );
                    },
                    // end navigation to Order Tracking Screen
                    icon: const Icon(Icons.track_changes),
                    label: const Text(
                      'Track Your Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Back to Home Button to clear navigation stack
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      elevation: 4,
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: Colors.green, width: 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  // Method to build each detail row for order summary section
  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 24),
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
                  fontSize: 18,
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
