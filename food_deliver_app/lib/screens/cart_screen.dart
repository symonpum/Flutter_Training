import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CartProvider>(
      valueListenable: CartProvider.instanceNotifier,
      builder: (context, notifier, _) {
        final lines = notifier.items;
        return Scaffold(
          appBar: AppBar(title: const Text('Cart')),
          body: lines.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView(
                  children: [
                    ...lines.map((l) => CartItemWidget(line: l)).toList(),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal: \$${notifier.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          ElevatedButton(
                            onPressed: notifier.subtotal > 0
                                ? () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const CheckoutScreen(),
                                    ),
                                  )
                                : null,
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
