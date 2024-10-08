import 'dart:async';
import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:class_organizer/admin/school/pages/schedules.dart';
import 'package:class_organizer/admin/school/schedule/monthly_schedules.dart';
import 'package:class_organizer/admin/school/schedule/schedule_7_screen.dart';
import 'package:class_organizer/admin/school/schedule/schedule_v1_screen.dart';
import 'package:class_organizer/admin/school/schedule/weekly_schedules.dart';
import 'package:class_organizer/models/routine.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
import '../../admin/school/save_routine_mine.dart';
import '../../db/database_helper.dart';
import '../../models/schedule_item.dart';

class MineRoutines extends StatefulWidget {
  @override
  _MineRoutinesState createState() => _MineRoutinesState();
}

class _MineRoutinesState extends State<MineRoutines> {
  final TextEditingController _routineNameController = TextEditingController();
  final TextEditingController _routineDetailsController = TextEditingController();
  List<Routine> routines = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('routines');
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
  List<ScheduleItem> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRoutinesData();
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

  // Future<void> _loadMajorsData() async {
  //   if (await InternetConnectionChecker().hasConnection) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     DatabaseReference majorRef = _databaseRef.child('departments');
  //
  //     majorRef.once().then((DatabaseEvent event) {
  //       final dataSnapshot = event.snapshot;
  //
  //       if (dataSnapshot.exists) {
  //         final Map<dynamic, dynamic> majorsData = dataSnapshot.value as Map<dynamic, dynamic>;
  //
  //         setState(() {
  //           departments = majorsData.entries.map((entry) {
  //             Map<String, dynamic> majorMap = {
  //               'id': entry.value['id'] ?? null,
  //               'status': entry.value['status'] ?? null,
  //               'uniqueId': entry.value['uniqueId'] ?? null,
  //               'sync_key': entry.value['sync_key'] ?? null,
  //               'sync_status': entry.value['sync_status'] ?? null,
  //               'mName': entry.value['mName'] ?? '',
  //               'mStart': entry.value['mStart'] ?? null,
  //               'mEnd': entry.value['mEnd'] ?? null,
  //               'mStatus': entry.value['mStatus'] ?? 0,
  //               'deanId': entry.value['deanId'] ?? '',
  //               'sId': entry.value['sId'] ?? null,
  //             };
  //             return Major.fromMap(majorMap);
  //           }).toList();
  //           _isLoading = false;
  //         });
  //       } else {
  //         print('No majors data available.');
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }).catchError((error) {
  //       print('Failed to load majors data: $error');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     showSnackBarMsg(context, "You are in Offline mode now, Please, connect Internet!");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     final String response = await rootBundle.loadString('assets/majors.json');
  //     final data = json.decode(response) as List<dynamic>;
  //     setState(() {
  //       departments = data.map((json) => Major.fromJson(json)).toList();
  //       _isLoading = false;
  //     });
  //   }
  // }

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
    _routineNameController.dispose();
    _routineDetailsController.dispose();
    super.dispose();
  }

  void saveNewRoutine() async {
    String routineName = '${_routineNameController.text.trim()} (${_selectedDepartment?.mName ?? "UD"})';
    String routineDetails = _routineDetailsController.text.trim();

    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();
    var uuid = Uuid();

    if (routineName.isNotEmpty && routineDetails.isNotEmpty) {
      Routine newRoutine = Routine(
        id: null,
        sId: _user?.uniqueid,
        uId: _user?.uniqueid,
        stdId: null,
        tempName: routineName,
        tempCode: uuid.v4(),
        tempDetails: routineDetails,
        tempNum: Unique().generateHexCode(),
        uniqueId: uniqueId,
        aStatus: 1,
        tId: _user?.uniqueid,
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newRoutine.uniqueId != null && newRoutine.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("routines")
              .child(newRoutine.uniqueId!);

          _database.set(newRoutine.toMap()).then((_) {
            setState(() {
              routines.add(newRoutine);
            });
            _routineNameController.clear();
            _routineDetailsController.clear();
            Navigator.of(context).pop();
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



  Future<void> editRoutine(int index) async {
    print('Editing ${routines[index].tempName}');

    await loadSchedules(routines[index]);



  }

  void duplicateRoutine(int index) {
    setState(() {
      routines.add(Routine(
        id: null,
        sId: routines[index].sId,
        uId: routines[index].uId,
        stdId: routines[index].stdId,
        tempName: '${routines[index].tempName} (Duplicate)',
        tempCode: routines[index].tempCode,
        tempDetails: routines[index].tempDetails,
        tempNum: routines[index].tempNum,
        uniqueId: '${routines[index].uniqueId}-DUP', // Ensure unique identifier for duplication
        syncKey: routines[index].syncKey,
        syncStatus: routines[index].syncStatus,
        aStatus: routines[index].aStatus,
        key: routines[index].key,
        tId: routines[index].tId,
      ));
    });
  }

  Future<void> deleteRoutineAndSchedules(Routine routine) async {
    try {
      DatabaseReference scheduleRef = _databaseRef.child('routines').child(routine.uniqueId!);

      await scheduleRef.remove();

      deleteSchedules(routine);

      showSnackBarMsg(context, 'Schedule with key ${routine.tempName} deleted successfully.');
    } catch (error) {
      // Handle the error (e.g., show a snack bar with error message)
      print('Error deleting schedule: $error');
      showSnackBarMsg(context, "Failed to delete schedule. Please try again.");
    }
  }

  void deleteRoutine(int index) {
    deleteRoutineAndSchedules(routines[index]);
    setState(() {
      routines.removeAt(index);
    });
  }
  Future<void> deleteSchedules(Routine routine) async {
    final dbRef = FirebaseDatabase.instance.ref('schedules');

    // Query the schedules where temp_code matches routine.tempCode
    Query query = dbRef.orderByChild('temp_code').equalTo(routine.tempCode);

    // Execute the query and process the snapshot
    query.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> schedules = snapshot.value as Map<dynamic, dynamic>;

        // Iterate through the schedules and remove them
        schedules.forEach((key, value) {
          dbRef.child(key).remove();
        });
      } else {
        print('No schedules found with temp_code: ${routine.tempCode}');
      }
    }).catchError((error) {
      print('Error deleting schedules: $error');
    });
  }

  void showRoutineDetails(int index) {
    final routine = routines[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${routine.tempName} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Routine ID: ${routine.uniqueId}'),
              Text('Template Code: ${routine.tempCode}'),
              Text('Template Details: ${routine.tempDetails}'),
              Text('Template Number: ${routine.tempNum}'),
              Text('Sync Status: ${routine.syncStatus == 1 ? 'Synced' : 'Not Synced'}'),
              Text('Approval Status: ${routine.aStatus == 1 ? 'Approved' : 'Pending'}'),
              Text('User ID: ${routine.uId}'),
              Text('Student ID: ${routine.stdId}'),
              Text('Teacher ID: ${routine.tId}'),
              Text('School ID: ${routine.sId}'),
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



  // Future<void> _loadRoutinesData() async {
  //   if (await InternetConnectionChecker().hasConnection) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     DatabaseReference routinesRef = _databaseRef.child('routines');
  //
  //     routinesRef.once().then((DatabaseEvent event) {
  //       final dataSnapshot = event.snapshot;
  //
  //       if (dataSnapshot.exists) {
  //         final Map<dynamic, dynamic> routinesData = dataSnapshot.value as Map<dynamic, dynamic>;
  //
  //         setState(() {
  //           routines = routinesData.entries.map((entry) {
  //             Map<String, dynamic> routineMap = {
  //               'id': entry.value['id'] ?? null,
  //               'sId': entry.value['sId'] ?? null,
  //               'uId': entry.value['uId'] ?? null,
  //               'stdId': entry.value['stdId'] ?? null,
  //               'tempName': entry.value['tempName'] ?? '',
  //               'tempCode': entry.value['tempCode'] ?? '',
  //               'tempDetails': entry.value['tempDetails'] ?? '',
  //               'tempNum': entry.value['tempNum'] ?? '',
  //               'uniqueId': entry.value['uniqueId'] ?? null,
  //               'syncKey': entry.value['syncKey'] ?? null,
  //               'syncStatus': entry.value['syncStatus'] ?? 0,
  //               'aStatus': entry.value['aStatus'] ?? 0,
  //               'key': entry.value['key'] ?? null,
  //               'tId': entry.value['tId'] ?? null,
  //             };
  //             return Routine.fromMap(routineMap);
  //           }).toList();
  //           _isLoading = false;
  //         });
  //       } else {
  //         print('No routines data available.');
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }).catchError((error) {
  //       print('Failed to load routines data: $error');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     final String response = await rootBundle.loadString('assets/routines.json');
  //     final data = json.decode(response) as List<dynamic>;
  //     setState(() {
  //       routines = data.map((json) => Routine.fromJson(json)).toList();
  //       _isLoading = false;
  //     });
  //   }
  // }


  Future<void> _loadRoutinesData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the routines node in Firebase
      DatabaseReference routinesRef = _databaseRef.child('routines');

      // Query routines that match the current school's sId
      Query query = routinesRef.orderByChild('sId').equalTo(_user?.uniqueid);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> routinesData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            // Convert the routines data into a list of Routine objects
            routines = routinesData.entries.map((entry) {
              Map<String, dynamic> routineMap = {
                'id': entry.value['id'] ?? null,
                'sId': entry.value['sId'] ?? null,
                'uId': entry.value['uId'] ?? null,
                'stdId': entry.value['stdId'] ?? null,
                'tempName': entry.value['tempName'] ?? '',
                'tempCode': entry.value['tempCode'] ?? '',
                'tempDetails': entry.value['tempDetails'] ?? '',
                'tempNum': entry.value['tempNum'] ?? '',
                'uniqueId': entry.value['uniqueId'] ?? null,
                'syncKey': entry.value['syncKey'] ?? null,
                'syncStatus': entry.value['syncStatus'] ?? 0,
                'aStatus': entry.value['aStatus'] ?? 0,
                'key': entry.value['key'] ?? null,
                'tId': entry.value['tId'] ?? null,
              };
              return Routine.fromMap(routineMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No routines data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load routines data: $error');
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
      final String response = await rootBundle.loadString('assets/routines.json');
      final data = json.decode(response) as List<dynamic>;
      setState(() {
        routines = data.map((json) => Routine.fromJson(json)).toList();
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(routines[index].uniqueId ?? routines[index].tempName ?? ''),
            onDismissed: (direction) {
              deleteRoutine(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${routines[index].tempName} deleted')),
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
              title: Text(routines[index].tempName ?? ''), // Routine name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Temp Code: ${routines[index].tempCode ?? 'N/A'}'), // Placeholder for temp code
                  SizedBox(height: 4), // Spacing between texts
                  Text('Details: ${routines[index].tempDetails ?? 'N/A'}'), // Placeholder for details
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Copy':
                      copyRoutine(index);
                      break;
                    case 'Share':
                      shareRoutine(index);
                      break;
                    case 'Save as Mine':
                      setMineRoutine(index);
                      break;
                    case 'Save All Schedules':
                      editRoutine(index);
                      break;
                    case 'Duplicate':
                      duplicateRoutine(index);
                      break;
                    case 'Delete':
                      deleteRoutine(index);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return ['Copy','Share','Save as Mine','Save All Schedules', 'Duplicate', 'Delete'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: Icon(Icons.more_vert, color: Colors.teal), // Trailing icon
              ),
              onTap: () {
                showRoutineDetails(index);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                  if (mounted) {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => SchedulesPage(routine: routines[index],)),
                      // MaterialPageRoute(builder: (context) => MonthlySchedules(routine: routines[index],)),
                      MaterialPageRoute(builder: (context) => WeeklySchedules(routine: routines[index],)),
                    );
                  }
                });
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showRoutineForm(context);
          await _loadRoutinesData();
          setState(() {

          });
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(), // Fully circular shape
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }





  void _showRoutineForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Routines',
          [
            DropdownSearch<Major>(
              items: departments,  // Assuming you have a list of faculties
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Select Departments',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onChanged: (Major? selectedDepartment) {
                setState(() {
                  _selectedDepartment = selectedDepartment;
                  // Use selected faculty data as needed, e.g., _selectedFaculty.fname
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
                return Text(selectedItem?.mName ?? "No Department Selected");
              },
            ),
            _buildTextField('Routine Name', Icons.category_rounded, _routineNameController),
            _buildTextField('Routine Details', Icons.description_outlined, _routineDetailsController),

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
                onPressed: saveNewRoutine,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void copyRoutine(int index) {
    String? tempNum = routines[index].tempNum;

    if (tempNum != null && tempNum.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: tempNum)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Routine Number copied: $tempNum')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to copy: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Routine Number to copy')),
      );
    }
  }

  void shareRoutine(int index) {
    final routine = routines[index];
    String? tempNum = routine.tempNum;
    String? tempCode = routine.tempCode;

    if (tempNum != null && tempCode != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Share Routine'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Barcode for tempNum:'),
                SizedBox(height: 10),
                BarcodeWidget(
                  barcode: Barcode.code128(), // Choose the barcode format
                  data: tempNum,
                  width: 200,
                  height: 100,
                ),
                SizedBox(height: 20),
                Text('QR Code for tempCode:'),
                SizedBox(height: 10),
                BarcodeWidget(
                  barcode: Barcode.qrCode(), // QR code format
                  data: tempCode,
                  width: 200,
                  height: 200,
                ),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Routine data is incomplete for sharing')),
      );
    }
  }

  void setMineRoutine(int index) {
    Future.delayed(const Duration(seconds: 0), () {
      // Navigator.pop(context);
      if (mounted) {
        Navigator.push(
          context,
          // MaterialPageRoute(builder: (context) => SchedulesPage(routine: routines[index],)),
          // MaterialPageRoute(builder: (context) => MonthlySchedules(routine: routines[index],)),
          MaterialPageRoute(builder: (context) => SaveRoutineMine(routine: routines[index],)),
        );
      }
    });
  }

  void synchronizeRoutinesAndSchedule() async {
    if (await InternetConnectionChecker().hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synchronizing routines and schedule...')),
      );

      // Perform synchronization logic here, e.g., uploading to a server

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synchronization complete!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
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

          setState(() {
            schedules = fetchedSchedules;
          });

          if(schedules.isNotEmpty){
            for(ScheduleItem scheduleItem in schedules){
              saveNewSchedule(scheduleItem);
            }
          }

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

            });
            saveScheduleOffline(newSchedule);

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

}