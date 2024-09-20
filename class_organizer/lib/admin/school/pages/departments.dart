import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/admin/school/pages/semesters.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/faculties.dart';
import '../../../models/major.dart';  // Updated from faculties to major
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class DepartmentListPage extends StatefulWidget {
  @override
  _DepartmentListPageState createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _departmentLocationController = TextEditingController();
  List<Major> departments = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('departments');
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

  List<Faculties> _facultiesList = [];
  Faculties? _selectedFaculty;


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMajorsData();
    startListening();
    checkConnection();
    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });

    _loadFacultiesData();
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
    _departmentNameController.dispose();
    _departmentLocationController.dispose();
    super.dispose();
  }

  void saveNewDepartment() async {
    String departmentName = '${_departmentNameController.text.trim()} (${_selectedFaculty?.fname ?? "Unknown Faculty"})';

    String departmentLocation = _departmentLocationController.text;
    await _loadUserData();
    var uuid = Uuid();
    String uniqueId = Unique().generateUniqueID();


    if (departmentName.isNotEmpty) {
      Major newMajor = Major(
        id: null,
        mStatus: 1,
        uniqueId: uniqueId,
        mName: departmentName,
        mStart: DateTime.now().toString(),
        mEnd: null,
        deanId: 'Dean-new',
        sId: school?.sId,
        location: departmentLocation,
        currentId: _selectedFaculty?.uniqueid,
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newMajor.uniqueId != null && newMajor.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("departments")
              .child(newMajor.uniqueId!);

          _database.set(newMajor.toMap()).then((_) {
            setState(() {
              departments.add(newMajor);
            });
            _departmentNameController.clear();
            _departmentLocationController.clear();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Department added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add department: $error')),
            );
            print("Error adding department: $error");
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
  }

  void editDepartment(int index) {
    print('Editing ${departments[index].mName}');
  }

  void duplicateDepartment(int index) {
    setState(() {
      departments.add(Major(
        id: null,
        mStatus: departments[index].mStatus,
        uniqueId: '${departments[index].uniqueId}-DUP',
        syncKey: departments[index].syncKey,
        syncStatus: departments[index].syncStatus,
        mName: '${departments[index].mName} (Duplicate)',
        mStart: departments[index].mStart,
        mEnd: departments[index].mEnd,
        deanId: departments[index].deanId,
        sId: departments[index].sId,
      ));
    });
  }

  void deleteDepartment(int index) {
    setState(() {
      departments.removeAt(index);
    });
  }

  void showDepartmentDetails(int index) {
    final department = departments[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${department.mName} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Department ID: ${department.uniqueId}'),
              Text('Status: ${department.mStatus == 1 ? 'Active' : 'Inactive'}'),
              Text('Dean ID: ${department.deanId}'),
              Text('Start Date: ${department.mStart}'),
              Text('End Date: ${department.mEnd ?? 'Ongoing'}'),
              Text('School ID: ${department.sId}'),
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

  Future<void> _loadFacultiesData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the faculties node in Firebase
      DatabaseReference facultiesRef = _databaseRef.child('faculties');

      // Query faculties that match the current school's sId
      Query query = facultiesRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> facultiesData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            // Convert the faculties data into a list of Faculties objects
            _facultiesList = facultiesData.entries.map((entry) {
              Map<String, dynamic> facultiesMap = {
                'id': entry.value['id'] ?? null,
                'status': entry.value['status'] ?? null,
                'uniqueId': entry.value['uniqueId'] ?? null,
                'sync_key': entry.value['sync_key'] ?? null,
                'sync_status': entry.value['sync_status'] ?? null,
                'fname': entry.value['fname'] ?? '',
                'created_date': entry.value['created_date'] ?? null,
                'nums_dept': entry.value['nums_dept'] ?? 0,
                't_id': entry.value['t_id'] ?? '',
                'sId': entry.value['sId'] ?? null,
                'userid': entry.value['userid'] ?? null,
              };
              return Faculties.fromMap(facultiesMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No faculties data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load faculties data: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // Handle offline mode
      setState(() {
        _isLoading = true;
      });
      showSnackBarMsg(context, "You are in Offline mode now, Please, connect Internet!");
      setState(() {
        _isLoading = false;
      });
      final String response = await rootBundle.loadString('assets/faculties.json');
      final data = json.decode(response) as List<dynamic>;
      setState(() {
        _facultiesList = data.map((json) => Faculties.fromJson(json)).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(departments[index].uniqueId ?? departments[index].mName ?? ''),
            onDismissed: (direction) {
              deleteDepartment(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${departments[index].mName} deleted')),
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
              title: Text(departments[index].mName ?? ''),
              onTap: () {
                showDepartmentDetails(index);
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SemestersPage(department: departments[index],)),
                    );
                  }
                });
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = departments[index].sId;
                      print('Emailing $email');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editDepartment(index);
                          break;
                        case 'Duplicate':
                          duplicateDepartment(index);
                          break;
                        case 'Delete':
                          deleteDepartment(index);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Edit', 'Duplicate', 'Delete']
                          .map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDepartmentForm(context);
          await _loadFacultiesData();
          setState(() {
            // programs.add(Faculties(
            //   fname: 'New Faculty',
            //   nums_dept: 0,
            //   t_id: 'T999',
            //   sid: 'newfaculty@example.com',
            // ));
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  void _showDepartmentForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Department',
          [
            DropdownSearch<Faculties>(
              items: _facultiesList,  // Assuming you have a list of faculties
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Select Program/Faculty',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onChanged: (Faculties? selectedFaculty) {
                setState(() {
                  _selectedFaculty = selectedFaculty;
                  // Use selected faculty data as needed, e.g., _selectedFaculty.fname
                });
              },
              selectedItem: _selectedFaculty,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item.fname ?? 'Unknown Faculty'),
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                return Text(selectedItem?.fname ?? "No Faculty Selected");
              },
            ),
            _buildTextField('Department Name', Icons.business, _departmentNameController),
            _buildTextField('Department Location', Icons.room_outlined, _departmentLocationController),
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
                onPressed: saveNewDepartment,
              ),
            ],
          ),
        ),
      ),
    );
  }

}












