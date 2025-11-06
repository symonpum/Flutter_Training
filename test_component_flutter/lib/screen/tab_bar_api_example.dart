import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TabBarApiExample extends StatefulWidget {
  const TabBarApiExample({Key? key}) : super(key: key);

  @override
  State<TabBarApiExample> createState() => _TabBarApiExampleState();
}

class _TabBarApiExampleState extends State<TabBarApiExample>
    with TickerProviderStateMixin {
  late Future<List<String>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<String>> _fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/categories'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => category.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tab Bar API Example')),
      body: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;
          return DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: categories.map((c) => Tab(text: c)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories
                        .map((c) => CategoryProductsView(category: c))
                        .toList(),
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

class CategoryProductsView extends StatefulWidget {
  final String category;
  const CategoryProductsView({required this.category});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView>
    with AutomaticKeepAliveClientMixin {
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProductsByCategory(widget.category);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<dynamic>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Image.network(product['image'], fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _fetchProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/category/$category'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load products for category $category');
    }
  }
}
