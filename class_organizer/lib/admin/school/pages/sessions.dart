import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/models/a_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/major.dart';  // Updated from faculties to major
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class SessionListPage extends StatefulWidget {
  @override
  _SessionListPageState createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  final TextEditingController _sessionNameController = TextEditingController();
  final TextEditingController _sessionLocationController = TextEditingController();
  List<AYear> sessions = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('sessions');
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

  String? _selectedMonth, endMonth = "1";

  String? _selectedYear, endYear = (DateTime.now().year).toString();


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSessionsData();  // Updated method name
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
        _loadSessionsData();
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

  // Future<void> _loadSessionsData() async {
  //   if (await InternetConnectionChecker().hasConnection) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     DatabaseReference sessionRef = _databaseRef.child('sessions');
  //
  //     sessionRef.once().then((DatabaseEvent event) {
  //       final dataSnapshot = event.snapshot;
  //
  //       if (dataSnapshot.exists) {
  //         final Map<dynamic, dynamic> sessionsData = dataSnapshot.value as Map<dynamic, dynamic>;
  //
  //         setState(() {
  //           sessions = sessionsData.entries.map((entry) {
  //             Map<String, dynamic> sessionMap = {
  //               'id': entry.value['id'] ?? null,
  //               'uId': entry.value['uId'] ?? null,
  //               'aYname': entry.value['aYname'] ?? null,
  //               'uniqueId': entry.value['uniqueId'] ?? null,
  //               'sYear': entry.value['sYear'] ?? null,
  //               'sMonth': entry.value['sMonth'] ?? null,
  //               'eYear': entry.value['eYear'] ?? null,
  //               'eMonth': entry.value['eMonth'] ?? null,
  //               'aStatus': entry.value['aStatus'] ?? 0,
  //               'sId': entry.value['sId'] ?? null,
  //               'syncStatus': entry.value['syncStatus'] ?? null,
  //               'syncKey': entry.value['syncKey'] ?? null,
  //             };
  //             return AYear.fromMap(sessionMap);
  //           }).toList();
  //           _isLoading = false;
  //         });
  //       } else {
  //         print('No sessions data available.');
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }).catchError((error) {
  //       print('Failed to load sessions data: $error');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     showSnackBarMsg(context, "You are in Offline mode now, Please, connect to the Internet!");
  //
  //     try {
  //       final String response = await rootBundle.loadString('assets/sessions.json');
  //       final data = json.decode(response) as List<dynamic>;
  //
  //       setState(() {
  //         sessions = data.map((json) => AYear.fromJson(json)).toList();
  //         _isLoading = false;
  //       });
  //     } catch (error) {
  //       print('Failed to load local sessions data: $error');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _loadSessionsData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the sessions node in Firebase
      DatabaseReference sessionRef = _databaseRef.child('sessions');

      // Query sessions that match the current school's sId
      Query query = sessionRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> sessionsData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            sessions = sessionsData.entries.map((entry) {
              Map<String, dynamic> sessionMap = {
                'id': entry.value['id'] ?? null,
                'uId': entry.value['uId'] ?? null,
                'aYname': entry.value['aYname'] ?? null,
                'uniqueId': entry.value['uniqueId'] ?? null,
                'sYear': entry.value['sYear'] ?? null,
                'sMonth': entry.value['sMonth'] ?? null,
                'eYear': entry.value['eYear'] ?? null,
                'eMonth': entry.value['eMonth'] ?? null,
                'aStatus': entry.value['aStatus'] ?? 0,
                'sId': entry.value['sId'] ?? null,
                'syncStatus': entry.value['syncStatus'] ?? null,
                'syncKey': entry.value['syncKey'] ?? null,
              };
              return AYear.fromMap(sessionMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No sessions data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load sessions data: $error');
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
        final String response = await rootBundle.loadString('assets/sessions.json');
        final data = json.decode(response) as List<dynamic>;

        setState(() {
          sessions = data.map((json) => AYear.fromJson(json)).toList();
          _isLoading = false;
        });
      } catch (error) {
        print('Failed to load local sessions data: $error');
        setState(() {
          _isLoading = false;
        });
      }
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
    _sessionNameController.dispose();
    _sessionLocationController.dispose();
    super.dispose();
  }

  void saveNewSession() async {

    String sessionName = _sessionNameController.text.trim();
    int startMonth = int.tryParse(_selectedMonth ?? '1') ?? 1;
    int endM = int.tryParse(endMonth ?? '12') ?? 12;
    int startYear = int.tryParse(_selectedYear ?? '2024') ?? 2024;
    int endY = int.tryParse(endYear ?? '2024') ?? 2024;

    await _loadUserData();
    var uuid = Uuid();
    String uniqueId = uuid.v4();

    if (sessionName.isNotEmpty) {
      AYear newSession = AYear(
        id: null,
        aYname: sessionName,
        sYear: startYear.toString(),
        sMonth: startMonth.toString(),
        eYear: endY.toString(),
        eMonth: endM.toString(),
        aStatus: 1,
        uniqueId: uniqueId,
        sId: school?.sId,
        uId: DateTime.now().toString(),
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newSession.uniqueId != null && newSession.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("sessions")
              .child(newSession.uniqueId!);

          _database.set(newSession.toMap()).then((_) {
            setState(() {
              sessions.add(newSession); // Add the new session to the list
            });
            _sessionNameController.clear(); // Clear the form fields
            Navigator.of(context).pop(); // Close the dialog or screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session added successfully')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add session: $error')),
            );
            print("Error adding session: $error");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid unique ID')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session name cannot be empty')),
      );
    }
  }


  void editDepartment(int index) {
    print('Editing ${sessions[index].aYname}');
  }

  void duplicateDepartment(int index) {
    AYear originalSession = sessions[index];

    setState(() {
      sessions.add(AYear(
        id: null, // Null to allow Firebase to assign a new ID
        aStatus: originalSession.aStatus,
        uniqueId: '${originalSession.uniqueId}-DUP', // Marking the duplicate session
        syncKey: '${originalSession.syncKey}-DUP', // Unique syncKey for the duplicate
        syncStatus: originalSession.syncStatus,
        aYname: '${originalSession.aYname} (Duplicate)', // Indicating it is a duplicate
        sYear: originalSession.sYear, // Start year remains the same
        sMonth: originalSession.sMonth, // Start month remains the same
        eYear: originalSession.eYear, // End year remains the same
        eMonth: originalSession.eMonth, // End month remains the same
        sId: originalSession.sId, // School ID remains the same
      ));
    });
  }


  void deleteDepartment(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  void showSessionDetails(int index) {
    final session = sessions[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${session.aYname} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unique ID: ${session.uniqueId}'),
              Text('Status: ${session.aStatus == 1 ? 'Active' : 'Inactive'}'),
              Text('Start Year: ${session.sYear ?? 'N/A'}'),
              Text('Start Month: ${session.sMonth ?? 'N/A'}'),
              Text('End Year: ${session.eYear ?? 'N/A'}'),
              Text('End Month: ${session.eMonth ?? 'N/A'}'),
              Text('School ID: ${session.sId ?? 'N/A'}'),
              Text('Sync Status: ${session.syncStatus ?? 'N/A'}'),
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
        title: Text('Sessions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(sessions[index].uniqueId ?? sessions[index].aYname ?? ''),
            onDismissed: (direction) {
              deleteDepartment(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${sessions[index].aYname} deleted')),
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
              title: Text('${sessions[index].aYname ?? ''}(${sessions[index].sMonth ?? ''}-${sessions[index].sYear ?? ''})'),
              onTap: () {
                showSessionDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = sessions[index].sId;
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
        onPressed: () {
          _showDepartmentForm(context);
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
            _buildTextField('Session Name', Icons.business, _sessionNameController),
            _buildMonthSelectDropdownField(
                "Select Starting Month",
                Icons.calendar_today,
                _selectedMonth,
                    (String? newValue) {
                  setState(() {
                    _selectedMonth = newValue;
                  });
                }
            ),
            _buildYearSelectDropdownField(
              "Select Starting Year",
              Icons.calendar_today_outlined,
              _selectedYear,
                  (String? newValue) {
                setState(() {
                  _selectedYear = newValue;
                });
              },// Customize the range as needed
            ),
            _buildMonthSelectDropdownField(
                "Select Ending Month",
                Icons.calendar_today,
                endMonth,
                    (String? newValue) {
                  setState(() {
                    endMonth = newValue;
                  });
                }
            ),
            _buildYearSelectDropdownField(
              "Select Ending Year",
              Icons.calendar_today_outlined,
              endYear,
                  (String? newValue) {
                setState(() {
                  endYear = newValue;
                });
              },// Customize the range as needed
            ),

          ],
        );
      },
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

  Widget _buildYearSelectDropdownField(String labelText, IconData icon, String? selectedYear, ValueChanged<String?> onChanged) {
    int currentYear = DateTime.now().year;
    List<String> years = List.generate(6, (index) => (currentYear + index).toString()); // Generate years from current year to next 5 years

    if (selectedYear != null && !years.contains(selectedYear)) {
      selectedYear = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedYear,
        items: years.map((year) {
          return DropdownMenuItem<String>(
            value: year,
            child: Text(year),
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


  Widget _buildMonthSelectField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2), // Limit to two digits
          FilteringTextInputFormatter.allow(RegExp(r'^(1[0-2]|[1-9])$')), // Restrict to 1-12
        ],
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
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
                onPressed: saveNewSession,
              ),
            ],
          ),
        ),
      ),
    );
  }

}