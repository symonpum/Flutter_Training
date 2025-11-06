import 'package:flutter/material.dart';
import 'package:test_component_flutter/services/notification_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('🔔 Notifications Screen', style: TextStyle(fontSize: 16)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final amount = NotificationService().amountNotificationNotifier.value;
          if (amount > 0) {
            NotificationService().amountNotificationNotifier.value = amount - 1;
          }
        },
        child: const Icon(Icons.remove),
      ),
    );
  }
}
