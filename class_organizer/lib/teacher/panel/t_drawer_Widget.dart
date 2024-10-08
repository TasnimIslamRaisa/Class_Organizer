import 'dart:convert';
import 'dart:io';
import 'package:class_organizer/admin/school/pages/departments.dart';
import 'package:class_organizer/admin/school/pages/routines.dart';
import 'package:class_organizer/admin/school/pages/sessions.dart';
import 'package:class_organizer/test/test.dart';
import 'package:class_organizer/test/test_v2.dart';
import 'package:class_organizer/test/test_v3.dart';
import 'package:class_organizer/ui/screens/students_screen/campus_routine.dart';
import 'package:class_organizer/ui/screens/students_screen/class_manager.dart';
import 'package:class_organizer/ui/screens/students_screen/edit_profile_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/events_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/school.dart';
import '../../models/teacher.dart';
import '../../models/user.dart';
import '../../preference/logout.dart';
import '../../test/test_v1.dart';
import '../../ui/screens/auth/SignInScreen.dart';
import '../../ui/screens/students_screen/academic_calender_screen.dart';
import '../../ui/screens/students_screen/settings_screen.dart';
import '../../web/black_box_online.dart';

class t_DrawerWidget extends StatefulWidget {
  const t_DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<t_DrawerWidget> {
  String _userName = 'Rafi';
  String? _userPhone = '+008 1800-445566';
  String? _userEmail = 'r@gmail.com';

  User? _user, _user_data;
  final _formKey = GlobalKey<FormState>();
  String? sid;
  School? school;
  Teacher? teacher;
  File? _selectedImage;
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadUserData();
  }

  Future<void> _loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUserData = prefs.getString('user_logged_in');

    if (savedUserData != null) {
      Map<String, dynamic> userData = jsonDecode(savedUserData);
      setState(() {
        _userName = userData['uname'] ?? 'Rafi';
        _userPhone = userData['phone'] ?? '+008 1800-445566';
        _userEmail = userData['email'] ?? 'r@gmail.com';
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
    String? imagePath = prefs.getString('profile_picture-${_user?.uniqueid!}');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        _userName = userData['uname'];
        _userPhone = userData['phone'];
        _userEmail = userData['email'];
        if (imagePath != null) {
          _selectedImage = File(imagePath);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Extended DrawerHeader
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF246481), // Using color from your previous designs
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_pin_circle_sharp,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, size: 14, color: Colors.white),
                    Text(
                      _userPhone ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.email_outlined, size: 14, color: Colors.white),
                    Text(
                      _userEmail ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('BLACKBOX'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => BlackBoxOnline()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('PROFILE'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text('Course Structure'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManagerPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notes),
            title: const Text('NOTES & TASKS'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('ROUTINES'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CampusRoutine()));

              // _showRoutineForm(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('SESSION'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SessionListPage()));

              // _showSessionForm(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('DEPARTMENT'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentListPage()));

              // _showDepartmentForm(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('SCHEDULES'),
            onTap: () {
              Navigator.pop(context);
              _showScheduleForm(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bus_alert_rounded),
            title: const Text('B U S - S C H E D U L E S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => FlashcardRoutineSystem()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('ACADEMIC - C A L E N D A R'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AcademicCalender()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add_outlined),
            title: const Text('N O T I C E & E V E N T S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventsScreen()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.laptop_chromebook_rounded),
            title: const Text('C L U B - M A N A G E M E N T'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventsScreen()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('S E T T I N G S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('L O G O U T'),
            onTap: () async {
              await Logout().logoutUser();
              await Logout().clearUser(key: "user_logged_in");

              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
// Function to show the Routine Form
  void _showRoutineForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'New Routine',
          [
            _buildTextField('Routine Name'),
            _buildTextField('Routine Description'),
          ],
        );
      },
    );
  }

// Function to show the Session Form
  void _showSessionForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Session',
          [
            _buildTextField('Start Month (1,2,3...12)'),
            _buildTextField('Start Year (2023, 2024...)'),
            _buildTextField('Session Name'),
            _buildTextField('End Month (1,2,3...12)'),
            _buildTextField('End Year (2023, 2024...)'),
          ],
        );
      },
    );
  }

// Function to show the Department Form
  void _showDepartmentForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Department',
          [
            _buildTextField('ID'),
            _buildTextField('Department Name'),
            _buildTextField('Location'),
            _buildTextField('Phone'),
          ],
        );
      },
    );
  }

// Function to show the Schedule Form
  void _showScheduleForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'New Schedule',
          [
            _buildTextField('Course Title'),
            _buildTextField('Course Code'),
            _buildTextField('Instructor'),
          ],
        );
      },
    );
  }

// Helper function to build a form with text fields
  Widget _buildForm(BuildContext context, String title, List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...fields,
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

// Helper function to build a text field without an icon
  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increase vertical padding for spacing
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0), // More rounded corners
            borderSide: BorderSide(
              color: Colors.grey.shade400, // Light grey border color
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.grey.shade400, // Apply to enabled state
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.blue, // Blue color when the field is focused
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0), // Larger padding inside the field
        ),
        style: const TextStyle(fontSize: 16), // Font size adjustment
      ),
    );
  }


}
