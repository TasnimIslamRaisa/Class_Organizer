import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/ui/screens/seven_days_content/everyday_content.dart';
import 'package:class_organizer/utility/scanner.dart';
import 'package:class_organizer/utility/scanner_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../db/database_helper.dart';
import '../../../models/class_model.dart';
import '../../../models/schedule_item.dart';
import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/profile_app_bar.dart';
import '../../../utility/scanner_code.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';
import '../../widgets/drawer_widget.dart';
import '../controller/class_routine_controller.dart';
import '../seven_days_content/monday_content.dart';
import '../seven_days_content/tuesday_content.dart';
import '../seven_days_content/wednesday_content.dart';
import '../seven_days_content/thursday_content.dart';
import '../seven_days_content/friday_content.dart';
import '../seven_days_content/saturday_content.dart';
import '../seven_days_content/sunday_content.dart';
import 'add_class_screen.dart';

class ClassManagerScreen extends StatefulWidget {
  ClassManagerScreen({super.key});

  @override
  _ClassManagerScreenState createState() => _ClassManagerScreenState();
}

class _ClassManagerScreenState extends State<ClassManagerScreen> {
  final ClassController classController = Get.put(ClassController());
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
  void initState() {
    super.initState();
    _loadUserData();
    // classController.clearClasses();
    loadSchedules();
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
        // loadSchedules(widget.routine);
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

  void saveNewSchedule(ScheduleItem newSchedule) async {

    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();
    var uuid = Uuid();

    if (newSchedule.subName!.isNotEmpty && newSchedule.subCode!.isNotEmpty) {

      newSchedule.uniqueId = uniqueId;
      newSchedule.id = null;
      newSchedule.sId = school?.sId;
      newSchedule.tempCode = _user?.uniqueid;
      newSchedule.tempNum = _user?.uniqueid;
      newSchedule.stdId = _user?.uniqueid;
      newSchedule.tId = _user?.uniqueid;


      if (await InternetConnectionChecker().hasConnection) {
        if (newSchedule.uniqueId != null && newSchedule.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("schedules")
              .child(newSchedule.uniqueId!);

          _database.set(newSchedule.toMap()).then((_) {
            setState(() {
              schedules.add(newSchedule);
              // scheduleController.addSchedule(newSchedule);
            });
            saveScheduleOffline(newSchedule);
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

  Future<void> loadSchedules() async {

    if (await InternetConnectionChecker().hasConnection) {

      DatabaseReference schedulesRef = _databaseRef.child('schedules');

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
          schedules.clear();
          schedules = fetchedSchedules;
          saveSchedulesOffline(fetchedSchedules);
          classController.clearClasses();
          // Pass the fetched schedules to the ScheduleController
          classController.setSchedules(fetchedSchedules);

        } else {
          print('No schedules available for the given routine.');
        }
      }).catchError((error) {
        print('Failed to load schedules: $error');
      });
    } else {
      // Handle offline mode
      showSnackBarMsg(context, "You are offline. Please connect to the internet.");
      getSchedulesOffline();
    }
  }

  Future<void> saveScheduleOffline(ScheduleItem schedule) async {

    // sqlite

    int result = await DatabaseHelper().insertSchedule(schedule);

    if (mounted) {
      setState(() {});
    }

    if (result > 0) {
      if (mounted) {

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            showSnackBarMsg(context, 'Schedule Saved Successful in Offline');
          }
        });

      }
    } else {
      if (mounted) {
        showSnackBarMsg(context, 'Registration Failed');
      }
    }

  }

  void showSnackBarMsg(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _deleteClass(ScheduleItem classToDelete) {
    deleteSchedule(classToDelete);
    // classController.removeClass(classToDelete);
    // Notify listeners
  }

  Future<void> deleteSchedule(ScheduleItem scheduleToDelete) async {
    try {
      DatabaseReference scheduleRef = _databaseRef.child('schedules').child(scheduleToDelete.uniqueId!);

      // Delete the schedule from Firebase
      await scheduleRef.remove();

      classController.removeClass(scheduleToDelete);

      showSnackBarMsg(context, 'Schedule with key ${scheduleToDelete.key} deleted successfully.');
    } catch (error) {
      // Handle the error (e.g., show a snack bar with error message)
      print('Error deleting schedule: $error');
      showSnackBarMsg(context, "Failed to delete schedule. Please try again.");
    }
  }


  void _addClass(ScheduleItem newClass) {
    saveNewSchedule(newClass);
    classController.addClass(newClass);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8, // Number of days in the week
      child: Scaffold(
        appBar: ProfileAppBar(
          title: 'Class Schedule',
          actionIcon: Icons.more_vert,
          onActionPressed: () {},
          appBarbgColor: Colors.blue,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            dividerColor: Colors.blue,
            tabs: [
              Tab(text: 'Sun'),
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
              Tab(text: 'Everyday'),
            ],
          ),
        ),
        drawer: const DrawerWidget(),
        body: Obx(() {
          final classes = classController.classes;
          return TabBarView(
            children: [
              SundayContent(classes: classes['Sunday'] ?? [], onDeleteClass: _deleteClass),
              MondayContent(classes: classes['Monday'] ?? [], onDeleteClass: _deleteClass),
              TuesdayContent(classes: classes['Tuesday'] ?? [], onDeleteClass: _deleteClass),
              WednesdayContent(classes: classes['Wednesday'] ?? [], onDeleteClass: _deleteClass),
              ThursdayContent(classes: classes['Thursday'] ?? [], onDeleteClass: _deleteClass),
              FridayContent(classes: classes['Friday'] ?? [], onDeleteClass: _deleteClass),
              SaturdayContent(classes: classes['Saturday'] ?? [], onDeleteClass: _deleteClass),
              EverydayContent(classes: classes['Everyday'] ?? [], onDeleteClass: _deleteClass),
            ],
          );
        }),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add Class',
              onTap: () {
                _showAddClassBottomSheet(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.qr_code_scanner),
              label: 'Scanner',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerCode()),
                );
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
        return AddClassBottomSheet(
          onAddClass: (ScheduleItem newClass) {
            _addClass(newClass);  // Add class when the bottom sheet is closed
          },
        );
      },
    );
  }

  Future<void> saveSchedulesOffline(List<ScheduleItem> fetchedSchedules) async {
    deleteSchedules();
    await DatabaseHelper().setSchedulesList(fetchedSchedules);
  }

  Future<void> deleteSchedules() async {
    await DatabaseHelper().deleteSchedules(_user?.uniqueid??"");
  }

  Future<void> getSchedulesOffline() async {
    List<ScheduleItem> fetchedSchedules = await DatabaseHelper().getAllSchedulesByUniqueId(_user!.uniqueid!);
    classController.clearClasses();
    schedules.clear();
    schedules = fetchedSchedules;
    // Pass the fetched schedules to the ScheduleController
    classController.setSchedules(fetchedSchedules);
  }
}


















