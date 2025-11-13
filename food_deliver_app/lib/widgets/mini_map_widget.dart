import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

//mini map widget to show location preview and allow user to pick location
class MiniMapWidget extends StatefulWidget {
  final LatLng initialLocation;
  final void Function(LatLng)? onLocationChanged;
  final bool interactive;
  // Constructor for MiniMapWidget with required initialLocation and optional onLocationChanged and interactive flag
  const MiniMapWidget({
    required this.initialLocation,
    this.onLocationChanged,
    this.interactive = true,
    super.key,
  });

  @override
  State<MiniMapWidget> createState() => _MiniMapWidgetState();
}

class _MiniMapWidgetState extends State<MiniMapWidget> {
  GoogleMapController? _mapController;
  late LatLng _currentLocation;
  final Set<Marker> _markers = {};
  bool _mapReady = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _updateMarker();
  }

  void _updateMarker() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('delivery_location'),
        position: _currentLocation,
        infoWindow: const InfoWindow(
          title: 'Delivery Location',
          snippet: 'Your order will be delivered here',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  // Method to get current location and update the map
  Future<void> _goToCurrentLocation() async {
    if (!_mapReady || _mapController == null) return;

    try {
      setState(() => _isLocating = true);

      // Check if location services are enabled to get current position
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        }
        setState(() => _isLocating = false);
        return;
      }

      // Check permission status and request if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          setState(() => _isLocating = false);
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
        setState(() => _isLocating = false);
        return;
      }

      // Get current position of the device based on granted permissions
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLocation = LatLng(position.latitude, position.longitude);

      // Update the map location and marker
      setState(() {
        _currentLocation = userLocation;
        _updateMarker();
      });

      // Animate camera to current location on the map
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLocation, zoom: 16),
        ),
      );

      // Notify parent widget of location change
      widget.onLocationChanged?.call(userLocation);
    } catch (e) {
      print('Location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  // Build method to render the mini map widget in Container
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 16,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                setState(() => _mapReady = true);
              },
              onTap: widget.interactive
                  ? (LatLng location) {
                      setState(() {
                        _currentLocation = location;
                        _updateMarker();
                      });
                      widget.onLocationChanged?.call(location);
                    }
                  : null,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: widget.interactive,
              zoomGesturesEnabled: widget.interactive,
              rotateGesturesEnabled: widget.interactive,
              tiltGesturesEnabled: widget.interactive,
            ),

            // Current Location Button ( on the bottom right) of the mini map
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: _isLocating ? null : _goToCurrentLocation,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _isLocating
                      ? Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade600,
                              ),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 24,
                        ),
                ),
              ),
            ),

            // Loading indicator (map initialization) at the center of the mini map
            if (!_mapReady)
              Center(
                child: CircularProgressIndicator(color: Colors.green.shade600),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
