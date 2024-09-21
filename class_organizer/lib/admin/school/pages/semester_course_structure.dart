import 'dart:async';
import 'dart:convert';
import 'package:class_organizer/models/semester.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/major.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/school.dart';
import '../../../models/subject.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class SemesterCourseStructure extends StatefulWidget {
  final Semester semester;
  final Major department;

  const SemesterCourseStructure({super.key, required this.semester, required this.department});

  @override
  _SemesterCourseStructureState createState() => _SemesterCourseStructureState();
}

class _SemesterCourseStructureState extends State<SemesterCourseStructure> {
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _subjectFeeController = TextEditingController();
  final TextEditingController _subjectCreditController = TextEditingController();
  final TextEditingController _selectedTypeId = TextEditingController();
  List<Subject> subjects = [];
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
  Major? _selectedDepartment;
  String? _selectedSemester;
  late Major department;
  late Semester semester;
  Subject? _selectedSubject;

  @override
  void initState() {
    super.initState();
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
    setState(() {
      semester = widget.semester;
      department = widget.department;
      _selectedSemester = "${semester?.semName}";

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

  @override
  void dispose() {
    _subjectNameController.dispose();
    _subjectCodeController.dispose();
    _subjectFeeController.dispose();
    _subjectCreditController.dispose();
    _selectedTypeId.dispose();
    super.dispose();
  }

  Future<void> setSubjectToSemester() async {
    _selectedSubject?.departmentId = department.uniqueId;
    _selectedSubject?.semester = "${semester.semName}";

    Subject updatedSubject = _selectedSubject!;

    if (await InternetConnectionChecker().hasConnection) {
    if (updatedSubject.uniqueId != null && updatedSubject.uniqueId!.isNotEmpty) {
    final DatabaseReference _database = FirebaseDatabase.instance
        .ref("subjects")
        .child(updatedSubject.uniqueId!);

    // Update the existing subject with new values
    _database.update(updatedSubject.toMap()).then((_) {
    setState(() {
    // Update the local subjects list with the updated subject
    int index = subjects.indexWhere((subject) => subject.uniqueId == updatedSubject.uniqueId);
    if (index != -1) {
    subjects[index] = updatedSubject;
    }
    });
    Navigator.of(context).pop();
    _loadCoursesData();
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Subject updated')),
    );
    }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to update subject: $error')),
    );
    print("Error updating subject: $error");
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
  }

  void saveNewSubject() async {
    String subjectName = '${_subjectNameController.text.trim()} (${department?.mName ?? "UD"})';
    String subjectCode = _subjectCodeController.text.trim();
    String credit = _subjectCreditController.text.trim();


    await _loadUserData();
    var uuid = Uuid();
    String uniqueId = Unique().generateUniqueID();

    int typeId;

    typeId = int.tryParse(_selectedTypeId.text.trim()) ?? 0;

    if(_selectedSemester==null){
      _selectedSemester = "0";
    }

    if (subjectName.isNotEmpty && subjectCode.isNotEmpty) {
      Subject newSubject = Subject(
        id: null,
        subName: subjectName,
        uniqueId: uniqueId,
        subCode: subjectCode,
        credit: credit,
        subFee: _subjectFeeController.text.trim(),
        depId: null,
        departmentId: department?.uniqueId,
        program: null,
        typeId: typeId,
        semester: _selectedSemester,
        sId: school?.sId,
        status: 1,
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newSubject.uniqueId != null && newSubject.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("subjects")
              .child(newSubject.uniqueId!);

          _database.set(newSubject.toMap()).then((_) {
            setState(() {
              subjects.add(newSubject);
            });
            _subjectNameController.clear();
            _subjectCodeController.clear();
            _subjectCreditController.clear();
            _subjectFeeController.clear();
            _selectedTypeId.clear();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Subject added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add subject: $error')),
            );
            print("Error adding subject: $error");
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


  void editSubject(int index) {
    print('Editing ${subjects[index].subName}');
  }

  void duplicateSubject(int index) {
    setState(() {
      subjects.add(Subject(
        id: null,
        subName: '${subjects[index].subName} (Duplicate)',
        uniqueId: '${subjects[index].uniqueId}-DUP',
        credit: subjects[index].credit,
        subCode: subjects[index].subCode,
        subFee: subjects[index].subFee,
        depId: subjects[index].depId,
        program: subjects[index].program,
        typeId: subjects[index].typeId,
        semester: subjects[index].semester,
        sId: subjects[index].sId,
        status: subjects[index].status,
        syncStatus: subjects[index].syncStatus,
        syncKey: subjects[index].syncKey,
      ));
    });
  }


  void deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  void showSubjectDetails(int index) {
    final subject = subjects[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${subject.subName} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject ID: ${subject.uniqueId}'),
              Text('Subject Code: ${subject.subCode}'),
              Text('Credits: ${subject.credit}'),
              Text('Fee: \$${subject.subFee}'),
              Text('Department ID: ${subject.depId}'),
              Text('Program: ${subject.program}'),
              Text('Type ID: ${subject.typeId}'),
              Text('Semester: ${subject.semester}'),
              Text('Status: ${subject.status == 1 ? 'Active' : 'Inactive'}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadCoursesData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Debug: Print the department and semester
      print("Department ID: ${department?.uniqueId}");
      print("Semester Name: ${semester?.semName}");

      // Reference to the subjects node in Firebase
      DatabaseReference coursesRef = _databaseRef.child('subjects');

      // Query subjects based on the school's sId only
      Query query = coursesRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> coursesData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            subjects = coursesData.entries.map((entry) {
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
                  subject.semester == "${semester?.semName}";
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
          subjects = data
              .map((json) => Subject.fromJson(json))
          // Filter the local data similarly based on department ID and semester
              .where((subject) =>
          subject.departmentId == department?.uniqueId &&
              subject.semester == "${semester?.semName}")
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
  }


  // Future<void> _loadCoursesData() async {
  //   if (await InternetConnectionChecker().hasConnection) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     // Reference to the subjects node in Firebase
  //     DatabaseReference coursesRef = _databaseRef.child('subjects');
  //
  //     // Query subjects based on the current school's sId
  //     Query query = coursesRef.orderByChild('sId').equalTo(school?.sId);
  //
  //     query.once().then((DatabaseEvent event) {
  //       final dataSnapshot = event.snapshot;
  //
  //       if (dataSnapshot.exists) {
  //         final Map<dynamic, dynamic> coursesData = dataSnapshot.value as Map<dynamic, dynamic>;
  //
  //         setState(() {
  //           subjects = coursesData.entries.map((entry) {
  //             Map<String, dynamic> subjectMap = {
  //               'id': entry.value['id'] ?? null,
  //               'subName': entry.value['subName'] ?? '',
  //               'uniqueId': entry.value['uniqueId'] ?? null,
  //               'sync_key': entry.value['sync_key'] ?? null,
  //               'sync_status': entry.value['sync_status'] ?? null,
  //               'subCode': entry.value['subCode'] ?? '',
  //               'credit': entry.value['credit'] ?? 0,
  //               'subFee': entry.value['subFee'] ?? 0,
  //               'depId': entry.value['depId'] ?? null,
  //               'typeId': entry.value['typeId'] ?? null,
  //               'status': entry.value['status'] ?? null,
  //               'semester': entry.value['semester'] ?? null,
  //               'program': entry.value['program'] ?? null,
  //               'sId': entry.value['sId'] ?? null,
  //             };
  //             return Subject.fromMap(subjectMap);
  //           }).toList();
  //           _isLoading = false;
  //         });
  //       } else {
  //         print('No courses data available for the current school.');
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }).catchError((error) {
  //       print('Failed to load courses data: $error');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   } else {
  //     // Handle offline mode
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");
  //
  //     try {
  //       final String response = await rootBundle.loadString('assets/subjects.json');
  //       final data = json.decode(response) as List<dynamic>;
  //
  //       setState(() {
  //         subjects = data.map((json) => Subject.fromJson(json)).toList();
  //         _isLoading = false;
  //       });
  //     } catch (error) {
  //       print('Failed to load local subjects data: $error');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(subjects[index].uniqueId ?? subjects[index].subName ?? ''),
            onDismissed: (direction) {
              deleteSubject(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${subjects[index].subName} deleted')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: Icon(Icons.circle, color: Colors.redAccent), // Left-side icon
              title: Text(subjects[index].subName ?? ''), // Subject name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Credits: ${subjects[index].credit ?? 0}'), // Placeholder for credits
                  SizedBox(height: 4), // Spacing between texts
                  Text('Subject Code: ${subjects[index].subCode ?? 'N/A'}'), // Placeholder subject code
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Edit':
                      editSubject(index);
                      break;
                    case 'Duplicate':
                      duplicateSubject(index);
                      break;
                    case 'Delete':
                      deleteSubject(index);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return ['Edit', 'Duplicate', 'Delete'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: Icon(Icons.more_vert, color: Colors.teal), // Trailing icon
              ),
              onTap: () {
                showSubjectDetails(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          // First Floating Action Button (left)
          Positioned(
            left: 30, // Adjust the left position as needed
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () async {
                _showSubjectForm(context); // Open a form for adding a new subject
                // await _loadCoursesData();
                setState(() {
                  // Add any additional functionality here for the first floating action button
                });
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.teal,
            ),
          ),

          // Second Floating Action Button (right)
          Positioned(
            right: 30, // Adjust the right position as needed
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () async {
                _showSubjectAddForm(context);
                // await _loadCoursesData();
                setState(() {
                  // Add any additional functionality here for the second floating action button
                });
              },
              child: Icon(Icons.edit),
              backgroundColor: Colors.purple,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }



  void _showSubjectAddForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildAddForm(
          context,
          'Select Subject|Course',
          [


            DropdownSearch<Subject>(
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



          ],
        );
      },
    );
  }
  void _showSubjectForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Subject|Course',
          [
            _buildTextField('Subject Code', Icons.business, _subjectCodeController),
            _buildTextField('Subject Name', Icons.room_outlined, _subjectNameController),
            _buildNumberField("Subject Credit", Icons.book_online_outlined, _subjectCreditController),
            _buildNumberField("Fee", Icons.account_balance_outlined, _subjectFeeController),
            _buildNumberField("Subject Type(123..)", Icons.bookmark, _selectedTypeId),

          ],
        );
      },
    );
  }

  Widget _buildTextField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildMonthSelectDropdownField(String labelText, IconData icon, String? selectedMonth, ValueChanged<String?> onChanged) {
    List<String> months = List.generate(12, (index) => (index + 1).toString());

    if (selectedMonth != null && !months.contains(selectedMonth)) {
      selectedMonth = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedMonth,
        items: months.map((month) {
          return DropdownMenuItem<String>(
            value: month,
            child: Text(month),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }
  Widget _buildNumberField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Restrict to digits only
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
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
                onPressed: saveNewSubject,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildAddForm(BuildContext context, String title, List<Widget> fields) {
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
                child: const Center(child: Text('ADD')),
                onPressed: setSubjectToSemester,
              ),
            ],
          ),
        ),
      ),
    );
  }

}