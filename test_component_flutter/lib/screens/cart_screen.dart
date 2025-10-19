import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_default.dart';
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/screens/checkout_success_screen.dart';
import 'package:ecommerce_app/service/api/api_service.dart';
import 'package:ecommerce_app/service/features/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final ApiService _apiService = ApiService();
  bool _isCheckingOut = false;

  Future<void> _checkout() async {
    final itemsToCheckout = List<CartItem>.from(
      _cartService.cartNotifier.value,
    );

    if (itemsToCheckout.isEmpty) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text("Your cart is empty.")));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Checkout'),
        content: const Text(
          'Are you sure you want to proceed with your purchase?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isCheckingOut = true);

    try {
      // This is a transaction-like process. In a real app, you'd want this to be atomic on the backend.
      for (var item in itemsToCheckout) {
        final newStock = item.product.stock - item.quantity;
        await _apiService.updateProductStock(item.product.id, newStock);
        // In a real app, you might also create an "Order" record here.
      }

      // If all updates succeed, clear the cart.
      _cartService.clearCart();

      if (mounted) {
        // Navigate to the success screen and replace the cart screen in the stack.
        final checkoutResult = await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CheckoutSuccessScreen(checkedOutItems: itemsToCheckout),
          ),
        );

        // If the success screen pops with a `true` value, it means the user wants to go back
        // to a refreshed product list. We then pop the cart screen itself with that same value.
        if (checkoutResult == true && mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        // Handle any errors during the checkout process
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Checkout failed: $e. Please try again.')),
        // );
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: _cartService.cartNotifier,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty,\nchosse some products!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: Image.network(
                          item.product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                        title: Text(item.product.name),
                        subtitle: Text(
                          currencyFormatter.format(item.totalPrice),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _cartService.updateQuantity(
                                item.product.id,
                                item.quantity - 1,
                              ),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: item.quantity < item.product.stock
                                  ? () => _cartService.updateQuantity(
                                      item.product.id,
                                      item.quantity + 1,
                                    )
                                  : null, // Disable if quantity equals stock
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom checkout summary section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(_cartService.totalCost),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_isCheckingOut)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cartItems.isNotEmpty ? _checkout : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
