import 'package:class_organizer/admin/widgets/drawer_widget_admin.dart';
import 'package:class_organizer/admin/bus/from_campus.dart';
import 'package:class_organizer/admin/bus/toward_campus.dart';
import 'package:flutter/material.dart';


class BusSchedule extends StatefulWidget {
  const BusSchedule({super.key});

  @override
  _BusScheduleState createState() => _BusScheduleState();
}

class _BusScheduleState extends State<BusSchedule> with SingleTickerProviderStateMixin {
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
        title: const Text('Bus Schedules'),
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
                      Tab(text: 'From University'),
                      Tab(text: 'Toward University'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const DrawerWidgetAdmin(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Fragment for 'Campus'
          Center(
            child: FromCampus(),
          ),
          // Fragment for 'Self'
          Center(
            child: TowardCampus(),
          ),
        ],
      ),
      // Floating Action Button with custom positioning
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add action for FAB
      //   },
      //   backgroundColor: Colors.blue,
      //   shape: const CircleBorder(), // Fully circular shape
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
