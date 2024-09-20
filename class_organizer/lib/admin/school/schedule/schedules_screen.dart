import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulesScreen extends StatefulWidget {
  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
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
      padding: const EdgeInsets.all(8.0),
      itemCount: dailySchedule.length,
      itemBuilder: (context, index) {
        return ScheduleCard(schedule: dailySchedule[index]);
      },
    );
  }

  List<Schedule> getScheduleForDate(DateTime date) {
    // Example static data, replace with dynamic fetching logic
    return [
      Schedule(
          subject: 'Compiler Theory',
          time: '11:30 AM - 01:00 PM',
          room: 'Room 108',
          teacher: 'Arifa Mem'),
      Schedule(
          subject: 'Computer Graphics',
          time: '01:00 PM - 03:00 PM',
          room: 'Room 111',
          teacher: 'Tasnima Mem'),
      Schedule(
          subject: 'Machine Learning',
          time: '03:00 PM - 04:30 PM',
          room: 'Room 110',
          teacher: 'Sohrab Sir'),
    ];
  }
}

class Schedule {
  final String subject;
  final String time;
  final String room;
  final String teacher;

  Schedule(
      {required this.subject,
        required this.time,
        required this.room,
        required this.teacher});
}

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;

  const ScheduleCard({required this.schedule, Key? key}) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.schedule.subject,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.red),
                SizedBox(width: 4),
                Text(
                  // Accessing schedule from widget
                  widget.schedule.time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  widget.schedule.teacher,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.room, size: 18, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  widget.schedule.room,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Add your detail view logic here
                },
                child: const Text('DETAILS'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
