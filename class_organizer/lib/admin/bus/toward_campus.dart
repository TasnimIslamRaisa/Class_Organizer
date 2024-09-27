import 'dart:async';
import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:class_organizer/admin/school/schedule/weekly_schedules.dart';
import 'package:class_organizer/models/bus_schedule.dart';
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

class TowardCampus extends StatefulWidget {
  @override
  _TowardCampusState createState() => _TowardCampusState();
}

class _TowardCampusState extends State<TowardCampus> {
  final TextEditingController _fromDestinationController = TextEditingController();
  final TextEditingController _toDestinationController = TextEditingController();
  final TextEditingController _startingTimeController = TextEditingController();
  final TextEditingController _towardTimeController = TextEditingController();
  final TextEditingController _busNoController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _fromTowardController = TextEditingController();
  List<BusSchedule> schedules = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('bus');
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
  int _selectedRouteType = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBusSchedulesData();
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

  void showSnackBarMsg(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // Dispose of the TextEditingControllers used for BusSchedule form fields
    _fromDestinationController.dispose();
    _toDestinationController.dispose();
    _startingTimeController.dispose();
    _towardTimeController.dispose();
    _busNoController.dispose();
    _driverPhoneController.dispose();
    _remarksController.dispose();
    _fromTowardController.dispose();

    // Cancel any active internet connectivity subscription
    subscription.cancel();
    connectionSubscription?.cancel();

    super.dispose();
  }


