import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import '../models/address.dart';

class LocationPickerScreen extends StatefulWidget {
  final Address? initialAddress;

  const LocationPickerScreen({this.initialAddress, super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

// State class for LocationPickerScreen
class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  late LatLng _selectedLocation;
  String _selectedAddressText = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  bool _isLoadingAddress = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialAddress != null) {
      _selectedLocation = LatLng(
        widget.initialAddress!.lat,
        widget.initialAddress!.lng,
      );
      _selectedAddressText = widget.initialAddress!.line1;
    } else {
      _selectedLocation = const LatLng(37.7749, -122.4194);
      _selectedAddressText = '';
    }
    // Initialize marker and address
    _updateMarkerAndAddress();
  }

  // Update marker on the map and fetch address
  void _updateMarkerAndAddress() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _selectedLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    // Fetch address from coordinates
    _getAddressFromCoordinates(_selectedLocation);
    setState(() {});
  }

  // Fetch address using geocoding package from coordinates by user
  Future<void> _getAddressFromCoordinates(LatLng location) async {
    setState(() => _isLoadingAddress = true);
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks[0];
        _selectedAddressText =
            '${p.street ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''} ${p.postalCode ?? ''}';
      }
    } catch (e) {
      print('Geocoding error: $e');
      _selectedAddressText = 'Address not found';
    }
    setState(() => _isLoadingAddress = false);
  }

  // Search address and update map location accordingly
  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;

    try {
      List<geo.Location> locations = await geo.locationFromAddress(query);

      if (locations.isNotEmpty) {
        final location = locations[0];
        _selectedLocation = LatLng(location.latitude, location.longitude);

        if (_mapReady) {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _selectedLocation, zoom: 16),
            ),
          );
        }
        // Update marker and address after search
        _updateMarkerAndAddress();
        _searchController.clear();
      }
    } catch (e) {
      print('Search error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Address not found')));
      }
    }
  }

  // Get current location of the user
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        }
        return;
      }

      // Check permission status
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied'),
            ),
          );
        }
        return;
      }

      // Get current position by user using Geolocator package
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _selectedLocation = LatLng(position.latitude, position.longitude);

      if (_mapReady && mounted) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _selectedLocation, zoom: 16),
          ),
        );
      }
      // Update marker and address after getting current location
      _updateMarkerAndAddress();
    } catch (e) {
      print('Location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  // Create Address object from selected location
  Address _createAddressFromLocation(LatLng location) {
    return Address(
      id: DateTime.now().toString(),
      line1: _selectedAddressText,
      city: 'City',
      region: 'State',
      postalCode: '00000',
      lat: location.latitude,
      lng: location.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final address = _createAddressFromLocation(_selectedLocation);
              Navigator.pop(context, address);
            },
            child: const Text(
              'CONFIRM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map (Full screen) using google_maps_flutter package
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 16,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              setState(() => _mapReady = true);
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
                _updateMarkerAndAddress();
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Search bar at the top of the map using TextField widget
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchAddress,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search for an address...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Delivery Location Info and Buttons at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Location Label on map
                  const Text(
                    'Delivery Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address Display on map
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _isLoadingAddress
                            ? const Text(
                                'Loading address...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Text(
                                _selectedAddressText.isEmpty
                                    ? 'Tap on map or search'
                                    : _selectedAddressText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Buttons Row - Current Location & Confirm Location buttons
                  Row(
                    children: [
                      // Current Location Button - Outlined
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.my_location, size: 20),
                          label: const Text('Current Location'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                            foregroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Confirm Location Button - Filled
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final address = _createAddressFromLocation(
                              _selectedLocation,
                            );
                            Navigator.pop(context, address);
                          },
                          icon: const Icon(Icons.check, size: 20),
                          label: const Text('Confirm Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Safe area bottom padding
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dispose controllers to free resources and avoid memory leaks
  @override
  void dispose() {
    _searchController.dispose();
    if (_mapReady) {
      _mapController.dispose();
    }
    super.dispose();
  }
}
