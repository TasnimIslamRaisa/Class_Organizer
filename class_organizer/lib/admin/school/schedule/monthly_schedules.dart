import 'package:class_organizer/admin/school/schedule/single_day_schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/routine.dart';

class MonthlySchedules extends StatefulWidget {
  final Routine routine;
  MonthlySchedules({required this.routine});

  @override
  _MonthlySchedulesState createState() => _MonthlySchedulesState();
}

class _MonthlySchedulesState extends State<MonthlySchedules> {
  late List<String> tabTitles;
  late List<DateTime> dateList;

  @override
  void initState() {
    super.initState();
    generateDateList();
  }

  void generateDateList() {
    DateTime now = DateTime.now();
    dateList = List.generate(30, (index) => now.add(Duration(days: index)));
    tabTitles = dateList.map((date) {
      return DateFormat('EEE, MMM d').format(date); // e.g., "EEEE Thursday, Sep 19"
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
      ),
    );
  }
}