// import 'package:flutter/material.dart';
//
// class DepartmentListPage extends StatefulWidget {
//   @override
//   _DepartmentListPageState createState() => _DepartmentListPageState();
// }
//
// class _DepartmentListPageState extends State<DepartmentListPage> {
//   final List<Map<String, dynamic>> departments = [
//     {'name': 'Day', 'sId': 'da@example.com', 'uniqueId': '123456789'},
//     {'name': 'Evening', 'sId': 'ev@example.com', 'uniqueId': '987654321'},
//     {'name': 'Bangla', 'sId': 'ba@example.com', 'uniqueId': '123456289'},
//     {'name': 'English', 'sId': 'en@example.com', 'uniqueId': '987655321'},
//   ];
//
//   void editDepartment(int index) {
//     // Handle editing a department
//     print('Editing ${departments[index]['name']}');
//     // You can add a TextField or dialog to actually edit the details.
//   }
//
//   void duplicateDepartment(int index) {
//     // Duplicate the department and add to the list
//     setState(() {
//       departments.add({
//         'name': '${departments[index]['name']} (Duplicate)',
//         'email': departments[index]['email'],
//         'phone': departments[index]['phone'],
//       });
//     });
//   }
//
//   void deleteDepartment(int index) {
//     setState(() {
//       departments.removeAt(index);
//     });
//   }
//
//   void showDepartmentDetails(int index) {
//     final department = departments[index];
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${department['name']} Details'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Name: ${department['name']}'),
//               Text('sId: ${department['sId']}'),
//               Text('Unique ID: ${department['uniqueId']}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Departments'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: departments.length,
//         itemBuilder: (context, index) {
//           return Dismissible(
//             key: Key(departments[index]['name']),
//             onDismissed: (direction) {
//               deleteDepartment(index);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('${departments[index]['name']} deleted')),
//               );
//             },
//             background: Container(
//               color: Colors.red,
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.only(left: 20.0),
//               child: Icon(Icons.delete, color: Colors.white),
//             ),
//             secondaryBackground: Container(
//               color: Colors.red,
//               alignment: Alignment.centerRight,
//               padding: EdgeInsets.only(right: 20.0),
//               child: Icon(Icons.delete, color: Colors.white),
//             ),
//             child: ListTile(
//               title: Text(departments[index]['name']),
//               onTap: () {
//                 showDepartmentDetails(index);
//               },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   IconButton(
//                     icon: Icon(Icons.email, color: Colors.teal),
//                     onPressed: () {
//                       final email = departments[index]['email'];
//                       print('Emailing $email');
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.phone, color: Colors.teal),
//                     onPressed: () {
//                       final phone = departments[index]['phone'];
//                       print('Calling $phone');
//                     },
//                   ),
//                   PopupMenuButton<String>(
//                     onSelected: (value) {
//                       switch (value) {
//                         case 'Edit':
//                           editDepartment(index);
//                           break;
//                         case 'Duplicate':
//                           duplicateDepartment(index);
//                           break;
//                         case 'Delete':
//                           deleteDepartment(index);
//                           break;
//                       }
//                     },
//                     itemBuilder: (BuildContext context) {
//                       return ['Edit', 'Duplicate', 'Delete'].map((String choice) {
//                         return PopupMenuItem<String>(
//                           value: choice,
//                           child: Text(choice),
//                         );
//                       }).toList();
//                     },
//                     icon: Icon(Icons.more_vert),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle add department action
//           setState(() {
//             departments.add({
//               'name': 'New Department',
//               'email': 'newdepartment@example.com',
//               'phone': '111111111',
//             });
//           });
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.teal,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
