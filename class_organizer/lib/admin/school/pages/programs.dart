import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/admin/school/pages/semesters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/faculties.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class ProgramListPage extends StatefulWidget {
  @override
  _ProgramListPageState createState() => _ProgramListPageState();
}

class _ProgramListPageState extends State<ProgramListPage> {
  final TextEditingController _programNameController = TextEditingController();
  List<Faculties> programs = [
    // Faculties(
    //     id: 1,
    //     status: 1,
    //     uniqueid: '123456789',
    //     sync_key: 'key1',
    //     sync_status: 1,
    //     fname: 'Day',
    //     created_date: '2024-09-17',
    //     nums_dept: 3,
    //     t_id: 'T001',
    //     sid: 'da@example.com',
    //     userid: 'user1'),
    // Faculties(
    //     id: 2,
    //     status: 1,
    //     uniqueid: '987654321',
    //     sync_key: 'key2',
    //     sync_status: 1,
    //     fname: 'Evening',
    //     created_date: '2024-09-17',
    //     nums_dept: 4,
    //     t_id: 'T002',
    //     sid: 'ev@example.com',
    //     userid: 'user2'),
  ];

  final _databaseRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('faculties');
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
    _loadUserData();
    _loadFacultiesData();
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
        _loadFacultiesData();
      } else {
        isConnected = false;
        print('Disconnected from the internet');
        // _loadFacultiesData();
      }
    });
  }

  void startListening() {
    connectionSubscription = checkConnectionContinuously();
  }

  void stopListening() {
    connectionSubscription?.cancel();
  }

  Future<void> _loadFacultiesData() async {

    if(await InternetConnectionChecker().hasConnection){
      setState(() {
        _isLoading = true;
      });

      DatabaseReference schoolRef = _databaseRef.child('faculties');

      schoolRef.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> facultiesData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            programs = facultiesData.entries.map((entry) {
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
          print('No Faculties data available.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load school data: $error');
        setState(() {
          _isLoading = false;
        });
      });
    }else{
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
        programs = data.map((json) => Faculties.fromJson(json)).toList();
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
      // Handle the case where `schoolMap` is null
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
    _programNameController.dispose();
    super.dispose();
  }

  void saveNewProgram() async {
    String programName = _programNameController.text.trim();
    await _loadUserData();
    var uuid = Uuid();
    String uniqueId = Unique().generateUniqueID();

    if (programName.isNotEmpty) {
      Faculties newFaculty = Faculties(
        id: null,
        status: 1,
        // uniqueid: DateTime.now().millisecondsSinceEpoch.toString(),
        uniqueid: uniqueId,
        fname: programName,
        created_date: DateTime.now().toString(),
        nums_dept: 0,
        t_id: 'T-new',
        sid: school?.sId,
        userid: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // if(await InternetConnectionChecker().hasConnection){
      //   final DatabaseReference _database = FirebaseDatabase.instance.ref("faculties").child(newFaculty.uniqueid!);
      //   // _database.push().set(newFaculty.toMap()).then((_) {
      //   _database.set(newFaculty.toMap()).then((_) {
      //     setState(() {
      //       programs.add(newFaculty);
      //     });
      //     _programNameController.clear();
      //     Navigator.of(context).pop();
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Program added')));
      //   }).catchError((error) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add program')));
      //   });
      // }

      if (await InternetConnectionChecker().hasConnection) {
        if (newFaculty.uniqueid != null && newFaculty.uniqueid!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("faculties")
              .child(newFaculty.uniqueid!);

          _database.set(newFaculty.toMap()).then((_) {
            setState(() {
              programs.add(newFaculty);
            });
            _programNameController.clear();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Program added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add program: $error')),
            );
            print("Error adding program: $error");
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


      //Local database for save program

    }
  }

  void editProgram(int index) {
    // Handle editing a faculty
    print('Editing ${programs[index].fname}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateProgram(int index) {
    // Duplicate the faculty and add to the list
    setState(() {
      programs.add(Faculties(
        id: null,
        status: programs[index].status,
        uniqueid: '${programs[index].uniqueid}-DUP',
        sync_key: programs[index].sync_key,
        sync_status: programs[index].sync_status,
        fname: '${programs[index].fname} (Duplicate)',
        created_date: programs[index].created_date,
        nums_dept: programs[index].nums_dept,
        t_id: programs[index].t_id,
        sid: programs[index].sid,
        userid: programs[index].userid,
      ));
    });
  }

  void deleteProgram(int index) {
    setState(() {
      programs.removeAt(index);
    });
  }

  void showProgramDetails(int index) {
    final program = programs[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${program.fname} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${program.fname}'),
              Text('sId: ${program.sid}'),
              Text('Unique ID: ${program.uniqueid}'),
              Text('Departments: ${program.nums_dept}'),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(programs[index].uniqueid ?? programs[index].fname ?? ''),
            onDismissed: (direction) {
              deleteProgram(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${programs[index].fname} deleted')),
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
              title: Text(programs[index].fname ?? ''),
              onTap: () {
                showProgramDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = programs[index].sid;
                      print('Emailing $email');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editProgram(index);
                          break;
                        case 'Duplicate':
                          duplicateProgram(index);
                          break;
                        case 'Delete':
                          deleteProgram(index);
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
        onPressed: () {
          _showProgramForm(context);
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


  void _showProgramForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Program',
          [
            _buildTextField('Program Name', Icons.business, _programNameController),
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
                onPressed: saveNewProgram,
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
// class ProgramListPage extends StatefulWidget {
//   @override
//   _ProgramListPageState createState() => _ProgramListPageState();
// }
//
// class _ProgramListPageState extends State<ProgramListPage> {
//   final List<Map<String, dynamic>> programs = [
//     {'name': 'Computer Science', 'email': 'cs@example.com', 'phone': '123456789'},
//     {'name': 'Business Administration', 'email': 'ba@example.com', 'phone': '987654321'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Programs'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: programs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(programs[index]['name']),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.email, color: Colors.teal),
//                   onPressed: () {
//                     // Handle email action
//                     final email = programs[index]['email'];
//                     print('Emailing $email');
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.phone, color: Colors.teal),
//                   onPressed: () {
//                     // Handle phone action
//                     final phone = programs[index]['phone'];
//                     print('Calling $phone');
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle add program action
//           setState(() {
//             // Example: Add a new program to the list
//             programs.add({
//               'name': 'New Program',
//               'email': 'newprogram@example.com',
//               'phone': '111111111',
//             });
//           });
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.teal,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       // bottomNavigationBar: Padding(
//       //   padding: const EdgeInsets.all(8.0),
//       //   child: ElevatedButton(
//       //     onPressed: () {
//       //       // Handle save action
//       //     },
//       //     child: Text('Saved'),
//       //     style: ElevatedButton.styleFrom(
//       //       foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
//       //       shape: RoundedRectangleBorder(
//       //         borderRadius: BorderRadius.circular(20),
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
