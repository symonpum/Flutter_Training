import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Add geolocator import to use location services in pubspec.yaml

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

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final ValueNotifier<List<Restaurant>> _restaurants =
      ValueNotifier<List<Restaurant>>([]);
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _error = ValueNotifier<String?>(null);
  final ValueNotifier<List<String>> _categories = ValueNotifier<List<String>>(
    [],
  );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10, // for shadow effect
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,

        /// TITLE and Location Icon
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Food Delivery App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              onPressed: () async {
                final perm = await Geolocator.requestPermission();
                if (perm == LocationPermission.denied ||
                    perm == LocationPermission.deniedForever) {
                  return;
                }

                final pos = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NearestRestaurantScreen(
                      latitude: pos.latitude,
                      longitude: pos.longitude,
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(94),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              children: [
                TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search restaurants or food...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<List<String>>(
                  valueListenable: _categories,
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
                          final selected = cat == _selectedCategory;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (_) => _onCategorySelected(cat),
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
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _loading,
              builder: (context, loading, _) {
                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ValueListenableBuilder<String?>(
                  valueListenable: _error,
                  builder: (context, error, _) {
                    if (error != null) {
                      return Center(child: Text('Error: $error'));
                    }
                    return ValueListenableBuilder<List<Restaurant>>(
                      valueListenable: _restaurants,
                      builder: (context, list, _) {
                        if (list.isEmpty) {
                          return const Center(
                            child: Text('No restaurants found'),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 12, top: 8),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final r = list[index];
                            return RestaurantCard(
                              restaurant: r,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RestaurantDetailScreen(restaurant: r),
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
            ),
          ),
        ],
      ),
    );
  }
}
