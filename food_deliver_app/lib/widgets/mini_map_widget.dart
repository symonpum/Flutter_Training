import 'package:flutter/material.dart';

class MiniMapWidget extends StatelessWidget {
  final double lat;
  final double lng;
  const MiniMapWidget({required this.lat, required this.lng, super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for a real map widget (google_maps_flutter)
    return Container(
      height: 150,
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          'Map: ${lat.toStringAsFixed(3)}, ${lng.toStringAsFixed(3)}',
        ),
      ),
    );
  }
}
