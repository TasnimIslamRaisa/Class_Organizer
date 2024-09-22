import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/utility/unique.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../admin/school/schedule/weekly_schedules.dart';
import '../models/routine.dart';
import '../models/schedule_item.dart';
import '../models/school.dart';
import '../models/user.dart';
import '../preference/logout.dart';
import '../ui/screens/controller/schedule_controller.dart';
import '../web/internet_connectivity.dart';

class DownloadRoutine extends StatefulWidget {
  final String scannedCode;

  DownloadRoutine({required this.scannedCode});

  @override
  _DownloadRoutineState createState() => _DownloadRoutineState();
}

class _DownloadRoutineState extends State<DownloadRoutine> {
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
  String? tidCode ;

  @override
  void initState() {
    super.initState();

    if(widget.scannedCode!=''){
      _retrieveRoutine(widget.scannedCode);
    }

    if(routine!=null){
      loadSchedules(routine!);
    }else{
      print("empty routine");
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
        // loadSchedules(routine!);
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
    try {
      if (await InternetConnectionChecker().hasConnection) {
        setState(() {
          _isLoading = true;
        });

        // Reference to the schedules node in Firebase
        DatabaseReference schedulesRef = _databaseRef.child('schedules');

        // Query schedules that match the given tempCode from the routine
        Query query = schedulesRef.orderByChild('temp_code').equalTo(routine.tempCode);

        DataSnapshot dataSnapshot = await query.get();

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
              'dateTime': entry.value['dateTime'] != null
                  ? DateTime.parse(entry.value['dateTime'])
                  : null,
            };
            return ScheduleItem.fromMap(scheduleMap);
          }).toList();

          // Pass the fetched schedules to the ScheduleController
          scheduleController.setSchedules(fetchedSchedules);

          setState(() {
            schedules = fetchedSchedules;
            _isLoading = false;
          });
        } else {
          print('No schedules available for the given routine.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Handle offline mode
        setState(() {
          _isLoading = false;
        });
        showSnackBarMsg(context, "You are offline. Please connect to the internet.");
      }
    } catch (error) {
      print('Failed to load schedules: $error');
      setState(() {
        _isLoading = false;
      });
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
          tidCode = routine?.tempCode;
          print(tidCode);
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
            tidCode = routine?.tempCode;
            print(tidCode);
            loadSchedules(routine!);
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

  void saveNewRoutine(Routine routine) async {
    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();
    var uuid = Uuid();

    if (routine != null) {
      routine.tempName = DateFormat('EEE, MMM d').format(DateTime.now());
      routine.tId = tidCode;
      routine.stdId = routine.tempNum;
      routine.sId = _user?.uniqueid;
      routine.uId = _user?.uniqueid;
      routine.uniqueId = uniqueId;
      routine.tempCode = uuid.v4();
      routine.tempNum = Unique().generateHexCode();

      if (await InternetConnectionChecker().hasConnection) {
        DatabaseReference routinesRef = FirebaseDatabase.instance.ref("routines");
        Query query = routinesRef.orderByChild('tId').equalTo(tidCode);

        DataSnapshot snapshot = await query.get();

        if (snapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Routine with these Schedules already exists!')),
          );
          return; // Exit the function if routine already exists
        } else {
          // Proceed with saving the routine if it doesn't exist
          if (routine.uniqueId != null && routine.uniqueId!.isNotEmpty) {
            final DatabaseReference routineRef = FirebaseDatabase.instance
                .ref("routines")
                .child(routine.uniqueId!);

            routineRef.set(routine.toMap()).then((_) {
              setState(() {
                saveSchedules(routine);
              });
              // Navigator.of(context).pop();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine and Schedule'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator while fetching data
            : routine != null
            ? Column(
          children: [
            // Top Routine Card
            Card(
              color: Colors.redAccent,
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save this Routine on Schedule List!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Routine Name: ${routine?.tempName ?? ''}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Routine Details: ${routine?.tempDetails ?? ''}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50, // Increased the height for better visibility
                      decoration: BoxDecoration(
                        color: Colors.blueAccent, // Background color for the container
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: Center(
                        child: (schedules.isNotEmpty)
                            ? ElevatedButton(
                          onPressed: () async {

                              if(schedules!=null){
                                saveNewRoutine(routine!);
                              }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color of the button
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners for button
                            ),
                          ),
                          child: Text(
                            'Save All Schedules',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                            : Text(
                          'Load Schedules',
                          style: TextStyle(
                            color: Colors.white, // Text color for empty message
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )



                  ],
                ),
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Add search functionality based on the schedules list here
                  // You can filter scheduleItems based on the search query
                },
              ),
            ),
            // Schedule Items List
            Expanded(
              child: schedules.isEmpty
                  ? Center(child: Text('No schedules available!'))
                  : ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        schedule.subName ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${schedule.tName}'),
                          Text('Room: ${schedule.room}'),
                          Text('Time: ${schedule.startTime} - ${schedule.endTime}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.details),
                        onPressed: () {
                          // Add functionality to view detailed schedule information
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
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
                  saveNewRoutine(routine!);
                setState(() {

                });
              },
              child: Icon(Icons.save_outlined),
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
              child: Icon(Icons.navigate_next_outlined),
              backgroundColor: Colors.purple,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void saveSchedules(Routine routine) async {

    if(schedules.isNotEmpty){
      await _loadUserData();
      for(ScheduleItem newSchedule in schedules){
        String uniqueId = Unique().generateUniqueID();
        var uuid = Uuid();

        if (newSchedule.subName!.isNotEmpty && newSchedule.subCode!.isNotEmpty) {

          newSchedule.uniqueId = uniqueId;
          newSchedule.id = null;
          newSchedule.sId = school?.sId;
          newSchedule.tempCode = routine.tempCode;
          newSchedule.tempNum = routine.tempNum;
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
    }else{
      showSnackBarMsg(context, "Schedules List is Empty!");
    }

  }
}