// class ClassManagerScreen extends StatelessWidget {
//   final ClassController classController = Get.put(ClassController());
//   List<ScheduleItem> schedules = [];
//
//   void _deleteClass(ScheduleItem classToDelete) {
//     classController.removeClass(classToDelete);
//     // Notify listeners
//   }
//   void _addClass(ScheduleItem newClass) {
//     classController.addClass(newClass);
//   }
//
//   ClassManagerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 8, // Number of days in the week
//       child: Scaffold(
//         appBar: ProfileAppBar(
//           title: 'Class Schedule',
//           actionIcon: Icons.more_vert,
//           onActionPressed: () {  },
//           appBarbgColor: Colors.blue,
//           bottom: const TabBar(
//             isScrollable: true,
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.white,
//             dividerColor: Colors.blue,
//             tabs: [
//               Tab(text: 'Sun'),
//               Tab(text: 'Mon'),
//               Tab(text: 'Tue'),
//               Tab(text: 'Wed'),
//               Tab(text: 'Thu'),
//               Tab(text: 'Fri'),
//               Tab(text: 'Sat'),
//               Tab(text: 'Everyday'),
//
//             ],
//           ),
//         ),
//         drawer: const DrawerWidget(),
//         body: Obx(() {
//           final classes = classController.classes;
//           // print('Current classes: $classes');
//           return TabBarView(
//             children: [
//               SundayContent(classes: classes['Sunday'] ?? [], onDeleteClass:_deleteClass,),
//               MondayContent(classes: classes['Monday'] ?? [], onDeleteClass:_deleteClass,),
//               TuesdayContent(classes: classes['Tuesday'] ?? [], onDeleteClass: _deleteClass,),
//               WednesdayContent(classes: classes['Wednesday'] ?? [], onDeleteClass: _deleteClass,),
//               ThursdayContent(classes: classes['Thursday'] ?? [], onDeleteClass: _deleteClass,),
//               FridayContent(classes: classes['Friday'] ?? [],onDeleteClass: _deleteClass),
//               SaturdayContent(classes: classes['Saturday'] ?? [], onDeleteClass:_deleteClass,),
//               EverydayContent(classes: classes['Everyday'] ?? [], onDeleteClass:_deleteClass,),
//             ],
//           );
//         }),
//         floatingActionButton: SpeedDial(
//           animatedIcon: AnimatedIcons.menu_close,
//           backgroundColor: Colors.lightBlueAccent,
//           children: [
//             SpeedDialChild(
//               child: const Icon(Icons.add),
//               label: 'Add Class',
//               onTap: () {
//                 _showAddClassBottomSheet(context);
//               },
//             ),
//             SpeedDialChild(
//               child: const Icon(Icons.qr_code_scanner),
//               label: 'Scanner',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ScannerCode()),
//                 );
//               },
//             ),
//           ],
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       ),
//     );
//   }
//
//   void _showAddClassBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
//       ),
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         print("Showing bottom sheet");
//         return AddClassBottomSheet(
//           onAddClass: (ScheduleItem newClass) {
//             _addClass(newClass);  // Add class when the bottom sheet is closed
//             //Navigator.pop(context);  // Close bottom sheet
//           },
//         );
//       },
//     );
//   }
// }