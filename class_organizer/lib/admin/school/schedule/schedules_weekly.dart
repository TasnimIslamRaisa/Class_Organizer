import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/admin/school/schedule/screen/add_schedule_screen.dart';
import 'package:class_organizer/admin/school/schedule/single_day_schedule.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/class_model.dart';
import '../../../models/routine.dart';
import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../ui/screens/controller/class_routine_controller.dart';
import '../../../ui/screens/controller/schedule_controller.dart';
import '../../../ui/screens/students_screen/add_class_screen.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class SchedulesWeekly extends StatefulWidget {
  final Routine routine;
  SchedulesWeekly({required this.routine});

  @override
  _SchedulesWeeklyState createState() => _SchedulesWeeklyState();
}

class _SchedulesWeeklyState extends State<SchedulesWeekly> {
  late List<String> tabTitles;
  late List<DateTime> dateList;

  final ScheduleController scheduleController = Get.put(ScheduleController());
  List<ScheduleItem> schedules = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('schedules');
  bool _isLoading = true;
  bool isConnected = false;
  late StreamSubscription subscription;
  final internetChecker = InternetConnectivity();
  StreamSubscription<InternetConnectionStatus>? connectionSubscription;
  String? userName;
  String? userPhone;
  String? userEmail;
  User? _user, _user_data;
  final _formKey = GlobalKey<FormState>();
  String? sid;
  School? school;


  void _addSchedule(ScheduleItem newSchedule) {
    saveNewRoutine(newSchedule);
    // scheduleController.addSchedule(newSchedule);
  }

  @override
  void initState() {
    super.initState();
    generateDateList();
    loadSchedules(widget.routine);

    _loadUserData();
    startListening();
    checkConnection();
    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });

  }

  void checkConnection() async {
    bool result = await internetChecker.hasInternetConnection();
    setState(() {
      isConnected = result;
    });
  }

  StreamSubscription<InternetConnectionStatus> checkConnectionContinuously() {
    return InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected) {
        isConnected = true;
        print('Connected to the internet');
        loadSchedules(widget.routine);
      } else {
        isConnected = false;
        print('Disconnected from the internet');
      }
    });
  }

  void startListening() {
    connectionSubscription = checkConnectionContinuously();
  }

  void stopListening() {
    connectionSubscription?.cancel();
  }

  Future<void> _loadUserData() async {
    Logout logout = Logout();
    User? user = await logout.getUserDetails(key: 'user_data');

    Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
    Map<String, dynamic>? schoolMap = await logout.getSchool(key: 'school_data');

    if (userMap != null) {
      User user_data = User.fromMap(userMap);
      setState(() {
        _user_data = user_data;
      });
    } else {
      print("User map is null");
    }

    if (schoolMap != null) {
      School schoolData = School.fromMap(schoolMap);
      setState(() {
        _user = user;
        school = schoolData;
        sid = school?.sId;
        print(schoolData.sId);
      });
    } else {
      print("School data is null");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_logged_in');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['uname'];
        userPhone = userData['phone'];
        userEmail = userData['email'];
      });
    }
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

  Future<void> loadSchedules(Routine routine) async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the schedules node in Firebase
      DatabaseReference schedulesRef = _databaseRef.child('schedules');

      // Query schedules that match the given tempCode from the routine
      Query query = schedulesRef.orderByChild('temp_code').equalTo(routine.tempCode);

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
          scheduleController.setSchedules(fetchedSchedules);

          setState(() {
            _isLoading = false;
          });
        } else {
          print('No schedules available for the given routine.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load schedules: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // Handle offline mode
      setState(() {
        _isLoading = false;
      });
      showSnackBarMsg(context, "You are offline. Please connect to the internet.");
    }
  }

  void showSnackBarMsg(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void saveNewRoutine(ScheduleItem newSchedule) async {

    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();
    var uuid = Uuid();

    if (newSchedule.subName!.isNotEmpty && newSchedule.subCode!.isNotEmpty) {

      newSchedule.uniqueId = uniqueId;
      newSchedule.id = null;
      newSchedule.sId = school?.sId;
      newSchedule.tempCode = widget.routine.tempCode;
      newSchedule.tempNum = widget.routine.tempNum;
      newSchedule.stdId = null;
      newSchedule.tId = _user?.uniqueid;


      if (await InternetConnectionChecker().hasConnection) {
        if (newSchedule.uniqueId != null && newSchedule.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("schedules")
              .child(newSchedule.uniqueId!);

          _database.set(newSchedule.toMap()).then((_) {
            setState(() {
              schedules.add(newSchedule);
              scheduleController.addSchedule(newSchedule);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Routine added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add routine: $error')),
            );
            print("Error adding routine: $error");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid unique ID')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }


}