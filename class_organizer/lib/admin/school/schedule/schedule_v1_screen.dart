import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleV1Screen extends StatefulWidget {
  @override
  _ScheduleV1ScreenState createState() => _ScheduleV1ScreenState();
}

class _ScheduleV1ScreenState extends State<ScheduleV1Screen> {
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
      return DateFormat('EEEE, MMM d').format(date); // e.g., "Thursday, Sep 19"
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Date Tabs'),
          bottom: TabBar(
            isScrollable: true, // Scrollable for many tabs
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

class SingleDaySchedule extends StatelessWidget {
  final DateTime date;

  SingleDaySchedule({required this.date});

  @override
  Widget build(BuildContext context) {
    // Replace with your dynamic schedule content for each day
    return Center(
      child: Text(
        'Schedule for ${DateFormat('EEEE, MMM d').format(date)}',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}