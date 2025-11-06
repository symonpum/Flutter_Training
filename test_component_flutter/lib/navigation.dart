import 'package:flutter/material.dart';
import 'package:test_component_flutter/screen/home_screen.dart';
import 'package:test_component_flutter/screen/notification_screen.dart';
import 'package:test_component_flutter/services/notification_service.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentIndex = 0;
  List<Widget> screens = [HomeScreen(), NotificationScreen()];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
            selectedIcon: Icon(Icons.home_outlined),
          ),
          NavigationDestination(
            icon: ValueListenableBuilder(
              valueListenable: NotificationService().amountNotificationNotifier,
              builder: (context, value, child) {
                if (value == 0) {
                  return Icon(Icons.notifications_sharp);
                }

                return Badge(
                  label: Text("$value"),
                  child: Icon(Icons.notifications_sharp),
                );
              },
            ),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
