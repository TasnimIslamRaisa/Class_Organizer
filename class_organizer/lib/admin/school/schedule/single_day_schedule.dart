import 'package:class_organizer/admin/school/schedule/schedule_card.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleDaySchedule extends StatefulWidget {
  final DateTime date;

  const SingleDaySchedule({required this.date, Key? key}) : super(key: key);

  @override
  _SingleDayScheduleState createState() => _SingleDayScheduleState();
}

class _SingleDayScheduleState extends State<SingleDaySchedule> {
  late List<ScheduleItem> dailySchedule;

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

  List<ScheduleItem> getScheduleForDate(DateTime date) {
    // Get the day name from the date
    String dayName = DateFormat('EEEE').format(date);

    // Example static data using ScheduleItem model
    return [
      ScheduleItem(
        subName: 'Compiler Theory',
        startTime: '11:30 AM',
        endTime: '01:00 PM',
        room: 'Room 108',
        tName: 'Arifa Mem',
        day: dayName, // Add dayName to your ScheduleItem
      ),
      ScheduleItem(
        subName: 'Computer Graphics',
        startTime: '01:00 PM',
        endTime: '03:00 PM',
        room: 'Room 111',
        tName: 'Tasnima Mem',
        day: dayName, // Add dayName to your ScheduleItem
      ),
      ScheduleItem(
        subName: 'Machine Learning',
        startTime: '03:00 PM',
        endTime: '04:30 PM',
        room: 'Room 110',
        tName: 'Sohrab Sir',
        day: dayName, // Add dayName to your ScheduleItem
      ),
    ];
  }

}
