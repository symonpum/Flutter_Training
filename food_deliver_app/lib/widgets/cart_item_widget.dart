import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

// Cart item widget - displays individual cart item with quantity controls, total price, and special instructions
// Listens to CartProvider for live updates using Singleton & Observer pattern
class CartItemWidget extends StatefulWidget {
  final CartLine cartLine;

  const CartItemWidget({required this.cartLine, super.key});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    _cartProvider = CartProvider();
    // Listen to cart changes
    _cartProvider.cartNotifier.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartProvider.cartNotifier.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.cartLine.item;
    final foodId = item.id;

    // Get the latest cart line from provider
    final currentLine = _cartProvider.getItem(foodId);
    final displayNote = currentLine?.note;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: image + info + delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Food image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Food Name + Delete Button (aligned right)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            CartProvider().removeItem(foodId);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Price per item
                    Text(
                      '\$${item.price.toStringAsFixed(2)} each',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quantity controls + Total price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity box with +/- buttons
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              // Minus button
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                onPressed: () {
                                  CartProvider().changeQuantity(foodId, -1);
                                },
                              ),

                              // Quantity display (LIVE UPDATE)
                              ValueListenableBuilder<List<CartLine>>(
                                valueListenable: _cartProvider.cartNotifier,
                                builder: (context, cartItems, _) {
                                  final currentLine = _cartProvider.getItem(
                                    foodId,
                                  );
                                  final qty = currentLine?.quantity ?? 0;

                                  return SizedBox(
                                    width: 50,
                                    child: Text(
                                      '$qty',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Plus button
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                onPressed: () {
                                  CartProvider().changeQuantity(foodId, 1);
                                },
                              ),
                            ],
                          ),
                        ),

                        // Total price (LIVE UPDATE)
                        ValueListenableBuilder<List<CartLine>>(
                          valueListenable: _cartProvider.cartNotifier,
                          builder: (context, cartItems, _) {
                            final currentLine = _cartProvider.getItem(foodId);
                            final total = currentLine?.totalPrice ?? 0.0;

                            return Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Special instructions section
          if (displayNote != null && displayNote.isNotEmpty)
            // Show saved instructions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Special Instructions:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    displayNote,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _editInstructions(context, foodId),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Edit Instructions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            // Show add instructions button
            GestureDetector(
              onTap: () => _editInstructions(context, foodId),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, size: 18, color: Colors.green.shade600),
                    const SizedBox(width: 6),
                    Text(
                      'Add Instructions',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Show dialog to edit special instructions
  Future<void> _editInstructions(BuildContext context, String foodId) async {
    final currentLine = _cartProvider.getItem(foodId);
    String tempNote = currentLine?.note ?? '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Special Instructions'),
          content: TextField(
            autofocus: true,
            maxLines: 4,
            maxLength: 200,
            controller: TextEditingController(text: tempNote),
            onChanged: (val) => tempNote = val,
            decoration: const InputDecoration(
              hintText: 'Enter special requests...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                CartProvider().updateNote(foodId, tempNote);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
