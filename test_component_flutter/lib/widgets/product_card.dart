import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_app/model/product_data_model.dart';
import 'package:ecommerce_app/screens/product_detail.dart';
import 'package:ecommerce_app/service/features/cart_service.dart';

// GoF Pattern: Encapsulation (Part of general OOP, not a specific GoF pattern)
// This widget encapsulates the presentation logic for a single product.
// It is responsible for its own UI and interactions, making the parent widget (ProductListScreen) cleaner.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );
    final cartService = CartService();

    return Card(
      elevation: 4,
      clipBehavior: Clip
          .antiAlias, // Ensures the image respects the card's rounded corners
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'product_image_${product.id}',
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  // Error builder for gracefully handling failed image loads
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                  // Loading builder to show progress while the image is loading
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(product.price),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: product.stock > 0
                    ? () {
                        cartService.addProduct(product);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('${product.name} added to cart!'),
                        //     duration: const Duration(seconds: 2),
                        //   ),
                        // );
                      }
                    : null, // Disable button if out of stock
              ),
            ),
          ],
        ),
      ),
    );
  }
}
