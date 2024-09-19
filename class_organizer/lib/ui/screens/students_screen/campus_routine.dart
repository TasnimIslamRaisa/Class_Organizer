import 'package:flutter/material.dart';
import '../../widgets/drawer_widget.dart';

class CampusRoutine extends StatefulWidget {
  const CampusRoutine({super.key});

  @override
  _CampusRoutineState createState() => _CampusRoutineState();
}

class _CampusRoutineState extends State<CampusRoutine> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Campus Schedules'),
        backgroundColor: const Color(0xFF40C4FF), // Sky blue
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Action when more_vert is clicked
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Colors.white, // TabBar background color set to white
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black, // Tab indicator color
                    labelColor: Colors.black, // Selected tab text color set to black
                    unselectedLabelColor: Colors.black.withOpacity(0.6), // Unselected tab text color
                    tabs: const [
                      Tab(text: 'Campus'),
                      Tab(text: 'Mine'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const DrawerWidget(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Fragment for 'Campus'
          Center(
            child: Text(
              'Campus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Fragment for 'Self'
          Center(
            child: Text(
              'Mine',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      // Floating Action Button with custom positioning
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for FAB
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(), // Fully circular shape
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
