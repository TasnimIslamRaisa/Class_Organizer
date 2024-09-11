import 'package:class_organizer/ui/screens/seven_days_content/tuesday_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart'; // Import SpeedDial package
import '../../../utility/profile_app_bar.dart';
import '../../widgets/drawer_widget.dart';
import '../seven_days_content/friday_content.dart';
import '../seven_days_content/monday_content.dart';
import '../seven_days_content/saturday_content.dart';
import '../seven_days_content/sunday_content.dart';
import '../seven_days_content/thursday_content.dart';
import '../seven_days_content/wednesday_content.dart';

class ClassManagerScreen extends StatelessWidget {
  const ClassManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Number of days in the week
      child: Scaffold(
        appBar: ProfileAppBar(
          title:  'Daily Schedules',
          actionIcon: Icons.more_vert,
          onActionPressed: (){},
          appBarbgColor: const Color(0xFF00B0FF),
          //foregroundColor: Colors.white,
          bottom:const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
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
            MondayContent(),
            TuesdayContent(),
            WednesdayContent(),
            ThursdayContent(),
            FridayContent(),
            SaturdayContent(),
            SundayContent(),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add Class',
              onTap: () {
                // Handle Add Class action
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.edit),
              label: 'Edit Class',
              onTap: () {
                // Handle Edit Class action
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.delete),
              label: 'Delete Class',
              onTap: () {
                // Handle Delete Class action
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
