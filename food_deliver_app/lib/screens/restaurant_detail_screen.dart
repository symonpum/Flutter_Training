import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';
import '../providers/cart_provider.dart';
import '../services/restaurant_service.dart';
import '../widgets/food_item_card.dart';
import 'cart_screen.dart';
import 'reviews_screen.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(r.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          // LIVE update CART BADGE using Observer Pattern Singleton
          // with ValueListenableBuilder to listen to cart changes
          // and update badge count in real-time
          ValueListenableBuilder<List<CartLine>>(
            valueListenable: CartProvider().cartNotifier,
            builder: (context, items, _) {
              final cart = CartProvider();
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  // Show badge with total quantity of items in cart
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      //=================== RESTAURANT DETAIL BODY ====================
      // Body with FutureBuilder to load menu items
      // and display restaurant details
      // along with menu categorized in tabs
      // =============================================================
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

          // Extract categories from menu items for tabs in menu from individual food items
          _categories = menu.map((item) => item.category).toSet().toList();
          _tabController ??= TabController(
            length: _categories.length,
            vsync: this,
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner image of restaurant with error handling
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        r.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.restaurant,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + rating row of restaurant
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

                      // Restaurant description text from json data
                      Text(
                        r.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cuisine tags from restaurant data check if not empty
                      // then show horizontal list of chips
                      // for each tag available in restaurant tags list
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

                      // Delivery, preparation, minimum cards row from restaurant data
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

                      // Review chip to navigate to reviews screen with restaurant id and name
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

                      // Menu Tabs for categories extracted from menu items
                      // each tab shows list of food items in that category
                      // with add to cart button
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black54,
                        tabs: _categories.map((c) => Tab(text: c)).toList(),
                      ),

                      SizedBox(
                        height: 400,
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
                                return FoodItemCard(
                                  item: item,
                                  onAdd: () {
                                    //passing restaurant info from detail screen to cart provider when adding item to cart
                                    CartProvider().addItem(
                                      item,
                                      qty: 1,
                                      restaurantId: r.id, // Pass restaurant ID
                                      restaurantName:
                                          r.name, //  Pass restaurant name
                                      minOrder:
                                          r.minOrder, // Pass minimum order
                                    );

                                    // Show feedback snackbar on adding item to cart successfully
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${item.name} added to cart',
                                        ),
                                        duration: const Duration(
                                          milliseconds: 800,
                                        ),
                                      ),
                                    );
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
      //=================== CART FLOATING ACTION BUTTON ====================
      // floatingActionButton: ValueListenableBuilder<CartProvider>(
      //   valueListenable: CartProvider().cartNotifier,
      //   builder: (context, cart, _) {
      //     return FloatingActionButton.extended(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (_) => const CartScreen()),
      //         );
      //       },
      //       icon: const Icon(Icons.shopping_cart),
      //       label: Text('${cart.totalItems}'),
      //       backgroundColor: Colors.green,
      //     );
      //   },
      // ),
    );
  }
}

// Restuarant widgets Constructors for info cards and review chip
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

// Review chip widget to navigate to reviews screen using TextButton.icon
Widget _reviewChip(
  BuildContext context,
  String restaurantId,
  String restaurantName,
  int reviewCount,
) {
  return OutlinedButton.icon(
    onPressed: () {
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
    icon: const Icon(Icons.star_border, size: 16, color: Colors.green),
    label: Text(
      'See Reviews ($reviewCount)',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.green,
      ),
    ),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      side: BorderSide(color: Colors.grey.shade600),
      backgroundColor: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
