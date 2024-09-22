import 'dart:async';
import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:class_organizer/admin/school/schedule/weekly_schedules.dart';
import 'package:class_organizer/models/routine.dart';
import 'package:class_organizer/models/teacher.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../db/database_helper.dart';
import '../../../models/major.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/school.dart';
import '../../../models/user.dart' as local;
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';


class TeachersListPage extends StatefulWidget {
  @override
  _TeachersListPageState createState() => _TeachersListPageState();
}

class _TeachersListPageState extends State<TeachersListPage> {
  final TextEditingController _teacherNameController = TextEditingController();
  final TextEditingController _teacherEmailController = TextEditingController();
  final TextEditingController _teacherPhoneController = TextEditingController();
  final TextEditingController _teacherAddressController = TextEditingController();
  List<Teacher> teachers = [];

  final _auth = FirebaseAuth.instance;
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
  local.User? _user, _user_data;
  final _formKey = GlobalKey<FormState>();
  String? sid;
  School? school;

  List<Major> departments = [];
  Major? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTeachersData();
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
    local.User? user = await logout.getUserDetails(key: 'user_data');

    Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
    Map<String, dynamic>? schoolMap = await logout.getSchool(key: 'school_data');

    if (userMap != null) {
      local.User user_data = local.User.fromMap(userMap);
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
    _teacherNameController.dispose();
    _teacherEmailController.dispose();
    _teacherPhoneController.dispose();
    _teacherAddressController.dispose();
    super.dispose();
  }

