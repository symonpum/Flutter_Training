import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product_data_model.dart';
import 'package:ecommerce_app/service/features/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartService _cartService = CartService();
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Set initial quantity to 0 if product is out of stock.
    if (widget.product.stock == 0) {
      _quantity = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      // Use ValueListenableBuilder to reactively update the UI based on cart changes.
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: _cartService.cartNotifier,
        builder: (context, cartItems, child) {
          final quantityInCart = _cartService.getQuantityInCart(
            widget.product.id,
          );
          final availableStock = widget.product.stock - quantityInCart;

          // This callback ensures that if the state becomes invalid (e.g., quantity > availableStock),
          // it's safely corrected after the build phase.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (_quantity > availableStock && availableStock > 0) {
              setState(() {
                _quantity = availableStock;
              });
            } else if (availableStock <= 0 && _quantity != 0) {
              setState(() {
                _quantity = 0;
              });
            } else if (_quantity == 0 && availableStock > 0) {
              setState(() {
                _quantity = 1;
              });
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'product_image_${widget.product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imageUrl,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 300),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormatter.format(widget.product.price),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Available to add: $availableStock (Total stock: ${widget.product.stock})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: availableStock > 0
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                _buildQuantitySelector(
                  availableStock,
                ), // New quantity selector widget
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: availableStock > 0 && _quantity > 0
                      ? () {
                          _cartService.addProductWithQuantity(
                            widget.product,
                            _quantity,
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //         'Added $_quantity of ${widget.product.name} to cart!'),
                          //     duration: const Duration(seconds: 2),
                          //     action: SnackBarAction(
                          //         label: "UNDO",
                          //         onPressed: () => _cartService
                          //             .removeProduct(widget.product.id)),
                          //   ),
                          // );
                        }
                      : null, // Disable button if no stock is available to add
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuantitySelector(int availableStock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Quantity:", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
        ),
        Text('$_quantity', style: Theme.of(context).textTheme.headlineSmall),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: _quantity < availableStock
              ? () => setState(() => _quantity++)
              : null,
        ),
      ],
    );
  }
}
