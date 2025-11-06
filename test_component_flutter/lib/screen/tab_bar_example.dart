import 'package:flutter/material.dart';

class TabBarExample extends StatelessWidget {
  const TabBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      animationDuration: const Duration(milliseconds: 300),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tab Bar Example'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(icon: const Icon(Icons.home), text: 'Home'),
                  Tab(icon: const Icon(Icons.favorite), text: 'Favorites'),
                  Tab(icon: const Icon(Icons.settings), text: 'Settings'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _TabContent(
              title: 'Home Tab',
              description: 'This is the Home tab content',
              icon: Icons.home,
            ),
            _TabContent(
              title: 'Favorites Tab',
              description: 'This is the Favorites tab content',
              icon: Icons.favorite,
            ),
            _TabContent(
              title: 'Settings Tab',
              description: 'This is the Settings tab content',
              icon: Icons.settings,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _TabContent({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.blue.shade400),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