  void saveNewTeacher() async {
    String teacherName = '${_teacherNameController.text.trim()}';
    String teacherEmail = _teacherEmailController.text.trim();
    String teacherPhone = _teacherPhoneController.text.trim();
    String teacherAddress = _teacherAddressController.text.trim();

    await _loadUserData();
    String uniqueId = Unique().generateUniqueID();
    var uuid = Uuid();

    if (teacherName.isNotEmpty && teacherEmail.isNotEmpty && teacherPhone.isNotEmpty) {
      Teacher newTeacher = Teacher(
        id: null,
        sId: school?.sId,
        uniqueId: uniqueId,
        tName: teacherName,
        tEmail: teacherEmail,
        tPhone: teacherPhone,
        tAddress: teacherAddress,
        tMajor: _selectedDepartment?.mName,
        aStatus: 1,
        uId: uuid.v4(),
        tPass: teacherPhone,
      );

        saveTeacherAsUser(newTeacher);
          if (await InternetConnectionChecker().hasConnection) {
            if (newTeacher.uniqueId != null && newTeacher.uniqueId!.isNotEmpty) {
              final DatabaseReference _database = FirebaseDatabase.instance
                  .ref("teachers")
                  .child(newTeacher.uniqueId!);

              _database.set(newTeacher.toJson()).then((_) {
                setState(() {
                  teachers.add(newTeacher);
                });
                _teacherNameController.clear();
                _teacherEmailController.clear();
                _teacherPhoneController.clear();
                _teacherAddressController.clear();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Teacher added')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add teacher: $error')),
                );
                print("Error adding teacher: $error");
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




  void editTeacher(int index) {
    print('Editing ${teachers[index].tName}');
  }

  void duplicateTeacher(int index) {
    setState(() {
      teachers.add(Teacher(
        id: null,
        sId: teachers[index].sId,
        uniqueId: '${teachers[index].uniqueId}-DUP', // Ensure unique identifier for duplication
        designation: teachers[index].designation,
        tName: '${teachers[index].tName} (Duplicate)',
        tPhone: teachers[index].tPhone,
        tPass: teachers[index].tPass,
        tEmail: teachers[index].tEmail,
        tAddress: teachers[index].tAddress,
        aStatus: teachers[index].aStatus,
        tMajor: teachers[index].tMajor,
        tBal: teachers[index].tBal,
        tLogo: teachers[index].tLogo,
        tId: teachers[index].tId,
        uType: teachers[index].uType,
        proPic: teachers[index].proPic,
        nidBirth: teachers[index].nidBirth,
        uId: teachers[index].uId,
        syncStatus: teachers[index].syncStatus,
        syncKey: teachers[index].syncKey,
      ));
    });
  }

  void deleteTeacher(int index) {
    setState(() {
      teachers.removeAt(index);
    });
  }

  void showTeacherDetails(int index) {
    final teacher = teachers[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${teacher.tName} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unique ID: ${teacher.uniqueId}'),
              Text('Designation: ${teacher.designation ?? 'N/A'}'),
              Text('Email: ${teacher.tEmail ?? 'N/A'}'),
              Text('Phone: ${teacher.tPhone ?? 'N/A'}'),
              Text('Address: ${teacher.tAddress ?? 'N/A'}'),
              Text('Status: ${teacher.aStatus == 1 ? 'Active' : 'Inactive'}'),
              Text('Major: ${teacher.tMajor ?? 'N/A'}'),
              Text('Balance: ${teacher.tBal ?? 'N/A'}'),
              Text('User ID: ${teacher.uId}'),
              Text('Sync Status: ${teacher.syncStatus == 1 ? 'Synced' : 'Not Synced'}'),
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



  Future<void> _loadTeachersData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the teachers node in Firebase
      DatabaseReference teachersRef = _databaseRef.child('teachers');

      // Query teachers that match the current school's sId
      Query query = teachersRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> teachersData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            // Convert the teachers data into a list of Teacher objects
            teachers = teachersData.entries.map((entry) {
              Map<String, dynamic> teacherMap = {
                'id': entry.value['id'] ?? null,
                'sId': entry.value['sId'] ?? null,
                'uniqueId': entry.value['uniqueId'] ?? null,
                'designation': entry.value['designation'] ?? null,
                'tName': entry.value['tName'] ?? null,
                'tPhone': entry.value['tPhone'] ?? null,
                'tPass': entry.value['tPass'] ?? null,
                'tEmail': entry.value['tEmail'] ?? null,
                'tAddress': entry.value['tAddress'] ?? null,
                'aStatus': entry.value['aStatus'] ?? 0,
                'tMajor': entry.value['tMajor'] ?? null,
                'tBal': entry.value['tBal'] ?? null,
                'tLogo': entry.value['tLogo'] ?? null,
                'tId': entry.value['tId'] ?? null,
                'uType': entry.value['uType'] ?? null,
                'proPic': entry.value['proPic'] != null ? Uint8List.fromList(List<int>.from(entry.value['proPic'])) : null,
                'nidBirth': entry.value['nidBirth'] ?? null,
                'uId': entry.value['uId'] ?? null,
                'syncStatus': entry.value['syncStatus'] ?? 0,
                'syncKey': entry.value['syncKey'] ?? null,
              };
              return Teacher.fromJson(teacherMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No teachers data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load teachers data: $error');
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
      final String response = await rootBundle.loadString('assets/teachers.json');
      final data = json.decode(response) as List<dynamic>;
      setState(() {
        teachers = data.map((json) => Teacher.fromJson(json)).toList();
        _isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(teachers[index].uniqueId ?? teachers[index].tName ?? ''),
            onDismissed: (direction) {
              deleteTeacher(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${teachers[index].tName} deleted')),
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
              leading: Icon(Icons.person, color: Colors.redAccent), // Left-side icon
              title: Text(teachers[index].tName ?? ''), // Teacher name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${teachers[index].tEmail ?? 'N/A'}'), // Teacher email
                  SizedBox(height: 4), // Spacing between texts
                  Text('Phone: ${teachers[index].tPhone ?? 'N/A'}'), // Teacher phone
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Edit':
                      editTeacher(index);
                      break;
                    case 'Duplicate':
                      duplicateTeacher(index);
                      break;
                    case 'Delete':
                      deleteTeacher(index);
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
                showTeacherDetails(index);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                  if (mounted) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => TeacherDetailsPage(teacher: teachers[index])),
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
          _showTeacherForm(context); // Call a form for adding a new teacher
          await _loadTeachersData(); // Load teachers data if necessary
          setState(() {
            // Additional functionality here for the floating action button
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }






  void _showTeacherForm(BuildContext context) {
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
            _buildTextField('Teacher Name', Icons.category_rounded, _teacherNameController),
            _buildEmailField('Teacher Email', Icons.email_outlined, _teacherEmailController),
            _buildPhoneField('Teacher Phone', Icons.phone_android_outlined, _teacherPhoneController),
            _buildTextField('Teacher Address', Icons.add_reaction_outlined, _teacherAddressController),

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
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ],
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildEmailField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress, // Set keyboard for email input
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
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
                onPressed: saveNewTeacher,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void copyTeacherPhone(int index) {
    String? teacherPhone = teachers[index].tPhone;

    if (teacherPhone != null && teacherPhone.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: teacherPhone)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Teacher Phone copied: $teacherPhone')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to copy: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Phone Number to copy')),
      );
    }
  }


  void shareTeacher(int index) {
    final teacher = teachers[index];
    String? teacherPhone = teacher.tPhone;
    String? teacherEmail = teacher.tEmail;

    if (teacherPhone != null && teacherEmail != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Share Teacher Info'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Share this Phone Number:'),
                SizedBox(height: 10),
                Text(teacherPhone),
                SizedBox(height: 20),
                Text('Share this Email Address:'),
                SizedBox(height: 10),
                Text(teacherEmail),
                SizedBox(height: 20),
                Text('QR Code for Phone Number:'),
                SizedBox(height: 10),
                BarcodeWidget(
                  barcode: Barcode.qrCode(), // QR code format
                  data: teacherPhone,
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
        SnackBar(content: Text('Teacher data is incomplete for sharing')),
      );
    }
  }

  void setMineRoutine(int index) {}

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

  saveTeacherAsUser(Teacher newTeacher) {
    registerUser("2", newTeacher);
  }

  Future<void> registerUser(String selectedRole, Teacher newTeacher) async {
    int uType = 2;
    var uuid = Uuid();

    String uniqueId = Unique().generateUniqueID();



    if(await InternetConnectionChecker().hasConnection){

      try {

        List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(newTeacher.tEmail??"");

        if (signInMethods.isNotEmpty) {
          showSnackBarMsg(context, 'Email is already registered.');
          return;
        }

        DatabaseReference usersRef = _databaseRef.child("users");
        DatabaseEvent event = await usersRef.orderByChild("phone").equalTo(newTeacher.tPhone).once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          showSnackBarMsg(context, 'Phone number is already registered.');
          return;
        }

        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: newTeacher.tEmail??"",
          password: newTeacher.tPass??"",
        );

        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {

          local.User newUser = local.User(
            uniqueid: uniqueId,
            sid: newTeacher.sId,
            uname: newTeacher.tName,
            phone: newTeacher.tPhone??"",
            pass: newTeacher.tPass??"",
            email: newTeacher.tEmail,
            userid: newTeacher.uniqueId,
            utype: uType,
            status: 1,
          );

          await _databaseRef.child("users").child(newTeacher.uniqueId??"").set(newUser.toMap());

          print("User successfully signed up and saved to database");

          await saveUserOffline(newTeacher.uniqueId??"", newTeacher.uId??"", newTeacher);

        }
      } catch (e) {
        showSnackBarMsg(context,"Signup failed: $e");
      }

    }else{
      showSnackBarMsg(context, "You are in Offline Mode now, Please connect Internet");
      await saveUserOffline(newTeacher.uniqueId??"", newTeacher.uId??"",newTeacher);
    }







    // Map<String, dynamic> requestInput = {
    //   "email": emailController.text.trim(),
    //   "firstName": firstNameController.text.trim(),
    //   "lastName": lastNameController.text.trim(),
    //   "mobile": mobileController.text.trim(),
    //   "password": passWordController.text,
    //   "photo": ""
    // };
    // NetworkResponse response =
    //     await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    // if (response.isSuccess) {
    //   if (mounted) {
    //     showSnackBarMsg(context, 'Registration Successful');
    //   }
    //   clearfield();
    // } else {
    //   if (mounted) {
    //     showSnackBarMsg(context, 'Registration Failed');
    //   }
    // }
  }

  Future<void> saveUserOffline(String uniqueId, String uuid,Teacher newTeacher) async {

    // sqlite

    local.User? existingUser = await DatabaseHelper().getUserByPhone(newTeacher.tPhone??"");

    if (existingUser != null) {

      if (mounted) {
        showSnackBarMsg(context, 'User already registered');
      }
      return;
    }

    local.User newUser = local.User(
      uniqueid: uniqueId,
      sid: newTeacher.sId,
      uname: newTeacher.tName,
      phone: newTeacher.tPhone??"",
      pass: newTeacher.tPass??"",
      email: newTeacher.tEmail??"",
      userid: newTeacher.uId??"",
      utype: 2,
      status: 1,
    );

    int result = await DatabaseHelper().insertUser(newUser);

    if (result > 0) {
      if (mounted) {
        showSnackBarMsg(context, 'Registration Successful');

      }

    } else {
      if (mounted) {
        showSnackBarMsg(context, 'Registration Failed');
      }
    }

  }

}