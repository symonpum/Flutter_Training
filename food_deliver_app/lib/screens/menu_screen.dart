import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../services/restaurant_service.dart';
import '../providers/cart_provider.dart';
import '../widgets/food_item_card.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  const MenuScreen({required this.restaurant, super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<FoodItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = RestaurantService.instance.fetchMenuForRestaurant(
      widget.restaurant.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.restaurant.name} - Menu')),
      body: FutureBuilder<List<FoodItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No items'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (c, i) {
              final it = items[i];
              return FoodItemCard(
                item: it,
                onAdd: () {
                  CartProvider().addItem(it);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder<CartProvider>(
        valueListenable: CartProvider.instanceNotifier,
        builder: (context, notifier, _) {
          final total = notifier.totalItems;
          return FloatingActionButton.extended(
            onPressed: total > 0
                ? () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const CartScreen()))
                : null,
            icon: const Icon(Icons.shopping_cart),
            label: Text('$total'),
          );
        },
      ),
    );
  }
}
