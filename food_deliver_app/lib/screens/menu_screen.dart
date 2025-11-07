import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';

// Menu Screen showing food items and allowing adding to cart
// integrates with CartProvider for live cart updates
// displays food items from a restaurant and allows adding them to the cart
class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final double minimumOrder;

  const MenuScreen({
    required this.restaurantId,
    required this.restaurantName,
    this.minimumOrder = 0.0,
    super.key,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late CartProvider _cartProvider;
  List<FoodItem> foodItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cartProvider = CartProvider();
    _loadMenuItems();
  }

  void _loadMenuItems() {
    // Simulated data - replace with actual service call
    setState(() {
      foodItems = [
        FoodItem(
          id: '1',
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato, mozzarella, and basil',
          price: 12.99,
          image: 'https://via.placeholder.com/300x300?text=Margherita+Pizza',
          restaurantId: widget.restaurantId,
          category: 'Pizza',
          rating: 4.5,
          reviewCount: 120,
        ),
        FoodItem(
          id: '2',
          name: 'Cheese Burger',
          description: 'Juicy burger with cheddar cheese, lettuce, and tomato',
          price: 8.99,
          image: 'https://via.placeholder.com/300x300?text=Cheese+Burger',
          restaurantId: widget.restaurantId,
          category: 'Burgers',
          rating: 4.3,
          reviewCount: 89,
        ),
        FoodItem(
          id: '3',
          name: 'Caesar Salad',
          description: 'Fresh romaine lettuce with Caesar dressing',
          price: 6.99,
          image: 'https://via.placeholder.com/300x300?text=Caesar+Salad',
          restaurantId: widget.restaurantId,
          category: 'Salads',
          rating: 4.2,
          reviewCount: 45,
        ),
        FoodItem(
          id: '4',
          name: 'Spaghetti Carbonara',
          description: 'Creamy pasta with bacon and parmesan',
          price: 11.99,
          image: 'https://via.placeholder.com/300x300?text=Spaghetti+Carbonara',
          restaurantId: widget.restaurantId,
          category: 'Pasta',
          rating: 4.6,
          reviewCount: 156,
        ),
      ];
      isLoading = false;
    });
  }

  void _addToCart(FoodItem food) {
    // FoodItem object (not individual fields)
    _cartProvider.addItem(
      food,
      qty: 1,
      restaurantId: widget.restaurantId,
      restaurantName: widget.restaurantName,
      minOrder: widget.minimumOrder,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _cartProvider.removeItem(food.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          // Cart Icon Badge - LIVE UPDATE
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ValueListenableBuilder<CartProvider>(
              valueListenable: CartProvider.instanceNotifier,
              builder: (context, cart, _) {
                final itemCount = cart.itemCount;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Food Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            food.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.fastfood, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Food Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                food.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${food.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    onPressed: () => _addToCart(food),
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
