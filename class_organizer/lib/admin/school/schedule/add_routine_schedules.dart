import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/admin/school/schedule/screen/add_schedule_screen.dart';
import 'package:class_organizer/admin/school/schedule/single_day_schedule.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/class_model.dart';
import '../../../models/course_structure.dart';
import '../../../models/routine.dart';
import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../ui/screens/controller/class_routine_controller.dart';
import '../../../ui/screens/controller/schedule_controller.dart';
import '../../../ui/screens/students_screen/add_class_screen.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class AddRoutineSchedules extends StatefulWidget {
  final Routine routine;
  final List<ScheduleItem> schedules;
  AddRoutineSchedules({required this.routine, required this.schedules});

  @override
  _AddRoutineSchedulesState createState() => _AddRoutineSchedulesState();
}

class _AddRoutineSchedulesState extends State<AddRoutineSchedules> {
  late List<String> tabTitles;
  late List<DateTime> dateList;

  final ScheduleController scheduleController = Get.put(ScheduleController());
  List<ScheduleItem> schedules = [];
  List<ScheduleItem> selectedSchedules = [];

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
  List<CourseStructure> courseStructures = [];
  late String tidCode;

  void _addSchedule(ScheduleItem newSchedule) {
    saveNewRoutine(newSchedule);
    // scheduleController.addSchedule(newSchedule);
  }

