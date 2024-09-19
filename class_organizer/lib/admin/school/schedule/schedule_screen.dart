import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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

class SingleDaySchedule extends StatefulWidget {
  final DateTime date;

  const SingleDaySchedule({required this.date, Key? key}) : super(key: key);

  @override
  _SingleDayScheduleState createState() => _SingleDayScheduleState();
}

class _SingleDayScheduleState extends State<SingleDaySchedule> {
  late List<Schedule> dailySchedule;

  @override
  void initState() {
    super.initState();
    // Initialize the schedule data based on the provided date
    dailySchedule = getScheduleForDate(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dailySchedule.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(dailySchedule[index].subject),
          subtitle: Text(
              '${dailySchedule[index].time} - ${dailySchedule[index].room}'),
        );
      },
    );
  }

  List<Schedule> getScheduleForDate(DateTime date) {
    // Example static data, replace with dynamic fetching logic
    return [
      Schedule(subject: 'Math', time: '10:00 AM - 11:30 AM', room: 'Room 101'),
      Schedule(subject: 'Science', time: '12:00 PM - 01:30 PM', room: 'Room 102'),
    ];
  }
}

class Schedule {
  final String subject;
  final String time;
  final String room;

  Schedule({required this.subject, required this.time, required this.room});
}
