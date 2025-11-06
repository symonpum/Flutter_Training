import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';
import '../screens/reviews_screen.dart';
import '../services/restaurant_service.dart';
import '../widgets/food_item_card.dart';
import '../screens/reviews_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<FoodItem>> _menuFuture;
  TabController? _tabController;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _menuFuture = RestaurantService.instance.fetchMenuForRestaurant(
      widget.restaurant.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return Scaffold(
      appBar: AppBar(
        title: Text(r.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<FoodItem>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading menu: ${snapshot.error}'));
          }
          final menu = snapshot.data ?? [];
          if (menu.isEmpty) {
            return const Center(child: Text('No menu items available'));
          }

          // Extract categories from menu items
          _categories = menu.map((item) => item.category).toSet().toList();
          _tabController ??= TabController(
            length: _categories.length,
            vsync: this,
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner image
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    r.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.restaurant,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              r.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  r.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      //Restaurant description
                      Text(
                        r.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cuisine tags
                      if (r.tags.isNotEmpty)
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: r.tags.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final cat = r.tags[index];
                              return Chip(
                                label: Text(
                                  cat,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: Colors.grey.shade100,
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Delivery, prepareation , minimum cards
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _infoCard(
                                icon: Icons.access_time,
                                label: 'Delivery Time',
                                value: '${r.deliveryMinutes} min',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _infoCard(
                                icon: Icons.delivery_dining,
                                label: 'Delivery Fee',
                                value: '\$${r.deliveryFee.toStringAsFixed(2)}',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _infoCard(
                                icon: Icons.shopping_bag,
                                label: 'Minimum Order',
                                value: '\$${r.minOrder.toStringAsFixed(2)}',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Review chip
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _reviewChip(
                            context,
                            r.id,
                            r.name,
                            r.reviewCount,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Menu Tabs
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black54,
                        tabs: _categories.map((c) => Tab(text: c)).toList(),
                      ),

                      SizedBox(
                        height: 400, // fixed height for TabBarView
                        child: TabBarView(
                          controller: _tabController,
                          children: _categories.map((cat) {
                            final items = menu
                                .where((item) => item.category == cat)
                                .toList();
                            return ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                // FoodItemCards
                                return FoodItemCard(
                                  item: item,
                                  onAdd: () {
                                    // Add to cart logic
                                    //_addItemToCart(item, cartProvider);
                                    //
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Restuarant widgets Constructors
Widget _infoCard({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: Colors.green),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _reviewChip(
  BuildContext context,
  String restaurantId,
  String restaurantName,
  int reviewCount,
) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReviewsScreen(
            restaurantId: restaurantId,
            restaurantName: restaurantName,
          ),
        ),
      );
    },
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_border, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Text(
            'See Reviews ($reviewCount)',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ],
      ),
    ),
  );
}
