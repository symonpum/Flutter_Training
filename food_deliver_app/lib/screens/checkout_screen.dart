import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../models/food_item.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView(
              children: cart.items.values.map((entry) {
                final FoodItem item = entry.item;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.image),
                  ),
                  title: Text(item.name), // ✅ fixed from title → name
                  subtitle: Text(
                    '\$${item.price.toStringAsFixed(2)} x ${entry.quantity}',
                  ),
                  trailing: Text(
                    '\$${(item.price * entry.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Place order logic here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            'Place Order (\$${cart.totalPrice.toStringAsFixed(2)})',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
