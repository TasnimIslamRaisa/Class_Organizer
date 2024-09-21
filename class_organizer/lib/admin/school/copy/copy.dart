import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';

class AddScheduleScreen extends StatefulWidget {
  final void Function(ScheduleItem) onAddClass;

  const AddScheduleScreen({Key? key, required this.onAddClass}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subNameController = TextEditingController();
  final _subCodeController = TextEditingController();
  final _teacherController = TextEditingController();
  final _sectionController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _roomController = TextEditingController();

  String selectedDay = 'Everyday';

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
      subName: _subNameController.text,
      subCode: _subCodeController.text,
      tName: _teacherController.text,
      section: _sectionController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      room: _roomController.text,
      day: selectedDay,
    );

    widget.onAddClass(newClass);

    // Clear input fields after submission
    _subNameController.clear();
    _subCodeController.clear();
    _teacherController.clear();
    _sectionController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    _roomController.clear();

    Navigator.pop(context); // Close the bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              Text("Add New Schedule", style: Theme.of(context).textTheme.titleLarge),
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
                controller: _subNameController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subCodeController,
                decoration: const InputDecoration(
                  labelText: 'Subject Code',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                  labelText: 'Teacher Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the teacher\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  prefixIcon: Icon(Icons.class_),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the section';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _startTimeController,
                readOnly: true, // To prevent manual editing
                onTap: () => _selectTime(context, _startTimeController),
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the start time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                onTap: () => _selectTime(context, _endTimeController),
                decoration: const InputDecoration(
                  labelText: 'End Time',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the end time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Room',
                  prefixIcon: Icon(Icons.room),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room';
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
    _subNameController.dispose();
    _subCodeController.dispose();
    _teacherController.dispose();
    _sectionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _roomController.dispose();
    super.dispose();
  }
}


















// import 'dart:convert';
//
// import 'package:class_organizer/models/subject.dart';
// import 'package:class_organizer/models/schedule_item.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../models/school.dart';
// import '../../../../models/user.dart';
// import '../../../../preference/logout.dart';
//
// class AddScheduleScreen extends StatefulWidget {
//   final void Function(ScheduleItem) onAddClass;
//
//   const AddScheduleScreen({
//     Key? key,
//     required this.onAddClass,
//   }) : super(key: key);
//
//   @override
//   State<AddScheduleScreen> createState() => _AddScheduleScreenState();
// }
//
// class _AddScheduleScreenState extends State<AddScheduleScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _teacherController = TextEditingController();
//   final _sectionController = TextEditingController();
//   final _startTimeController = TextEditingController();
//   final _endTimeController = TextEditingController();
//   final _roomController = TextEditingController();
//
//   final _databaseRef = FirebaseDatabase.instance.ref();
//   List<Subject> availableSubjects = [];
//   String selectedDay = 'Everyday';
//   Subject? selectedSubject;
//   School? school;
//   String? userName;
//   String? userPhone;
//   String? userEmail;
//   User? _user, _user_data;
//   String? sid;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadCoursesData();
//   }
//   Future<void> _loadUserData() async {
//     Logout logout = Logout();
//     User? user = await logout.getUserDetails(key: 'user_data');
//
//     Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
//     Map<String, dynamic>? schoolMap = await logout.getSchool(key: 'school_data');
//
//     if (userMap != null) {
//       User user_data = User.fromMap(userMap);
//       setState(() {
//         _user_data = user_data;
//       });
//     } else {
//       print("User map is null");
//     }
//
//     if (schoolMap != null) {
//       School schoolData = School.fromMap(schoolMap);
//       setState(() {
//         _user = user;
//         school = schoolData;
//         sid = school?.sId;
//         print(schoolData.sId);
//       });
//     } else {
//       print("School data is null");
//     }
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userDataString = prefs.getString('user_logged_in');
//
//     if (userDataString != null) {
//       Map<String, dynamic> userData = jsonDecode(userDataString);
//       setState(() {
//         userName = userData['uname'];
//         userPhone = userData['phone'];
//         userEmail = userData['email'];
//       });
//     }
//   }
//
//   Future<void> _loadCoursesData() async {
//     if (await InternetConnectionChecker().hasConnection) {
//
//
//       // Reference to the subjects node in Firebase
//       DatabaseReference coursesRef = _databaseRef.child('subjects');
//
//       // Query subjects based on the current school's sId
//       Query query = coursesRef.orderByChild('sId').equalTo(school?.sId);
//
//       query.once().then((DatabaseEvent event) {
//         final dataSnapshot = event.snapshot;
//
//         if (dataSnapshot.exists) {
//           final Map<dynamic, dynamic> coursesData = dataSnapshot.value as Map<dynamic, dynamic>;
//
//           setState(() {
//             availableSubjects = coursesData.entries.map((entry) {
//               Map<String, dynamic> subjectMap = {
//                 'id': entry.value['id'] ?? null,
//                 'subName': entry.value['subName'] ?? '',
//                 'uniqueId': entry.value['uniqueId'] ?? null,
//                 'sync_key': entry.value['sync_key'] ?? null,
//                 'sync_status': entry.value['sync_status'] ?? null,
//                 'subCode': entry.value['subCode'] ?? '',
//                 'credit': entry.value['credit'] ?? 0,
//                 'subFee': entry.value['subFee'] ?? 0,
//                 'depId': entry.value['depId'] ?? null,
//                 'typeId': entry.value['typeId'] ?? null,
//                 'status': entry.value['status'] ?? null,
//                 'semester': entry.value['semester'] ?? null,
//                 'program': entry.value['program'] ?? null,
//                 'sId': entry.value['sId'] ?? null,
//               };
//               return Subject.fromMap(subjectMap);
//             }).toList();
//
//           });
//         } else {
//           print('No courses data available for the current school.');
//
//         }
//       }).catchError((error) {
//         print('Failed to load courses data: $error');
//
//       });
//     } else {
//       // Handle offline mode
//
//       showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");
//
//       try {
//         final String response = await rootBundle.loadString('assets/subjects.json');
//         final data = json.decode(response) as List<dynamic>;
//
//         setState(() {
//           availableSubjects = data.map((json) => Subject.fromJson(json)).toList();
//         });
//       } catch (error) {
//         print('Failed to load local subjects data: $error');
//       }
//     }
//   }
//
//   void showSnackBarMsg(BuildContext context, String message) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = picked.format(context); // Format the selected time
//       });
//     }
//   }
//
//   void _submitForm(BuildContext context) {
//     if (!_formKey.currentState!.validate()) {
//       return; // If validation fails, don't submit
//     }
//
//     final newClass = ScheduleItem(
//       subName: selectedSubject?.subName ?? '',
//       subCode: selectedSubject?.subCode ?? '',
//       tName: _teacherController.text,
//       section: _sectionController.text,
//       startTime: _startTimeController.text,
//       endTime: _endTimeController.text,
//       room: _roomController.text,
//       day: selectedDay,
//     );
//
//     widget.onAddClass(newClass);
//
//     // Clear input fields after submission
//     _teacherController.clear();
//     _sectionController.clear();
//     _startTimeController.clear();
//     _endTimeController.clear();
//     _roomController.clear();
//
//     setState(() {
//       selectedSubject = null;
//     });
//
//     Navigator.pop(context); // Close the bottom sheet
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Add New Schedule", style: Theme.of(context).textTheme.titleLarge),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: selectedDay,
//                 items: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Everyday']
//                     .map((day) => DropdownMenuItem(value: day, child: Text(day)))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedDay = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 8),
//
//               // Dropdown for selecting Subject
//               DropdownButtonFormField<Subject>(
//                 value: selectedSubject,
//                 decoration: const InputDecoration(
//                   labelText: 'Subject',
//                   prefixIcon: Icon(Icons.book),
//                 ),
//                 items: availableSubjects.map((subject) {
//                   return DropdownMenuItem(
//                     value: subject,
//                     child: Text(subject.subName ?? ''),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedSubject = value; // Update the selected subject
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select a subject';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _teacherController,
//                 decoration: const InputDecoration(
//                   labelText: 'Teacher Name',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the teacher\'s name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _sectionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Section',
//                   prefixIcon: Icon(Icons.class_),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the section';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _startTimeController,
//                 readOnly: true, // To prevent manual editing
//                 onTap: () => _selectTime(context, _startTimeController),
//                 decoration: const InputDecoration(
//                   labelText: 'Start Time',
//                   prefixIcon: Icon(Icons.access_time),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select the start time';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _endTimeController,
//                 readOnly: true,
//                 onTap: () => _selectTime(context, _endTimeController),
//                 decoration: const InputDecoration(
//                   labelText: 'End Time',
//                   prefixIcon: Icon(Icons.access_time),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select the end time';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _roomController,
//                 decoration: const InputDecoration(
//                   labelText: 'Room',
//                   prefixIcon: Icon(Icons.room),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the room';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _submitForm(context),
//                 child: const Text('Add Class'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _teacherController.dispose();
//     _sectionController.dispose();
//     _startTimeController.dispose();
//     _endTimeController.dispose();
//     _roomController.dispose();
//     super.dispose();
//   }
// }