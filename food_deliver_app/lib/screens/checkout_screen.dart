import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/cart_provider.dart';
import '../models/address.dart';
import '../widgets/mini_map_widget.dart';
import 'location_picker_screen.dart';
import 'order_success_screen.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../services/order_service.dart';
import '../widgets/location_selector.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CartProvider _cartProvider;
  String? _selectedAddressString; // Use your variable
  String? _selectedPaymentMethod;
  String _specialInstructions = '';
  late LatLng _deliveryLocation;

  // full address object to be used in the Order
  late Address _deliveryAddressFull;
  bool _isPlacingOrder = false;

  // ==================== INITIAL STATE ====================

  @override
  void initState() {
    super.initState();
    _cartProvider = CartProvider();
    _selectedPaymentMethod = 'visa_1234'; // Default payment

    // Set default address hardcoded ---
    _selectedAddressString = '#24, St#1, Dangkao, Phnom Penh 120501';
    _deliveryLocation = const LatLng(11.51444408914312, 104.88575723841052);

    // Create the full Address object ---
    _deliveryAddressFull = Address(
      id: 'addr_default',
      line1: _selectedAddressString!,
      city: 'Dangkao',
      region: 'Phnom Penh',
      postalCode: '120501',
      lat: _deliveryLocation.latitude,
      lng: _deliveryLocation.longitude,
    );
    // ------------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOrderSummary(),
            _buildDeliveryAddressSection(context),
            _buildPaymentMethodSection(),
            _buildSpecialInstructionsSection(),
            _buildPlaceOrderButton(), // This button will now call the real logic
          ],
        ),
      ),
    );
  }

  // ==================== ORDER SUMMARY ====================
  Widget _buildOrderSummary() {
    return ValueListenableBuilder<List<CartLine>>(
      valueListenable: _cartProvider.cartNotifier,
      builder: (context, items, _) {
        final subtotal = _cartProvider.subtotal;
        final tax = _cartProvider.tax;
        final deliveryFee = _cartProvider.deliveryFee;
        final platformFee = _cartProvider.platformFee;
        final total = _cartProvider.total;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.grey.shade400, thickness: 1),
              const SizedBox(height: 8),
              Text(
                _cartProvider.restaurantName ?? 'Restaurant',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // List of items
              ...items.map((line) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${line.quantity}x ${line.item.name}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${line.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Divider(color: Colors.grey.shade400, thickness: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Delivery Fee',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '\$${deliveryFee.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tax & Fees',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '\$${(tax + platformFee).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade400, thickness: 2),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== DELIVERY ADDRESS SECTION ====================
  Widget _buildDeliveryAddressSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedAddressString ?? 'No address selected',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
                  onPressed: _navigateToLocationPicker, // Use helper
                ),
              ],
            ),
          ),
          MiniMapWidget(
            initialLocation: _deliveryLocation,
            interactive: true,
            onLocationChanged: (LatLng newLocation) {
              setState(() {
                _deliveryLocation = newLocation;
                // Update the full address object's lat/lng
                _deliveryAddressFull = _deliveryAddressFull.copyWith(
                  lat: newLocation.latitude,
                  lng: newLocation.longitude,
                );
              });
            },
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _navigateToLocationPicker, // Use helper
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.my_location, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Use Current Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
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

  // --- HELPER FOR NAVIGATION ---
  void _navigateToLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // Pass the current full address to the picker
        builder: (_) =>
            LocationPickerScreen(initialAddress: _deliveryAddressFull),
      ),
    );

    if (result != null && result is Address) {
      setState(() {
        // Update both the string for the UI and the full object
        _selectedAddressString = result.line1;
        _deliveryAddressFull = result;
        _deliveryLocation = LatLng(result.lat, result.lng);
      });
    }
  }

  // ==================== PAYMENT METHOD SECTION ====================
  Widget _buildPaymentMethodSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.payment, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                onPressed: _addPaymentDialog, // Call the method directly
                child: const Text(
                  '+ Add',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            'visa_1234',
            'Visa ending in 1234',
            'Default',
            Icons.credit_card,
          ),
          _buildPaymentOption(
            'mastercard_5678',
            'Mastercard ending in 5678',
            null,
            Icons.credit_card,
          ),
        ],
      ),
    );
  }

  //Payment Option Widget
  Widget _buildPaymentOption(
    String id,
    String title,
    String? subtitle,
    IconData icon,
  ) {
    // Highlight if selected option
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedPaymentMethod == id
                ? Colors.green.shade100
                : Colors.white,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: id,
              groupValue: _selectedPaymentMethod,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            Icon(icon, color: Colors.grey, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
            Icon(Icons.edit, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  // ==================== SPECIAL INSTRUCTIONS SECTION ====================
  Widget _buildSpecialInstructionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.note, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Special Instructions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            maxLength: 200,
            onChanged: (value) {
              _specialInstructions = value;
            },
            decoration: InputDecoration(
              hintText: 'Any special requests for your order?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PLACE ORDER BUTTON ====================
  Widget _buildPlaceOrderButton() {
    return ValueListenableBuilder<List<CartLine>>(
      valueListenable: _cartProvider.cartNotifier,
      builder: (context, items, _) {
        final total = _cartProvider.total;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              //If the order is being placed, disable the button
              onPressed: _isPlacingOrder
                  ? null
                  : _handlePlaceOrder, //call the real logic from method
              child: _isPlacingOrder
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      'Place Order • \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              // --------------------
            ),
          ),
        );
      },
    );
  }

  // Hanlde Place Order Logic
  Future<void> _handlePlaceOrder() async {
    if (_cartProvider.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
      return;
    }
    // Set loading state
    setState(() => _isPlacingOrder = true);

    try {
      // Get items with quantities from the CartProvider
      final orderItems = _cartProvider.toOrderFoodItems();

      // Build the new Order object for submission
      final newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantId: _cartProvider.restaurantId,
        restaurantName: _cartProvider.restaurantName,
        items: orderItems,
        deliveryAddress: _deliveryAddressFull, // Use full Address object
        subtotal: _cartProvider.subtotal,
        deliveryFee: _cartProvider.deliveryFee,
        total: _cartProvider.total,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      // Call the OrderService to create the order
      final placedOrder = await OrderService.createOrder(newOrder);

      // Set the new order as 'current' in the OrderProvider
      OrderProvider().setCurrent(placedOrder);

      // Clear the cart after successful order placement
      _cartProvider.clear();

      // Navigate to Success Screen with final real data
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(
              orderId: placedOrder.id,
              restaurantName: placedOrder.restaurantName ?? 'Restaurant',
              deliveryTime:
                  30, // Now use Hardcode, will make dynamic later from JSON
              total: placedOrder.total,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  // ==================== ADD PAYMENT DIALOG ====================
  void _addPaymentDialog() {
    final formKey = GlobalKey<FormState>();
    String cardholderName = '';
    String cardNumber = '';
    String expiryDate = '';
    String cvv = '';
    // Show Dialog when pressed the Add button
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add New Card',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Cardholder Name',
                        hintText: 'Symon PUM',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter cardholder name';
                        }
                        return null;
                      },
                      onChanged: (value) => cardholderName = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter card number';
                        }
                        if (value!.replaceAll(' ', '').length != 16) {
                          return 'Card number must be 16 digits';
                        }
                        return null;
                      },
                      onChanged: (value) => cardNumber = value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'Expiry',
                              hintText: 'MM/YY',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Required';
                              }
                              return null;
                            },
                            onChanged: (value) => expiryDate = value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'CVV',
                              hintText: '123',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Required';
                              }
                              if (value!.length < 3) {
                                return 'Invalid';
                              }
                              return null;
                            },
                            onChanged: (value) => cvv = value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Card added successfully!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Add Card',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
