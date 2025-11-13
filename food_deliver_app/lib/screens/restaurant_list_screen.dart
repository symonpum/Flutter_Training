import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_screen.dart';

class NearestRestaurantScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const NearestRestaurantScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });
  // find nearest restaurant based on latitude and longitude
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Restaurants")),
      body: Center(child: Text("Your location:\n$latitude, $longitude")),
    );
  }
}

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

// fetch and display list of restaurants with search and filter

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final ValueNotifier<List<Restaurant>> _restaurants = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<String?> _error = ValueNotifier(null);
  final ValueNotifier<List<String>> _categories = ValueNotifier([]);

  String _query = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _fetch();
    _fetchCategories();
  }

  @override
  void dispose() {
    _restaurants.dispose();
    _loading.dispose();
    _error.dispose();
    _categories.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    _loading.value = true;
    _error.value = null;

    try {
      final list = await RestaurantService.instance.fetchRestaurants(
        query: _query,
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );
      _restaurants.value = list;
    } catch (e) {
      _error.value = e.toString();
      _restaurants.value = [];
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final cats = await RestaurantService.instance.fetchCategories();
      _categories.value = ['All', ...cats];
    } catch (_) {
      _categories.value = ['All'];
    }
  }

  void _onSearchChanged(String q) {
    _query = q;
    _fetch();
  }

  void _onCategorySelected(String cat) {
    _selectedCategory = cat;
    _fetch();
  }

  Future<void> _openNearest() async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever)
      return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // Navigate to nearest restaurant screen with current position
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NearestRestaurantScreen(
          latitude: pos.latitude,
          longitude: pos.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery App'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: _openNearest,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(94),
          child: _SearchAndFilterBar(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
            onSearchChanged: _onSearchChanged,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _RestaurantListBody(
          restaurants: _restaurants,
          loading: _loading,
          error: _error,
        ),
      ),
    );
  }
}

// Search and filter bar widget reuseable across screens
class _SearchAndFilterBar extends StatelessWidget {
  final ValueNotifier<List<String>> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onSearchChanged;

  const _SearchAndFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search restaurants or food...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Category filter chips using ValueListenableBuilder for reactivity
          ValueListenableBuilder<List<String>>(
            valueListenable: categories,
            builder: (context, cats, _) {
              if (cats.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = cats[i];
                    final selected = cat == selectedCategory;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) => onCategorySelected(cat),
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                      ),
                      backgroundColor: Colors.grey.shade200,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Restaurant list body widget with loading and error handling
// using ValueListenableBuilder for reactivity
// to changes in restaurants, loading, and error states
class _RestaurantListBody extends StatelessWidget {
  final ValueNotifier<List<Restaurant>> restaurants;
  final ValueNotifier<bool> loading;
  final ValueNotifier<String?> error;

  const _RestaurantListBody({
    super.key,
    required this.restaurants,
    required this.loading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<String?>(
          valueListenable: error,
          builder: (context, err, _) {
            if (err != null) return Center(child: Text('Error: $err'));
            return ValueListenableBuilder<List<Restaurant>>(
              valueListenable: restaurants,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Center(child: Text('No restaurants found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12, top: 8),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final r = list[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: RestaurantCard(
                        restaurant: r,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailScreen(restaurant: r),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
