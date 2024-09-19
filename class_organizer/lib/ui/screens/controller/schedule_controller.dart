import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/schedule_item.dart';

class ScheduleController extends GetxController {
  // Observable map to store schedules by day
  // var schedules = <String, List<ScheduleItem>>{}.obs;
  var schedules = <ScheduleItem>[].obs;

  void addSchedule(ScheduleItem newSchedule) {
    schedules.add(newSchedule);
  }

  void removeSchedule(ScheduleItem schedule) {
    schedules.remove(schedule);
  }

  void updateSchedule(ScheduleItem updatedSchedule) {
    int index = schedules.indexWhere((s) => s.id == updatedSchedule.id);
    if (index != -1) {
      schedules[index] = updatedSchedule;
    }
  }

  void setSchedules(List<ScheduleItem> scheduleList) {
    schedules.clear(); // Clear the existing schedules
    schedules.addAll(scheduleList); // Add all new schedules
  }

  List<ScheduleItem> getSchedulesForDay(String day) {
    return schedules.where((schedule) => schedule.day == day).toList();
  }

  List<ScheduleItem> getSchedulesForDays(String day) {
    return schedules.where((schedule) => schedule.day == day || schedule.day == "Everyday").toList();
  }


  List<ScheduleItem> getSchedulesByTempCode(String tempCode) {
    return schedules.where((schedule) => schedule.tempCode == tempCode).toList();
  }


  // void setSchedulesForDate(DateTime date, List<ScheduleItem> scheduleList) {
  //   String dayKey = _getDayKeyFromDate(date);
  //   schedules[dayKey] = scheduleList;
  //   update(); // Notify UI of changes
  // }

  // void setAllSchedules(List<ScheduleItem> scheduleList) {
  //   // Clear the current schedules
  //   schedules.clear();
  //
  //   // Organize the schedules by date
  //   for (var schedule in scheduleList) {
  //     String? dayKey = schedule.day;
  //     schedules[dayKey!] ??= [];
  //     schedules[dayKey]?.add(schedule);
  //   }
  //   update(); // Notify UI of changes
  // }

  // List<ScheduleItem> getSchedulesForDate(DateTime date) {
  //   String dayKey = _getDayKeyFromDate(date);
  //   return schedules[dayKey] ?? [];
  // }
  // Add a new schedule item
  // void addSchedule(ScheduleItem newSchedule) {
  //   // Initialize the list for the day if it does not exist
  //   if (schedules[newSchedule.day] == null) {
  //     schedules[newSchedule.day!] = [];
  //   }
  //   // Add the new schedule to the list
  //   schedules[newSchedule.day]?.add(newSchedule);
  //
  //   // Debugging: Print the updated schedule list for the day
  //   print('Schedule added to ${newSchedule.day}: ${schedules[newSchedule.day]}');
  //   update(); // Notify UI
  // }

  // Remove an existing schedule item
  // void removeSchedule(ScheduleItem scheduleToRemove) {
  //   // Remove the schedule item from the list
  //   schedules[scheduleToRemove.day]?.remove(scheduleToRemove);
  //
  //   // Debugging: Print the updated schedule list after removal
  //   print('Schedule removed from ${scheduleToRemove.day}: ${schedules[scheduleToRemove.day]}');
  //
  //   // If the list is empty, set it to an empty list
  //   if (schedules[scheduleToRemove.day]?.isEmpty ?? true) {
  //     schedules[scheduleToRemove.day!] = [];
  //   }
  //
  //   update(); // Notify UI immediately
  // }

  String _getDayKeyFromDate(DateTime date) {
    // Example: return "Monday" for Monday, etc.
    return DateFormat('EEEE').format(date); // Requires intl package for DateFormat
  }

  // void updateSchedule(ScheduleItem updatedSchedule) {
  //   int index = schedules.indexWhere((s) => s.id == updatedSchedule.id);
  //   if (index != -1) {
  //     schedules[index] = updatedSchedule;
  //   }
  // }

}
