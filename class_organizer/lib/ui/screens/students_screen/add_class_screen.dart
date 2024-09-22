import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/models/schedule_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../models/class_model.dart';
import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class AddClassBottomSheet extends StatefulWidget {
  final void Function(ScheduleItem) onAddClass;

  AddClassBottomSheet({super.key, required this.onAddClass});

  @override
  State<AddClassBottomSheet> createState() => _AddClassBottomSheetState();
}

class _AddClassBottomSheetState extends State<AddClassBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _teacherController = TextEditingController();
  final _sectionController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endingtimeController = TextEditingController();
  final _classroomController = TextEditingController();

  String selectedDay = 'Everyday'; // Default selected day
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

  // Time picker for better time input
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context); // Format the selected time
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return; // If validation fails, don't submit
    }

    final newClass = ScheduleItem(
      subName: _courseNameController.text,
      subCode: _courseCodeController.text,
      tName: _teacherController.text,
      section: _sectionController.text,
      startTime: _starttimeController.text,
      endTime: _endingtimeController.text,
      room: _classroomController.text,
      day: selectedDay,
    );

    // saveNewSchedule(newClass);

    widget.onAddClass(newClass);
    Navigator.pop(context); // Close the bottom sheet

    // Clear input fields after submission
    _courseNameController.clear();
    _courseCodeController.clear();
    _teacherController.clear();
    _sectionController.clear();
    _starttimeController.clear();
    _endingtimeController.clear();
    _classroomController.clear();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Your Class", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedDay,
                items: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Everyday']
                    .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _courseNameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _courseCodeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(labelText: 'Teacher Initial'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the teacher\'s initials';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(labelText: 'Section'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the section';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _starttimeController,
                readOnly: true, // To prevent manual editing
                onTap: () => _selectTime(context, _starttimeController),
                decoration: const InputDecoration(labelText: 'Start Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the start time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _endingtimeController,
                readOnly: true,
                onTap: () => _selectTime(context, _endingtimeController),
                decoration: const InputDecoration(labelText: 'Ending Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the end time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _classroomController,
                decoration: const InputDecoration(labelText: 'Classroom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the classroom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Add Class'),
              ),
            ],
          ),
        ),
      ),

    );
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _teacherController.dispose();
    _sectionController.dispose();
    _starttimeController.dispose();
    _endingtimeController.dispose();
    _classroomController.dispose();
    super.dispose();
  }
}
