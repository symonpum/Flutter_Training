import 'package:flutter/material.dart';

class TabScreenWithController extends StatefulWidget {
  const TabScreenWithController({Key? key}) : super(key: key);

  @override
  State<TabScreenWithController> createState() =>
      _TabScreenWithControllerState();
}

class _TabScreenWithControllerState extends State<TabScreenWithController>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Screen with Controller'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  icon: const Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: const Icon(Icons.star),
                  text: 'Favorites',
                ),
                Tab(
                  icon: const Icon(Icons.settings),
                  text: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ControlledTabContent(
            title: 'Home Tab',
            description:
                'This is the Home tab with custom controller management',
            icon: Icons.home,
            tabIndex: 0,
            selectedIndex: _selectedTabIndex,
          ),
          _ControlledTabContent(
            title: 'Favorites Tab',
            description:
                'This is the Favorites tab with custom controller management',
            icon: Icons.star,
            tabIndex: 1,
            selectedIndex: _selectedTabIndex,
          ),
          _ControlledTabContent(
            title: 'Settings Tab',
            description:
                'This is the Settings tab with custom controller management',
            icon: Icons.settings,
            tabIndex: 2,
            selectedIndex: _selectedTabIndex,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _tabController.animateTo(0);
        },
        tooltip: 'Go to Home',
        child: const Icon(Icons.home),
      ),
    );
  }
}

class _ControlledTabContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int tabIndex;
  final int selectedIndex;

  const _ControlledTabContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.tabIndex,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selectedIndex == tabIndex
                  ? Colors.green.shade100
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: selectedIndex == tabIndex
                  ? Colors.green.shade600
                  : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Tab Index: $tabIndex',
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}