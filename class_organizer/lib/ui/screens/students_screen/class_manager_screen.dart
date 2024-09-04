import 'package:class_organizer/ui/screens/seven_days_content/tuesday_content.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer_widget.dart';
import '../seven_days_content/friday_content.dart';
import '../seven_days_content/monday_content.dart';
import '../seven_days_content/saturday_content.dart';
import '../seven_days_content/sunday_content.dart';
import '../seven_days_content/thursday_content.dart';
import '../seven_days_content/wednesday_content.dart';

class ClassManagerScreen extends StatelessWidget {
  const ClassManagerScreen({super.key});
//const Color(0xFF00B0FF),
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Number of days in the week
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Class Manager'),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Handle action pressed
              },
            ),
          ],
        backgroundColor: const Color(0xFF00B0FF),
        foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
              Tab(text: 'Sun'),
            ],
          ),
        ),
        drawer: const DrawerWidget(),
        body: const TabBarView(
          children: [
            // Content for each day
            MondayContent(),
            TuesdayContent(),
            WednesdayContent(),
            ThursdayContent(),
            FridayContent(),
            SaturdayContent(),
            SundayContent(),
          ],
        ),
      ),
    );
  }
}
