import 'package:flutter/material.dart';
import '../models/address.dart';
import '../services/location_services.dart';
import '../models/location_notifier.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final LocationNotifier notifier = LocationNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder<String>(
              valueListenable: notifier.statusNotifier,
              builder: (context, status, _) {
                return Text('Status: $status');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => notifier.fetchCurrentLocation(),
              child: const Text('Fetch Current Location'),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<Address?>(
              valueListenable: notifier.addressNotifier,
              builder: (context, address, _) {
                return ElevatedButton(
                  onPressed: address == null
                      ? null
                      : () => Navigator.pop(context, address),
                  child: const Text('Confirm Location'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