  @override
  void initState() {
    super.initState();
    generateDateList();
    loadSchedules(widget.routine);
    _loadCourseStructures();
    _loadUserData();
    startListening();
    checkConnection();
    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });
    tidCode = widget.routine.tempCode!;

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
        floatingActionButton: Stack(
          children: <Widget>[
            // First Floating Action Button (left)
            Positioned(
              left: 30, // Adjust the left position as needed
              bottom: 20,
              child: FloatingActionButton(
                heroTag: 'uniqueTag1',
                onPressed: () async {

                  _showStructureForm(context);

                  _loadCourseStructures();

                },
                child: Icon(Icons.copy_all),
                backgroundColor: Colors.teal,
              ),
            ),

            // Second Floating Action Button (right)
            Positioned(
              right: 30, // Adjust the right position as needed
              bottom: 20,
              child: FloatingActionButton(
                heroTag: 'uniqueTag2',
                onPressed: () async {

                  setState(() {
                    // Add any additional functionality here for the second floating action button
                  });
                },
                child: Icon(Icons.saved_search_outlined),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            schedules = fetchedSchedules;
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

  void _showStructureForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Your Course Structure',
          [


            if (courseStructures.isNotEmpty)
              Column(
                children: courseStructures.map((course) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Course: ${course.subName}'), // Access subName directly from the model
                              const SizedBox(height: 4),
                              Text('Section: ${course.section}'), // Access section directly from the model
                              const SizedBox(height: 4),
                              Text('Semester: ${course.semester}'), // Access semester directly from the model
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            _removeCourse(course); // Remove the selected course
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

          ],
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, String title, List<Widget> fields) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: fields,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Center(child: Text('SAVE')),
                onPressed: setSchedulesRoutine,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadCourseStructures() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the course structures node in Firebase
      DatabaseReference courseStructuresRef = _databaseRef.child('structures');

      // Query course structures based on the current school's sId
      Query query = courseStructuresRef.orderByChild('userId').equalTo(_user?.uniqueid);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> courseStructuresData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            courseStructures = courseStructuresData.entries.map((entry) {
              Map<String, dynamic> courseMap = {
                'id': entry.value['id'] ?? null,
                'subName': entry.value['subName'] ?? '',
                'subCode': entry.value['subCode'] ?? '',
                'section': entry.value['section'] ?? '',
                'semester': entry.value['semester'] ?? '',
                'uniqueId': entry.value['uniqueId'] ?? null,
                'userId': entry.value['userId'] ?? null,
                'sId': entry.value['sId'] ?? null,
              };
              return CourseStructure.fromMap(courseMap); // Adjusted to use CourseStructure
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No course structures data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load course structures data: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // Handle offline mode
      setState(() {
        _isLoading = true;
      });
      showSnackBarMsg(context, "You are in Offline mode now, Please connect to the Internet!");

      try {
        final String response = await rootBundle.loadString('assets/course_structures.json'); // Change to the correct file
        final data = json.decode(response) as List<dynamic>;

        setState(() {
          courseStructures = data.map((json) => CourseStructure.fromJson(json)).toList();
          _isLoading = false;
        });
      } catch (error) {
        print('Failed to load local course structures data: $error');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeCourse(CourseStructure course) async {
    if(await InternetConnectionChecker().hasConnection){
      await _deleteCourse(course);
    }else{
      showSnackBarMsg(context, "Hey! You are in Offline mode now, Please connect to the Internet!");
    }
  }

  Future<void> _deleteCourse(CourseStructure course) async {
    try {
      final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('structures');

      // Reference to the specific course to be deleted
      DatabaseReference courseRef = _databaseRef.child(course.uniqueId!);

      // Remove the course from Firebase
      await courseRef.remove();

      // Optionally, remove the course from the local list if needed
      setState(() {
        courseStructures.remove(course); // Remove from the local list
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course deleted successfully')),
      );
    } catch (e) {
      print('Failed to delete course: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete course: $e')),
      );
    }
  }

  void setSchedulesRoutine() {
    Navigator.pop(context);
    showSnackBar(context,null);
    selectedSchedules.clear();
    if(schedules.isEmpty){
      loadSchedules(widget.routine);
    }

    if(schedules.isNotEmpty){
      // print("Selected schedules: ${schedules.length} ");
      for (CourseStructure course in courseStructures) {
        // Filter schedules that match the course's subCode and section
        var matchingSchedules = schedules.where((schedule) =>
        schedule.subCode != null &&  // Ensure subCode is not null
            schedule.section != null &&  // Ensure section is not null
            schedule.subCode == course.subCode &&
            schedule.section == course.section).toList();  // Use toList() to ensure it returns a list

        // print("Selected schedulesss: $matchingSchedules");
        // Add matching schedules to the selectedSchedules list
        selectedSchedules.addAll(matchingSchedules);
      }


      // Handle if selectedSchedules is empty or not
      if (selectedSchedules.isEmpty) {
        showSnackBarMsg(context, "No matching schedules found!");
      } else {
        saveRoutine(widget.routine);
        print("Selected schedules: ${selectedSchedules.length}");
      }
    }else{
      loadSchedules(widget.routine);
    }

  }

  void saveRoutine(Routine routine) async {
    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();
    var uuid = Uuid();

    Routine newRoutine = new Routine();

    newRoutine = routine;

    if (newRoutine != null) {
      newRoutine.tId = tidCode;
      newRoutine.stdId = newRoutine.tempNum;
      newRoutine.sId = _user?.uniqueid;
      newRoutine.uId = _user?.uniqueid;
      newRoutine.uniqueId = uniqueId;
      newRoutine.tempCode = uuid.v4();
      newRoutine.tempNum = Unique().generateHexCode();

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
          if (newRoutine.uniqueId != null && newRoutine.uniqueId!.isNotEmpty) {
            final DatabaseReference routineRef = FirebaseDatabase.instance
                .ref("routines")
                .child(newRoutine.uniqueId!);

            routineRef.set(newRoutine.toMap()).then((_) {
              setState(() {
                saveSchedules(newRoutine);
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

  void saveSchedules(Routine routine) async {

    if(selectedSchedules.isNotEmpty){
      await _loadUserData();
      for(ScheduleItem newSchedule in selectedSchedules){
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
                  // schedules.add(newSchedule);
                  // scheduleController.addSchedule(newSchedule);
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

  void floatShowSnackBar(BuildContext context, String msg) {
    if(msg==null)
      msg = "Please hang tight! We're matching your schedule with the course structure. This might take a moment.";
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white), // Customize text color
      ),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void floatSnackBarMsg(BuildContext context, String? msg) {
    final snackBarMessage = msg ?? "Please hang tight! We're matching your schedule with the course structure. This might take a moment.";

    final snackBar = SnackBar(
      content: Text(
        snackBarMessage,
        style: TextStyle(color: Colors.white), // Customize text color
      ),
      backgroundColor: Colors.blueAccent, // Change background color
      duration: Duration(seconds: 5), // Set duration for SnackBar
      behavior: SnackBarBehavior.floating, // Make SnackBar float above the bottom
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBar(BuildContext context, String? msg) {
    final snackBarMessage = msg ?? "Please hang tight! We're matching your schedule with the course structure. This might take a moment.";

    final snackBar = SnackBar(
      content: Text(snackBarMessage),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



}