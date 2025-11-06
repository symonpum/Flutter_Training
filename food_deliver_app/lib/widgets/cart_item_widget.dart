import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartLine line;

  const CartItemWidget({required this.line, super.key});

  @override
  Widget build(BuildContext context) {
    final item = line.item;

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
          // Top row: image + info + delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: const Icon(Icons.fastfood, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item name
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
                                  CartProvider().changeQuantity(item.id, -1);
                                },
                              ),

                              // Quantity display (LIVE UPDATE)
                              ValueListenableBuilder<CartProvider>(
                                valueListenable: CartProvider.instanceNotifier,
                                builder: (context, cart, _) {
                                  final currentLine = cart.getItem(item.id);
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
                                  CartProvider().changeQuantity(item.id, 1);
                                },
                              ),
                            ],
                          ),
                        ),

                        // Total price (LIVE UPDATE)
                        ValueListenableBuilder<CartProvider>(
                          valueListenable: CartProvider.instanceNotifier,
                          builder: (context, cart, _) {
                            final currentLine = cart.getItem(item.id);
                            final total = currentLine?.totalPrice ?? 0.0;

                            return Text(
                              '\${total.toStringAsFixed(2)}',
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

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  CartProvider().removeItem(item.id);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Special instructions section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit_note, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line.note?.isNotEmpty == true
                        ? line.note!
                        : 'Add special instructions',
                    style: TextStyle(
                      fontSize: 13,
                      color: line.note?.isNotEmpty == true
                          ? Colors.black87
                          : Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () => _editInstructions(context, item.id),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog to edit special instructions
  Future<void> _editInstructions(BuildContext context, String itemId) async {
    String tempNote = line.note ?? '';

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
                CartProvider().updateNote(itemId, tempNote);
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
