import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: ValueListenableBuilder<CartProvider>(
        valueListenable: CartProvider.instanceNotifier,
        builder: (context, cart, _) {
          final items = cart.items;
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final line = items[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CartItemWidget(line: line),
                        if (line.note != null || line.note == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit_note,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    line.note?.isNotEmpty == true
                                        ? 'Instructions: ${line.note}'
                                        : 'Add special instructions',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: line.note?.isNotEmpty == true
                                          ? Colors.black87
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final result = await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        String tempNote = line.note ?? '';
                                        return AlertDialog(
                                          title: const Text(
                                            'Edit Instructions',
                                          ),
                                          content: TextField(
                                            autofocus: true,
                                            maxLines: 3,
                                            controller: TextEditingController(
                                              text: tempNote,
                                            ),
                                            onChanged: (val) => tempNote = val,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter instructions...',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                cart.addItem(
                                                  line.item,
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
                              ],
                            ),
                          ),
                        const Divider(height: 24),
                      ],
                    );
                  },
                ),
              ),

              // Cost breakdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _costRow('Subtotal', cart.subtotal),
                    _costRow('Delivery Fee', 2.40),
                    _costRow('Tax & Fees', 2.97),
                    const Divider(height: 24),
                    _costRow(
                      'Total',
                      cart.subtotal + 2.40 + 2.97,
                      isBold: true,
                    ),
                  ],
                ),
              ),

              // Checkout button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // TODO: implement checkout logic
                    },
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _costRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
