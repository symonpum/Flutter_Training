import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/food_item.dart';
import '../services/order_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  // --- LOGIC FIX: REMOVED items AND status ---
  // final List<FoodItem> items;
  // final String status;

  const OrderTrackingScreen({
    required this.orderId,
    // required this.items, // Removed
    // required this.status, // Removed
    super.key,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Future<Order?> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = OrderService.getOrderById(widget.orderId);
  }

  // (Your helper methods)
  int _getProgressPercentage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 20;
      case OrderStatus.preparing:
        return 40;
      // === FIXED: Added 'pickedUp' ===
      case OrderStatus.pickedUp:
        return 60;
      case OrderStatus.enroute:
        return 80;
      case OrderStatus.delivered:
        return 100;
      case OrderStatus.cancelled:
        return 0;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Food';
      // === FIXED: Added 'pickedUp' ===
      case OrderStatus.pickedUp:
        return 'Ready for Pickup';
      case OrderStatus.enroute:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.pending:
        return 'Pending';
    }
  }

  void _showCancelDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await _cancelOrder(order);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder(Order order) async {
    try {
      await OrderService.updateOrderStatus(order.id, OrderStatus.cancelled);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order cancelled successfully'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _orderFuture = OrderService.getOrderById(widget.orderId);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to cancel order: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Tracking',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // --- LOGIC FIX: Use FutureBuilder ---
      body: FutureBuilder<Order?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green.shade600),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Error loading order: ${snapshot.error}'),
            );
          }

          // --- LOGIC FIX: Get order from snapshot ---
          final order = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCurrentStatusCard(order),
                _buildOrderProgressCard(order),
                _buildOrderDetailsCard(order),
                _buildOrderItemsCard(order),
                _buildCancelOrderButton(order),
                _buildNeedHelpButton(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== CURRENT STATUS CARD ====================
  Widget _buildCurrentStatusCard(Order order) {
    final isDelivered = order.status == OrderStatus.delivered;
    final isCancelled = order.status == OrderStatus.cancelled;

    // A check for a potential asset error
    String imageAsset = 'assets/icons/preparing.png';
    Widget iconWidget;

    if (isCancelled) {
      iconWidget = Icon(Icons.close, size: 50, color: Colors.red);
    } else if (isDelivered) {
      iconWidget = Icon(Icons.check_circle, size: 50, color: Colors.green);
    } else {
      // Fallback for asset
      iconWidget = Image.asset(
        imageAsset,
        width: 50,
        height: 50,
        errorBuilder: (_, __, ___) => Icon(
          Icons.restaurant, // Fallback icon
          size: 50,
          color: Colors.orange,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isCancelled
                  ? Colors.red.shade50
                  : isDelivered
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(height: 16),
          Text(
            isCancelled
                ? 'Cancelled'
                : isDelivered
                ? 'Delivered'
                : _getStatusLabel(order.status),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isCancelled
                  ? Colors.red
                  : isDelivered
                  ? Colors.green
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isCancelled
                ? 'Order has been cancelled'
                : isDelivered
                ? 'Your order has been delivered'
                : 'Restaurant confirmed your order',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            // Using createdTime as a fallback for estimated time
            'Order Time: ${_formatTime(order.createdAt)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ORDER PROGRESS CARD ====================
  Widget _buildOrderProgressCard(Order order) {
    final progressPercent = _getProgressPercentage(order.status);
    final isCancelled = order.status == OrderStatus.cancelled;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: isCancelled ? 0 : progressPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCancelled ? Colors.red : Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildStatusStep(
                'Order Confirmed',
                order.status,
                OrderStatus.confirmed,
              ),
              _buildStatusStep(
                'Preparing Food',
                order.status,
                OrderStatus.preparing,
              ),
              // === FIXED: Kept your 5-step UI ===
              _buildStatusStep(
                'Ready for Pickup',
                order.status,
                OrderStatus.pickedUp,
              ),
              _buildStatusStep(
                'Out for Delivery',
                order.status,
                OrderStatus.enroute,
              ),
              _buildStatusStep(
                'Delivered',
                order.status,
                OrderStatus.delivered,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(
    String label,
    OrderStatus currentStatus,
    OrderStatus stepStatus,
  ) {
    final isCompleted = _isStatusCompleted(currentStatus, stepStatus);
    final isCurrent = currentStatus == stepStatus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                size: 18,
                color: isCompleted ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              color: isCompleted ? Colors.green : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  bool _isStatusCompleted(OrderStatus current, OrderStatus step) {
    // === FIXED: Updated logic to use the 5-step enum ===
    final statusOrder = [
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.pickedUp,
      OrderStatus.enroute,
      OrderStatus.delivered,
    ];
    final currentIndex = statusOrder.indexOf(current);
    final stepIndex = statusOrder.indexOf(step);

    // Handle edge cases like 'pending' or 'cancelled'
    if (current == OrderStatus.cancelled) return false;
    if (stepIndex == -1) return false; // Step not in the flow
    if (currentIndex == -1) {
      // Current status is not in the flow (e.g., pending)
      return false;
    }

    return stepIndex <= currentIndex;
  }

  // ==================== ORDER DETAILS CARD ====================
  Widget _buildOrderDetailsCard(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _detailRow('Order ID', order.id),
          const SizedBox(height: 12),
          _detailRow('Restaurant', order.restaurantName ?? 'N/A'),
          const SizedBox(height: 12),
          _detailRow('Order Time', _formatTime(order.createdAt)),
          const SizedBox(height: 12),
          _detailRow('Delivery Address', order.deliveryAddress.line1),
          const SizedBox(height: 12),
          // Your Order model doesn't have paymentMethod, grabbing from db.json example
          _detailRow('Payment Method', 'Visa ending in 1234'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ==================== ORDER ITEMS CARD ====================
  Widget _buildOrderItemsCard(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // --- LOGIC FIX: 'item' is the FoodItem ---
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quantity chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Text(
                            'x${item.quantity ?? 1}', // Use item.quantity
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Item name
                        Expanded(
                          child: Text(
                            item.name, // Use item.name
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Item total
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}', // Use item.totalPrice
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 12),

          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== CANCEL ORDER BUTTON ====================
  Widget _buildCancelOrderButton(Order order) {
    final canCancel =
        order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: canCancel ? Colors.red : Colors.grey.shade400,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: canCancel ? Colors.red : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          onPressed: canCancel ? () => _showCancelDialog(order) : null,
          child: const Text(
            'Cancel Order',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ==================== NEED HELP BUTTON ====================
  Widget _buildNeedHelpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact support: +1-800-FOOD-APP')),
          ),
          child: const Text(
            'Need Help?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ==================== HELPERS ====================
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
