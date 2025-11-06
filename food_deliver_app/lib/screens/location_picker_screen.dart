import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  String status = 'Idle';
  Future<void> _getLocation() async {
    setState(() {
      status = 'Fetching...';
    });
    try {
      final pos = await LocationService.getCurrent();
      setState(() {
        status =
            'Got ${pos.latitude.toStringAsFixed(3)}, ${pos.longitude.toStringAsFixed(3)}';
      });
    } catch (e) {
      setState(() {
        status = 'Failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick location')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(status),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Get current location'),
            ),
          ],
        ),
      ),
    );
  }
}
