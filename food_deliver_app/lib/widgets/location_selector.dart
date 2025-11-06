import 'package:flutter/material.dart';
import '../models/address.dart';

class LocationSelector extends StatelessWidget {
  final Address? address;
  final void Function()? onPick;
  const LocationSelector({this.address, this.onPick, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.place),
      title: Text(address?.line1 ?? 'Select delivery address'),
      subtitle: Text(address?.city ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.edit_location),
        onPressed: onPick,
      ),
    );
  }
}
