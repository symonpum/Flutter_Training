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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top row: image + info + delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.fastfood, size: 40),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(2)} each',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Quantity box + Total price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  CartProvider.instanceNotifier.value
                                      .changeQuantity(item.id, -1);
                                },
                              ),
                              Text(
                                '${line.quantity}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  CartProvider.instanceNotifier.value
                                      .changeQuantity(item.id, 1);
                                },
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${line.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  CartProvider.instanceNotifier.value.removeItem(item.id);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Special instructions: full-width disabled field
          TextField(
            controller: TextEditingController(text: line.note ?? ''),
            enabled: false,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'No instructions',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            ),
            style: const TextStyle(fontSize: 13),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                String tempNote = line.note ?? '';
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Edit Instructions'),
                      content: TextField(
                        autofocus: true,
                        maxLines: 3,
                        controller: TextEditingController(text: tempNote),
                        onChanged: (val) => tempNote = val,
                        decoration: const InputDecoration(
                          hintText: 'Enter instructions...',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            CartProvider.instanceNotifier.value.addItem(
                              item,
                              qty: 0,
                              note: tempNote,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }
}
