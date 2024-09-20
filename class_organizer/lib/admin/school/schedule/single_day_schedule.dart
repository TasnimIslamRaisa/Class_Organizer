import 'package:class_organizer/admin/school/schedule/schedule_card.dart';
import 'package:class_organizer/admin/school/schedule/widget/slidable_schedule.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../ui/screens/controller/schedule_controller.dart';

class SingleDaySchedule extends StatefulWidget {
  final DateTime date;
  final List<ScheduleItem> schedules;

  SingleDaySchedule({required this.date, required this.schedules, Key? key}) : super(key: key);

  @override
  _SingleDayScheduleState createState() => _SingleDayScheduleState();
}

class _SingleDayScheduleState extends State<SingleDaySchedule> {
  final ScheduleController scheduleController = Get.find();
  late List<ScheduleItem> dailySchedule;

  final _databaseRef = FirebaseDatabase.instance.ref();
  List<ScheduleItem> schedules = [];
  List<ScheduleItem> schedulesList = [];

  @override
  void initState() {
    super.initState();

    dailySchedule = getScheduleForDate(widget.date);
    setState(() {
      schedules = widget.schedules;
      dailySchedule = schedules;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String dayName = DateFormat('EEEE').format(widget.date);
      List<ScheduleItem> dailySchedule = scheduleController.getSchedulesForDays(dayName);

      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: dailySchedule.length,
        itemBuilder: (context, index) {
          return SlidableSchedule(
            classItem: dailySchedule[index],
            onDeleteClass: (ScheduleItem schedule) {
              deleteSchedule(schedule);

            },
            onEditClass: (ScheduleItem schedule) {
              editSchedule(schedule);
            },
            onDuplicateClass: (ScheduleItem schedule) {
              duplicateSchedule(schedule);
            },
          );
        },
      );
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(8.0),
  //     itemCount: dailySchedule.length,
  //     itemBuilder: (context, index) {
  //       // return ScheduleCard(schedule: dailySchedule[index]);
  //       return SlidableSchedule(classItem: dailySchedule[index], onDeleteClass: (ScheduleItem ) {  }, onEditClass: (ScheduleItem ) {  }, onDuplicateClass: (ScheduleItem ) {  },);
  //     },
  //   );
  // }

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

  void deleteSchedule(ScheduleItem schedule) async {
    // Check if an internet connection is available
    if (await InternetConnectionChecker().hasConnection) {
      // Reference to the schedules node in Firebase
      DatabaseReference scheduleRef = _databaseRef.child('schedules').child(schedule.uniqueId!);

      scheduleRef.remove().then((_) {
        // Remove the schedule from the local list using the controller
        scheduleController.removeSchedule(schedule);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schedule deleted successfully')),
        );
      }).catchError((error) {
        // Handle the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete schedule: $error')),
        );
      });
    } else {
      // Handle offline mode
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
    }
  }


  void editSchedule(ScheduleItem schedule) {

  }

  void duplicateSchedule(ScheduleItem schedule) {

  }

}
