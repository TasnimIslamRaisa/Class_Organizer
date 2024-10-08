import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/school/schedule/weekly_schedules.dart';
import '../models/routine.dart';
import '../models/schedule_item.dart';
import '../models/school.dart';
import '../models/user.dart';
import '../preference/logout.dart';
import '../ui/screens/controller/schedule_controller.dart';
import '../web/internet_connectivity.dart';

class DownloadPage extends StatefulWidget {
  final String scannedCode;

  DownloadPage({required this.scannedCode});

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  Routine? routine;
  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();

    if(widget.scannedCode!=''){
      _retrieveRoutine(widget.scannedCode);
    }

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
        // loadSchedules(routine);
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

  Future<void> _retrieveRoutine(String scannedCode) async {
    try {
      // Reference to the routines node in Firebase
      final DatabaseReference routinesRef = FirebaseDatabase.instance.ref('routines');

      // Query to find the routine with matching tempCode or tempNum
      Query query = routinesRef.orderByChild('tempCode').equalTo(scannedCode);

      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        final routineData = snapshot.value as Map<dynamic, dynamic>;
        final firstRoutineKey = routineData.keys.first; // Get the first result
        final routineMap = routineData[firstRoutineKey]; // Get the routine details

        setState(() {
          routine = Routine.fromMap(Map<String, dynamic>.from(routineMap));
          isLoading = false;
        });
      } else {
        // Try with tempNum if tempCode doesn't return anything
        query = routinesRef.orderByChild('tempNum').equalTo(scannedCode);
        snapshot = await query.get();

        if (snapshot.exists) {
          final routineData = snapshot.value as Map<dynamic, dynamic>;
          final firstRoutineKey = routineData.keys.first;
          final routineMap = routineData[firstRoutineKey];

          setState(() {
            routine = Routine.fromMap(Map<String, dynamic>.from(routineMap));
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            routine = null; // No routine found
          });
        }
      }
    } catch (e) {
      print('Error retrieving routine: $e');
      setState(() {
        isLoading = false;
        routine = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Routine'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator while fetching data
            : routine != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Routine Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Name: ${routine?.tempName}', style: TextStyle(fontSize: 18)),
            Text('Code: ${routine?.tempCode}', style: TextStyle(fontSize: 18)),
            Text('Details: ${routine?.tempDetails}', style: TextStyle(fontSize: 18)),
            Text('Number: ${routine?.tempNum}', style: TextStyle(fontSize: 18)),
          ],
        )
            : Text(
          'No Routine found for the scanned code!',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          // First Floating Action Button (left)
          Positioned(
            left: 30, // Adjust the left position as needed
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () async {

                setState(() {

                });
              },
              child: Icon(Icons.cloud_download_rounded),
              backgroundColor: Colors.teal,
            ),
          ),

          // Second Floating Action Button (right)
          Positioned(
            right: 30, // Adjust the right position as needed
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () async {

                if(routine!=null){
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                    if (mounted) {
                      Navigator.push(
                        context,
                        // MaterialPageRoute(builder: (context) => SchedulesPage(routine: routines[index],)),
                        // MaterialPageRoute(builder: (context) => MonthlySchedules(routine: routines[index],)),
                        MaterialPageRoute(builder: (context) => WeeklySchedules(routine: routine!,)),
                      );
                    }
                  });
                }

                setState(() {
                  // Add any additional functionality here for the second floating action button
                });
              },
              child: Icon(Icons.check_box),
              backgroundColor: Colors.purple,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