  void saveNewBusSchedule() async {
    print(" bus scheudle farhad ");
    String fromLocation = _fromDestinationController.text.trim();
    String toLocation = _toDestinationController.text.trim();
    String startingTime = _startingTimeController.text.trim();
    String towardTime = _towardTimeController.text.trim();
    String busNo = _busNoController.text.trim();
    String driverPhone = _driverPhoneController.text.trim();
    String remarks = _remarksController.text.trim();
    int fromToward = _selectedRouteType ?? 0;

    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();

    if (fromLocation.isNotEmpty &&
        toLocation.isNotEmpty &&
        startingTime.isNotEmpty &&
        busNo.isNotEmpty) {

      BusSchedule newBusSchedule = BusSchedule(
        id: null,
        uniqueId: uniqueId,
        fromLocation: fromLocation,
        toLocation: toLocation,
        sId: school?.sId,
        busNo: int.tryParse(busNo),
        remarks: remarks,
        driverPhone: driverPhone,
        startingTime: startingTime,
        fromToward: fromToward,
        towardTime: towardTime,
        status: 1, // active status
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newBusSchedule.uniqueId != null && newBusSchedule.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("bus")
              .child(newBusSchedule.uniqueId!);

          _database.set(newBusSchedule.toMap()).then((_) {
            setState(() {
              schedules.add(newBusSchedule);
            });
            _fromDestinationController.clear();
            _toDestinationController.clear();
            _startingTimeController.clear();
            _towardTimeController.clear();
            _busNoController.clear();
            _driverPhoneController.clear();
            _remarksController.clear();
            _fromTowardController.clear();

            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bus schedule added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add bus schedule: $error')),
            );
            print("Error adding bus schedule: $error");
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




  void editBusSchedule(int index) {
    print('Editing bus schedule from ${schedules[index].fromLocation} to ${schedules[index].toLocation}');
  }


  void duplicateBusSchedule(int index) {
    setState(() {
      schedules.add(BusSchedule(
        id: null,
        uniqueId: '${schedules[index].uniqueId}-DUP', // Ensure unique identifier for duplication
        fromLocation: schedules[index].fromLocation,
        toLocation: schedules[index].toLocation,
        sId: schedules[index].sId,
        busNo: schedules[index].busNo,
        remarks: '${schedules[index].remarks} (Duplicate)', // Append "(Duplicate)" to remarks
        driverPhone: schedules[index].driverPhone,
        startingTime: schedules[index].startingTime,
        fromToward: schedules[index].fromToward,
        towardTime: schedules[index].towardTime,
        status: schedules[index].status, // Keep the same status
      ));
    });
  }




  Future<void> deleteBusSchedules(BusSchedule schedule) async {
    try {
      DatabaseReference scheduleRef = _databaseRef.child('routines').child(schedule.uniqueId!);

      await scheduleRef.remove();

      showSnackBarMsg(context, 'Schedule with key ${schedule.fromLocation} deleted successfully.');
    } catch (error) {
      // Handle the error (e.g., show a snack bar with error message)
      print('Error deleting schedule: $error');
      showSnackBarMsg(context, "Failed to delete schedule. Please try again.");
    }
  }

  void deleteBusSchedule(int index) {
    deleteBusSchedules(schedules[index]);
    setState(() {
      schedules.removeAt(index);
    });
  }


  void showBusScheduleDetails(int index) {
    final busSchedule = schedules[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bus Schedule from ${busSchedule.fromLocation} to ${busSchedule.toLocation}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bus Schedule ID: ${busSchedule.uniqueId}'),
              Text('Bus Number: ${busSchedule.busNo}'),
              Text('Starting Time: ${busSchedule.startingTime}'),
              Text('Toward Time: ${busSchedule.towardTime}'),
              Text('From Toward: ${busSchedule.fromToward == 1 ? 'From' : 'Toward'}'),
              Text('Driver Phone: ${busSchedule.driverPhone}'),
              Text('Remarks: ${busSchedule.remarks}'),
              Text('Status: ${busSchedule.status == 1 ? 'Active' : 'Inactive'}'),
              Text('School ID: ${busSchedule.sId}'),
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




  // Future<void> _loadBusSchedulesData() async {
  //   if (await InternetConnectionChecker().hasConnection) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     // Reference to the 'bus' node in Firebase
  //     DatabaseReference busSchedulesRef = _databaseRef.child('bus');
  //
  //     // Query bus schedules that match the current school's sId
  //     Query query = busSchedulesRef.orderByChild('sId').equalTo(school?.sId);
  //
  //     query.once().then((DatabaseEvent event) {
  //       final dataSnapshot = event.snapshot;
  //
  //       if (dataSnapshot.exists) {
  //         final Map<dynamic, dynamic> busSchedulesData = dataSnapshot.value as Map<dynamic, dynamic>;
  //
  //         setState(() {
  //           // Convert the data into a list of BusSchedule objects
  //           schedules = busSchedulesData.entries.map((entry) {
  //             Map<String, dynamic> busScheduleMap = {
  //               'id': entry.value['id'] ?? null,
  //               'uniqueId': entry.value['uniqueId'] ?? '',
  //               'fromLocation': entry.value['fromLocation'] ?? '',
  //               'toLocation': entry.value['toLocation'] ?? '',
  //               'sId': entry.value['sId'] ?? '',
  //               'busNo': entry.value['busNo'] ?? 0,
  //               'remarks': entry.value['remarks'] ?? '',
  //               'driverPhone': entry.value['driverPhone'] ?? '',
  //               'startingTime': entry.value['startingTime'] ?? '',
  //               'fromToward': entry.value['fromToward'] ?? 1,
  //               'towardTime': entry.value['towardTime'] ?? '',
  //               'status': entry.value['status'] ?? 0,
  //             };
  //             return BusSchedule.fromMap(busScheduleMap);
  //           }).toList();
  //           _isLoading = false;
  //         });
  //       } else {
  //         print('No bus schedule data available for the current school.');
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }).catchError((error) {
  //       print('Failed to load bus schedules data: $error');
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
  //
  //     // Load offline data from local JSON
  //     final String response = await rootBundle.loadString('assets/bus_schedules.json');
  //     final data = json.decode(response) as List<dynamic>;
  //     setState(() {
  //       schedules = data.map((json) => BusSchedule.fromJson(json)).toList();
  //       _isLoading = false;
  //     });
  //   }
  // }


  Future<void> _loadBusSchedulesData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the 'bus' node in Firebase
      DatabaseReference busSchedulesRef = _databaseRef.child('bus');

      // Query bus schedules that match the current school's sId
      Query query = busSchedulesRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> busSchedulesData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            // Convert the data into a list of BusSchedule objects
            schedules = busSchedulesData.entries.map((entry) {
              Map<String, dynamic> busScheduleMap = {
                'id': entry.value['id'] ?? null,
                'uniqueId': entry.value['uniqueId'] ?? '',
                'fromLocation': entry.value['fromLocation'] ?? '',
                'toLocation': entry.value['toLocation'] ?? '',
                'sId': entry.value['sId'] ?? '',
                'busNo': entry.value['busNo'] ?? 0,
                'remarks': entry.value['remarks'] ?? '',
                'driverPhone': entry.value['driverPhone'] ?? '',
                'startingTime': entry.value['startingTime'] ?? '',
                'fromToward': entry.value['fromToward'] ?? 1,
                'towardTime': entry.value['towardTime'] ?? '',
                'status': entry.value['status'] ?? 0,
              };
              return BusSchedule.fromMap(busScheduleMap);
            }).where((schedule) => schedule.fromToward == 1).toList(); // Filter by fromToward == 1

            _isLoading = false;
          });
        } else {
          print('No bus schedule data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load bus schedules data: $error');
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

      // Load offline data from local JSON
      final String response = await rootBundle.loadString('assets/bus_schedules.json');
      final data = json.decode(response) as List<dynamic>;
      setState(() {
        schedules = data.map((json) => BusSchedule.fromJson(json))
            .where((schedule) => schedule.fromToward == 1).toList(); // Filter by fromToward == 1
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(schedules[index].uniqueId ?? schedules[index].busNo.toString()),
            onDismissed: (direction) {
              deleteBusSchedule(index); // Update to handle BusSchedule deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bus No. ${schedules[index].busNo} deleted')),
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
              leading: Icon(Icons.directions_bus, color: Colors.blueAccent), // Icon for bus
              title: Text('Bus No. ${schedules[index].busNo ?? 'N/A'}'), // Bus number
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From: ${schedules[index].fromLocation ?? 'N/A'}'), // From location
                  Text('To: ${schedules[index].toLocation ?? 'N/A'}'),     // To location
                  SizedBox(height: 4), // Spacing between texts
                  Text('Starting Time: ${schedules[index].startingTime ?? 'N/A'}'), // Starting time
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Edit':
                      editBusSchedule(index);
                      break;
                    case 'Duplicate':
                      duplicateBusSchedule(index);
                      break;
                    case 'Delete':
                      deleteBusSchedule(index);
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
                icon: Icon(Icons.more_vert, color: Colors.teal), // Trailing icon
              ),
              onTap: () {
                showBusScheduleDetails(index); // Update to show BusSchedule details
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                  if (mounted) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BusScheduleDetailsPage(schedule: schedules[index])),
                    // );
                  }
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showBusScheduleForm(context); // Call a form for adding a new BusSchedule
          await _loadBusSchedulesData(); // Load BusSchedules after adding
          setState(() {
            // Additional functionality for the floating action button can go here
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }





  void _showBusScheduleForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Add a Route',
          [
            _buildTextField('From Location Name', Icons.category_rounded, _fromDestinationController),
            _buildTextField('Destination Name', Icons.description_outlined, _toDestinationController),
            _buildTimePickUpField("Start Time", Icons.time_to_leave_outlined, _startingTimeController),
            _buildTimePickUpField("Toward Time", Icons.time_to_leave_outlined, _towardTimeController),
            _buildNumberField("Bus|Shuttle No", Icons.bus_alert_outlined, _busNoController),
            _buildPhoneField("Driver Phone", Icons.phone_android_outlined, _driverPhoneController),
            _buildTextField('Remarks', Icons.description_outlined, _remarksController),
            _buildIntSelectionDropdown(_selectedRouteType, (newValue) {
              setState(() {
                _selectedRouteType = newValue!;
              });
            }),
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

  Widget _buildTimePickUpField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true, // Makes the field non-editable
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(), // Set the initial time to now
          );

          if (pickedTime != null) {
            final localizations = MaterialLocalizations.of(context);
            String formattedTime = localizations.formatTimeOfDay(pickedTime, alwaysUse24HourFormat: false);

            // Set the selected time into the controller
            controller.text = formattedTime;
          }
        },
      ),
    );
  }

  Widget _buildIntSelectionDropdown(int selectedValue, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Select Route Type',
          suffixIcon: Icon(Icons.directions),
        ),
        items: [
          DropdownMenuItem<int>(
            value: 0,
            child: Text('Only Location -> Destination'),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text('Both Location <-> Destination'),
          ),
        ],
      ),
    );
  }

  Widget _buildIntSelectionRadio(int selectedValue, ValueChanged<int?> onChanged) {
    return Column(
      children: [
        RadioListTile<int>(
          title: const Text('Only Location -> Destination'),
          value: 0,
          groupValue: selectedValue,
          onChanged: onChanged,
        ),
        RadioListTile<int>(
          title: const Text('Both Location <-> Destination'),
          value: 1,
          groupValue: selectedValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPhoneField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone, // Set keyboard for phone input
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Restrict to digits only
        ],
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
                onPressed: saveNewBusSchedule,
              ),
            ],
          ),
        ),
      ),
    );
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


}