import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'location_picker_screen.dart';
import 'order_success_screen.dart';
import '../models/address.dart';
import 'checkout_screen.dart';

// LocationNotifier is a simple ChangeNotifier to hold the selected address globally.
class LocationNotifier extends ChangeNotifier {
  static final LocationNotifier instance = LocationNotifier._internal();
  LocationNotifier._internal();

  Address? _address;
  Address? get address => _address;

  void setAddress(Address newAddress) {
    _address = newAddress;
    notifyListeners();
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CartProvider _cart;
  final TextEditingController _instructionsController = TextEditingController();
  String _selectedPayment = 'credit_card';

  Address? _selectedAddress; // <- store selected address

  @override
  void initState() {
    super.initState();
    _cart = CartProvider();
    _selectedAddress =
        LocationNotifier.instance.address; // load initial address if any
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _pickAddress() async {
    final result = await Navigator.push<Address?>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
    if (result != null) {
      setState(() {
        _selectedAddress = result;
      });
      LocationNotifier.instance.setAddress(result); // save globally
    }
  }

  void _placeOrder() {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(height: 16),
              Text('Placing order...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      final orderId =
          'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(
            orderId: orderId,
            restaurantName: _cart.restaurantName ?? 'Restaurant',
            total: _cart.total,
            deliveryTime: 29,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<CartProvider>(
        valueListenable: CartProvider.instanceNotifier,
        builder: (context, cart, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Order Summary Card (same as before)
                // ... keep existing code for order summary

                // Delivery Address Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickAddress,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedAddress != null
                                ? '${_selectedAddress!.line1}, ${_selectedAddress!.city}, ${_selectedAddress!.region}'
                                : 'Tap to select delivery address',
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedAddress != null
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Payment Section (same)
                // Special Instructions Section (same)
                // Place Order Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Place Order • \$${cart.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
