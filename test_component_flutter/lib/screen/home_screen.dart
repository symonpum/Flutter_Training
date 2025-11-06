import 'package:flutter/material.dart';
import 'package:test_component_flutter/screen/tab_bar_example.dart';
import 'package:test_component_flutter/screen/tab_screen_with_controller.dart';
import 'package:test_component_flutter/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final amount = NotificationService().amountNotificationNotifier.value;
          NotificationService().amountNotificationNotifier.value = amount + 1;
        },
        child: const Icon(Icons.add),
        tooltip: 'Remove Notification',
        backgroundColor: Colors.red.shade400,
      ),
      appBar: AppBar(
        title: const Text("Home Screen"),
        leading: const Icon(Icons.home_rounded),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const TabBarExample(),
                    ),
                  );
                },
                icon: const Icon(Icons.article_outlined, size: 24),
                label: const Text('View Details'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const TabScreenWithController(),
                    ),
                  );
                },
                icon: const Icon(Icons.tab_rounded, size: 24),
                label: const Text('Open Tabs'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
