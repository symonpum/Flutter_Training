import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final dynamic line;
  const CartItemWidget({required this.line, super.key});

  @override
  Widget build(BuildContext context) {
    final item = line.item;
    return ListTile(
      leading: Image.network(
        item.image,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
      ),
      title: Text(item.title),
      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () =>
                CartProvider.instanceNotifier.value.changeQuantity(item.id, -1),
            icon: const Icon(Icons.remove),
          ),
          Text('${line.quantity}'),
          IconButton(
            onPressed: () =>
                CartProvider.instanceNotifier.value.changeQuantity(item.id, 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
