import 'package:class_organizer/admin/school/schedule/screen/add_schedule_screen.dart';
import 'package:class_organizer/admin/school/schedule/single_day_schedule.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../models/class_model.dart';
import '../../../models/routine.dart';
import '../../../ui/screens/controller/class_routine_controller.dart';
import '../../../ui/screens/controller/schedule_controller.dart';
import '../../../ui/screens/students_screen/add_class_screen.dart';

class WeeklySchedules extends StatefulWidget {
  final Routine routine;
  WeeklySchedules({required this.routine});

  @override
  _WeeklySchedulesState createState() => _WeeklySchedulesState();
}

class _WeeklySchedulesState extends State<WeeklySchedules> {
  late List<String> tabTitles;
  late List<DateTime> dateList;

  final ScheduleController scheduleController = Get.put(ScheduleController());

  List<ScheduleItem> schedules = [];

  void _deleteSchedule(ScheduleItem classToDelete) {
    // classController.removeClass(classToDelete);
    // Notify listeners
  }
  void _addSchedule(ScheduleItem newClass) {



    scheduleController.addSchedule(newClass);
  }

  @override
  void initState() {
    super.initState();
    generateDateList();
    loadSchedules(widget.routine);
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
            return SingleDaySchedule(date: date,schedules: schedules,);
          }).toList(),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add Schedule',
              onTap: () {
                _showAddClassBottomSheet(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.edit),
              label: 'Other',
              onTap: () {

              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _showAddClassBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddScheduleScreen(
          onAddClass: (ScheduleItem newClass) {
            _addSchedule(newClass);  // Add class when the bottom sheet is closed
            // Navigator.pop(context);  // Close bottom sheet
          },
        );
      },
    );
  }

  void loadSchedules(Routine routine) {
    scheduleController.setSchedules(schedules);
  }

}