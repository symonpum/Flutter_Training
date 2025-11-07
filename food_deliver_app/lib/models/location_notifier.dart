import 'package:flutter/foundation.dart';
import '../models/address.dart';
import '../services/location_services.dart';

class LocationNotifier {
  final ValueNotifier<Address?> addressNotifier = ValueNotifier<Address?>(null);
  final ValueNotifier<String> statusNotifier = ValueNotifier<String>('Idle');

  Future<void> fetchCurrentLocation() async {
    statusNotifier.value = 'Fetching...';

    try {
      final pos = await LocationService().getCurrentPosition();
      if (pos == null) {
        statusNotifier.value = 'Permission denied';
        return;
      }

      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        line1: 'Current location',
        city: '',
        region: '',
        postalCode: '',
        lat: pos.latitude,
        lng: pos.longitude,
      );

      addressNotifier.value = newAddress;
      statusNotifier.value =
          'Got ${pos.latitude.toStringAsFixed(3)}, ${pos.longitude.toStringAsFixed(3)}';
    } catch (e) {
      statusNotifier.value = 'Failed: $e';
    }
  }
}
