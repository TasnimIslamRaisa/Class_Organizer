import 'dart:async';

import 'package:class_organizer/models/course_structure.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../models/major.dart';
import '../../../models/school.dart';
import '../../../models/semester.dart';
import '../../../models/subject.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart'; // For encoding/decoding data

class ClassManagerPage extends StatefulWidget {
  const ClassManagerPage({Key? key}) : super(key: key);

  @override
  _ClassManagerPageState createState() => _ClassManagerPageState();
}

class _ClassManagerPageState extends State<ClassManagerPage> {

  List<Subject> courses = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('subjects');
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

  List<Major> departments = [];
  List<CourseStructure> courseStructures = [];
  Major? _selectedDepartment;
  String? _selectedSemester;
  late Major department;
  Subject? _selectedSubject;

  int selectedSemester = 1;
  String selectedSection = 'A';

  @override
  void initState() {
    super.initState();
    _loadCourseStructures();
    _loadUserData();
    _loadCoursesData();
    _loadCourseData();
    startListening();
    checkConnection();
    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });
    _loadMajorsData();
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
        _loadMajorsData();
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

  Future<void> _loadMajorsData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      DatabaseReference majorRef = _databaseRef.child('departments');

      Query query = majorRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> majorsData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            departments = majorsData.entries.map((entry) {
              Map<String, dynamic> majorMap = {
                'id': entry.value['id'] ?? null,
                'status': entry.value['status'] ?? null,
                'uniqueId': entry.value['uniqueId'] ?? null,
                'sync_key': entry.value['sync_key'] ?? null,
                'sync_status': entry.value['sync_status'] ?? null,
                'mName': entry.value['mName'] ?? '',
                'mStart': entry.value['mStart'] ?? null,
                'mEnd': entry.value['mEnd'] ?? null,
                'mStatus': entry.value['mStatus'] ?? 0,
                'deanId': entry.value['deanId'] ?? '',
                'sId': entry.value['sId'] ?? null,
              };
              return Major.fromMap(majorMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No majors data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load majors data: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");
      setState(() {
        _isLoading = false;
      });
      final String response = await rootBundle.loadString('assets/majors.json');
      final data = json.decode(response) as List<dynamic>;
      setState(() {
        departments = data.map((json) => Major.fromJson(json)).toList();
        _isLoading = false;
      });
    }
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

  void showSnackBarMsg(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loadCoursesData() async {

    if(_selectedDepartment!=null){
      setState(() {
        department = _selectedDepartment!;
      });
      if(selectedSemester!=null){
        if (await InternetConnectionChecker().hasConnection) {
          setState(() {
            _isLoading = true;
          });


          // Reference to the subjects node in Firebase
          DatabaseReference coursesRef = _databaseRef.child('subjects');

          // Query subjects based on the school's sId only
          Query query = coursesRef.orderByChild('sId').equalTo(school?.sId);

          query.once().then((DatabaseEvent event) {
            final dataSnapshot = event.snapshot;

            if (dataSnapshot.exists) {
              final Map<dynamic, dynamic> coursesData = dataSnapshot.value as Map<dynamic, dynamic>;

              setState(() {
                courses = coursesData.entries.map((entry) {
                  Map<String, dynamic> subjectMap = {
                    'id': entry.value['id'] ?? null,
                    'subName': entry.value['subName'] ?? '',
                    'uniqueId': entry.value['uniqueId'] ?? null,
                    'sync_key': entry.value['sync_key'] ?? null,
                    'sync_status': entry.value['sync_status'] ?? null,
                    'subCode': entry.value['subCode'] ?? '',
                    'credit': entry.value['credit'] ?? 0,
                    'subFee': entry.value['subFee'] ?? 0,
                    'depId': entry.value['depId'] ?? null,
                    'departmentId': entry.value['departmentId'] ?? null,
                    'typeId': entry.value['typeId'] ?? null,
                    'status': entry.value['status'] ?? null,
                    'semester': entry.value['semester'] ?? null,
                    'program': entry.value['program'] ?? null,
                    'sId': entry.value['sId'] ?? null,
                  };
                  return Subject.fromMap(subjectMap);
                })
                // Filter the results in the app based on the department ID and semester name
                    .where((subject) {
                  print("Subject Semester: ${subject.departmentId}");
                  return subject.departmentId == department?.uniqueId &&
                      subject.semester == "${selectedSemester}";
                }).toList();
                _isLoading = false;
              });
            } else {
              print('No courses data available for the current school.');
              setState(() {
                _isLoading = false;
              });
            }
          }).catchError((error) {
            print('Failed to load courses data: $error');
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          // Handle offline mode
          setState(() {
            _isLoading = true;
          });
          showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");

          try {
            final String response = await rootBundle.loadString('assets/subjects.json');
            final data = json.decode(response) as List<dynamic>;

            setState(() {
              courses = data
                  .map((json) => Subject.fromJson(json))
              // Filter the local data similarly based on department ID and semester
                  .where((subject) =>
              subject.departmentId == department?.uniqueId &&
                  subject.semester == "${selectedSemester}")
                  .toList();
              _isLoading = false;
            });
          } catch (error) {
            print('Failed to load local subjects data: $error');
            setState(() {
              _isLoading = false;
            });
          }
        }
      }else{
        showSnackBarMsg(context, "Please, Select a Semester first.");
      }
    }else{
      showSnackBarMsg(context, "Please, Select a Department first.");
    }


  }

  Future<void> _loadCourseData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the subjects node in Firebase
      DatabaseReference coursesRef = _databaseRef.child('subjects');

      // Query subjects based on the current school's sId
      Query query = coursesRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> coursesData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            courses = coursesData.entries.map((entry) {
              Map<String, dynamic> subjectMap = {
                'id': entry.value['id'] ?? null,
                'subName': entry.value['subName'] ?? '',
                'uniqueId': entry.value['uniqueId'] ?? null,
                'sync_key': entry.value['sync_key'] ?? null,
                'sync_status': entry.value['sync_status'] ?? null,
                'subCode': entry.value['subCode'] ?? '',
                'credit': entry.value['credit'] ?? 0,
                'subFee': entry.value['subFee'] ?? 0,
                'depId': entry.value['depId'] ?? null,
                'typeId': entry.value['typeId'] ?? null,
                'status': entry.value['status'] ?? null,
                'semester': entry.value['semester'] ?? null,
                'program': entry.value['program'] ?? null,
                'sId': entry.value['sId'] ?? null,
              };
              return Subject.fromMap(subjectMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No courses data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load courses data: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // Handle offline mode
      setState(() {
        _isLoading = true;
      });
      showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");

      try {
        final String response = await rootBundle.loadString('assets/subjects.json');
        final data = json.decode(response) as List<dynamic>;

        setState(() {
          courses = data.map((json) => Subject.fromJson(json)).toList();
          _isLoading = false;
        });
      } catch (error) {
        print('Failed to load local subjects data: $error');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> saveCourseStructures(List<CourseStructure> courseStructures) async {
    if(await InternetConnectionChecker().hasConnection){
      try {
        final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('structures');

        for (var course in courseStructures) {
          await _databaseRef.child(course.uniqueId!).set(course.toMap());
        }
        showSnackBarMsg(context, "Courses saved successfully!"); // Optionally inform the user
      } catch (e) {
        showSnackBarMsg(context, "Error: failed to save courses: ${e.toString()}");
      }
    }else{
      showSnackBarMsg(context, "Your are in offline mode now!, Please connect to Internet");
    }
  }


  // Function to save data to SharedPreferences
  Future<void> _saveData() async {

    if(_selectedDepartment!=null){
      if(selectedSemester!=null){
        if(courseStructures.isNotEmpty){
          saveCourseStructures(courseStructures);
        }
      }else{
        showSnackBarMsg(context, "Please, Select a Semester first.");
      }
    }else{
      showSnackBarMsg(context, "Please, Select a Department first.");
    }

  }

  // Function to add a new course via a pop-up dialog
  void _addNewCourse() {

    if(_selectedDepartment!=null){
      showDialog(
        context: context,
        builder: (BuildContext context) {

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Please select your course'),
                content: DropdownSearch<Subject>(
                  items: courses,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Subject',
                      prefixIcon: Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onChanged: (Subject? selected) {
                    setState(() {
                      _selectedSubject = selected;
                    });
                  },
                  selectedItem: _selectedSubject,
                  popupProps: PopupProps.menu(
                    showSearchBox: true, // Enables the search box for subjects
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text("SEM: ${item.semester ?? "-"} - "+ "${item.subName ?? "No Name"}"), // Display subject name
                      subtitle: Text(
                        "Subject Code: ${item.subCode ?? ''} - " +
                            (item.departmentId == department?.uniqueId ? "This Department" : "Different Department"),
                      ),
                    ),
                  ),
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem?.subName ?? "No Subject Selected", // Display selected subject's name
                    );
                  },
                ),
                actions: [
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog without adding
                    },
                  ),
                  TextButton(
                    child: const Text('CONFIRM'),
                    onPressed: () {
                      setState(() {
                        // pendingCourse = _selectedSubject;
                      });
                      Navigator.of(context).pop(); // Close dialog
                      _selectSection(); // Confirm the selection after course is added
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }else{
      showSnackBarMsg(context, "Please, Select a Department first.");
    }

  }

  // Function to confirm the selection of course and section
  void _selectSection() {

    if (_selectedSubject != null) {
      setState(() {
        // Create a new CourseStructure object
        CourseStructure courseStructure = CourseStructure(
          id: courseStructures.length+1,
          subName: _selectedSubject!.subName,
          subCode: _selectedSubject!.subCode,
          section: selectedSection,
          semester: selectedSemester != null ? selectedSemester.toString() : null,
          uniqueId: Unique().generateUniqueID(),
          userId: _user?.uniqueid,
          sId: school?.sId,
        );

        courseStructures.add(courseStructure);
        // You can now use courseStructure as needed, such as saving it to a database
        print('CourseStructure created: ${courseStructure.toMap()}');

        // Further actions like adding it to a list or saving it
      });
    }


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Manager'),
        backgroundColor: Colors.lightBlue, // Changed to sky blue
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownSearch<Major>(
                            items: departments,  // Assuming you have a list of faculties
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Select Department/Faculty',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onChanged: (Major? selectedDepartment) {
                              setState(() {
                                _selectedDepartment = selectedDepartment;
                                department = selectedDepartment!;
                              });
                            },
                            selectedItem: _selectedDepartment,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) => ListTile(
                                title: Text(item.mName ?? 'Unknown Department'),
                              ),
                            ),
                            dropdownBuilder: (context, selectedItem) {
                              return Text(
                                selectedItem?.mName ?? "No Department Selected",
                                style: TextStyle(fontSize: 14),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Semester and Section inputs
                    Row(
                      children: [
                        // Semester dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background, // Use background color from theme
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).colorScheme.primary), // Use primary color from theme
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Semester',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onBackground, // or onSurface
                                    fontSize: 16, // Adjust the font size as needed
                                    fontWeight: FontWeight.bold, // Adjust the font weight if needed
                                  ),
                                ),
                                DropdownButton<int>(
                                  value: selectedSemester,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedSemester = newValue!;
                                    });
                                  },
                                  items: List.generate(12, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1, // Semesters 1-8
                                      child: Text('Semester ${index + 1}'),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Section dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background, // Use the theme's background color
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).colorScheme.primary), // Use the theme's primary color
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Section',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onBackground, // or onSurface
                                    fontSize: 16, // Adjust the font size as needed
                                    fontWeight: FontWeight.bold, // Adjust the font weight if needed
                                  ),
                                ),

                                DropdownButton<String>(
                                  value: selectedSection,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSection = newValue!;
                                    });
                                  },
                                  items: List.generate(20, (index) {
                                    if (index % 2 == 0) {
                                      // Even indices for letters
                                      String sectionLetter = String.fromCharCode(65 + index ~/ 2); // A-J
                                      return DropdownMenuItem(
                                        value: sectionLetter,
                                        child: Text(sectionLetter),
                                      );
                                    } else {
                                      // Odd indices for numbers
                                      String sectionNumber = ((index + 1) ~/ 2).toString(); // 1-10
                                      return DropdownMenuItem(
                                        value: sectionNumber,
                                        child: Text(sectionNumber),
                                      );
                                    }
                                  }),
              
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
              
                    // Display selected courses below the Semester and Section containers
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
                                      Text(
                                        'Course: ${course.subName}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onBackground, // or onSurface
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Section: ${course.section}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onBackground, // or onSurface
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Semester: ${course.semester}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onBackground, // or onSurface
                                        ),
                                      ),
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
              
              
                    const SizedBox(height: 20),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         child: ElevatedButton(
                    //           onPressed: _addNewCourse,
                    //           child: const Text('ADD NEW COURSE'),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 16), // Space between buttons
                    //       Expanded(
                    //         child: ElevatedButton(
                    //           onPressed: _saveData,
                    //           child: const Text('SAVE'),
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: Colors.blue,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Add new course button
                    // ElevatedButton(
                    //   onPressed: _addNewCourse,
                    //   child: const Text('ADD NEW COURSE'),
                    // ),
                    //
                    // // Save button to persist the courses
                    // ElevatedButton(
                    //   onPressed: _saveData, // Save the updated list of courses
                    //   child: const Text('SAVE'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue, // Button color
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addNewCourse,
                    child: const Text('ADD NEW COURSE'),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveData,
                    child: const Text('SAVE STRUCTURE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
