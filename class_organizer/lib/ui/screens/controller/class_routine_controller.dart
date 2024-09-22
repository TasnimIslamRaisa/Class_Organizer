import 'dart:async';
import 'dart:convert';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/class_model.dart';
import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../web/internet_connectivity.dart';

class ClassController extends GetxController {
  var classes = <String, List<ScheduleItem>>{}.obs;

  List<ScheduleItem> schedules = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('schedules');
  bool isConnected = false;
  late StreamSubscription subscription;
  final internetChecker = InternetConnectivity();
  StreamSubscription<InternetConnectionStatus>? connectionSubscription;
  String? userName;
  String? userPhone;
  String? userEmail;
  User? _user, _user_data;
  String? sid;
  School? school;

  @override
  void onInit() {
    super.onInit();
    loadClasses();

    _loadUserData();

  }

  Future<void> _loadUserData() async {
    Logout logout = Logout();
    User? user = await logout.getUserDetails(key: 'user_data');

    Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
    Map<String, dynamic>? schoolMap = await logout.getSchool(key: 'school_data');

    if (userMap != null) {
      User user_data = User.fromMap(userMap);

        _user_data = user_data;

    } else {
      print("User map is null");
    }

    if (schoolMap != null) {
      School schoolData = School.fromMap(schoolMap);

        _user = user;
        school = schoolData;
        sid = school?.sId;
        print(schoolData.sId);

    } else {
      print("School data is null");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_logged_in');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);

        userName = userData['uname'];
        userPhone = userData['phone'];
        userEmail = userData['email'];

    }
  }

  Future<void> loadSchedules() async {
    if (await InternetConnectionChecker().hasConnection) {

      // Reference to the schedules node in Firebase
      DatabaseReference schedulesRef = _databaseRef.child('schedules');

      // Query schedules that match the given tempCode from the routine
      Query query = schedulesRef.orderByChild('temp_code').equalTo(_user?.uniqueid);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> schedulesData = dataSnapshot.value as Map<dynamic, dynamic>;

          // Convert the schedules data into a list of ScheduleItems
          List<ScheduleItem> fetchedSchedules = schedulesData.entries.map((entry) {
            Map<String, dynamic> scheduleMap = {
              'id': entry.value['id'] ?? null,
              'uniqueId': entry.value['uniqueId'] ?? '',
              'sId': entry.value['sId'] ?? '',
              'stdId': entry.value['stdId'] ?? '',
              'tId': entry.value['tId'] ?? '',
              'temp_code': entry.value['temp_code'] ?? '',
              'temp_num': entry.value['temp_num'] ?? '',
              'sub_name': entry.value['sub_name'] ?? '',
              'sub_code': entry.value['sub_code'] ?? '',
              't_id': entry.value['t_id'] ?? '',
              't_name': entry.value['t_name'] ?? '',
              'room': entry.value['room'] ?? '',
              'campus': entry.value['campus'] ?? '',
              'section': entry.value['section'] ?? '',
              'start_time': entry.value['start_time'] ?? '',
              'end_time': entry.value['end_time'] ?? '',
              'day': entry.value['day'] ?? '',
              'key': entry.value['key'] ?? '',
              'sync_key': entry.value['sync_key'] ?? '',
              'min': entry.value['min'] ?? 0,
              'sync_status': entry.value['sync_status'] ?? 0,
              'dateTime': entry.value['dateTime'] != null ? DateTime.parse(entry.value['dateTime']) : null,
            };
            return ScheduleItem.fromMap(scheduleMap);
          }).toList();

          // Pass the fetched schedules to the ScheduleController
          setSchedules(fetchedSchedules);

        } else {
          print('No schedules available for the given routine.');
        }
      }).catchError((error) {
        print('Failed to load schedules: $error');
      });
    } else {
      // Handle offline mode
      print("You are offline. Please connect to the internet.");
    }
  }

  Future<void> loadClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? classListJson = prefs.getString('classList');
    if (classListJson != null) {
      Map<String, dynamic> classListMap = json.decode(classListJson);
      classListMap.forEach((key, value) {
        classes[key] = (value as List).map((classMap) => ScheduleItem.fromMap(classMap)).toList();
      });
    }
  }

  Future<void> saveClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final String classListJson = json.encode(classes.map((key, value) => MapEntry(key, value.map((classItem) => classItem.toMap()).toList())));
    await prefs.setString('classList', classListJson);
  }

  void addClass(ScheduleItem newClass) {
    if (classes[newClass.day] == null) {
      classes[newClass.day??"Everyday"] = [];
    }
    classes[newClass.day]?.add(newClass);
    saveClasses();

    // Debugging: Print the updated class list for the day
    print('Class added to ${newClass.day}: ${classes[newClass.day]}');
    update(); // Notify UI
  }

  void removeClass(ScheduleItem classToRemove) {
    classes[classToRemove.day]?.remove(classToRemove);

    // Debugging: Print the updated class list after removal
    print('Class removed from ${classToRemove.day}: ${classes[classToRemove.day]}');

    if (classes[classToRemove.day]?.isEmpty ?? true) {
      classes.remove(classToRemove.day); // Remove the day entry if no classes remain
    }

    saveClasses(); // Save after removal
    update(); // Notify UI immediately
  }

  void setSchedules(List<ScheduleItem> scheduleList) {
    for (var schedule in scheduleList) {
      if (classes[schedule.day] == null) {
        classes[schedule.day ?? "Everyday"] = [];
      }
      classes[schedule.day]?.add(schedule);
    }
    saveClasses();

    // Debugging: Print the updated schedules after adding
    // print('Schedules added: $scheduleList');
    update(); // Notify UI
  }

}
