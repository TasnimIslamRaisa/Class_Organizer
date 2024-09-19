import 'package:class_organizer/admin/school/schedule/single_day_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../../../models/routine.dart';

class WeeklySchedules extends StatefulWidget {
  final Routine routine;
  WeeklySchedules({required this.routine});

  @override
  _WeeklySchedulesState createState() => _WeeklySchedulesState();
}

class _WeeklySchedulesState extends State<WeeklySchedules> {
  late List<String> tabTitles;
  late List<DateTime> dateList;

  @override
  void initState() {
    super.initState();
    generateDateList();
  }

  void generateDateList() {
    DateTime now = DateTime.now();
    dateList = List.generate(7, (index) => now.add(Duration(days: index)));
    tabTitles = dateList.map((date) {
      return DateFormat('EEE').format(date); // e.g., "EEEE Thursday, Sep 19"
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Schedules - ${widget.routine.tempName}'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: tabTitles.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: TabBarView(
          children: dateList.map((date) {
            return SingleDaySchedule(date: date);
          }).toList(),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add Class',
              onTap: () {
                // _showAddClassBottomSheet(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.edit),
              label: 'Edit Class',
              onTap: () {

              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}