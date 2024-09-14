import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preference/logout.dart';
import '../../ui/screens/auth/SignInScreen.dart';
import '../../ui/screens/students_screen/settings_screen.dart';
import 'teacher_panel.dart';

class t_DrawerWidget extends StatefulWidget {
  const t_DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<t_DrawerWidget> {
  String? userName;
  String? userPhone;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('s m rafi'),
            accountEmail: Text('rafi@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50.0,
                color: Colors.blue,
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF01579B),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('BLACKBOX'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('PROFILE'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text('BLOODBANK'),
            onTap: () {
              Navigator.pop(context);
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
              _showRoutineForm(context); // Open Routine form
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('SESSION'),
            onTap: () {
              Navigator.pop(context);
              _showSessionForm(context); // Open Session form
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('DEPARTMENT'),
            onTap: () {
              Navigator.pop(context);
              _showDepartmentForm(context); // Open Department form
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('SCHEDULES'),
            onTap: () {
              Navigator.pop(context);
              _showScheduleForm(context); // Open Schedule form
            },
          ),
          ListTile(
            leading: const Icon(Icons.bus_alert_rounded),
            title: const Text('B U S - S C H E D U L E S'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('ACADEMIC - C A L E N D A R'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add_outlined),
            title: const Text('N O T I C E & E V E N T S'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.laptop_chromebook_rounded),
            title: const Text('C L U B - M A N A G E M E N T'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('S E T T I N G S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>const SettingScreen()),

              );
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
                  MaterialPageRoute(builder: (context)=>const SignInScreen()),
                      (route)=>false
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
            _buildTextField('Routine Name', Icons.text_fields),
            _buildTextField('Routine Description', Icons.description),
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
            _buildTextField('Start Month (1,2,3...12)', Icons.calendar_today),
            _buildTextField('Start Year (2023, 2024...)', Icons.event),
            _buildTextField('Session Name', Icons.text_fields),
            _buildTextField('End Month (1,2,3...12)', Icons.calendar_today),
            _buildTextField('End Year (2023, 2024...)', Icons.event),
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
            _buildTextField('ID', Icons.numbers),
            _buildTextField('Department Name', Icons.business),
            _buildTextField('Location', Icons.location_city),
            _buildTextField('Phone', Icons.phone),
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
            _buildTextField('Course Title', Icons.book),
            _buildTextField('Course Code', Icons.code),
            _buildTextField('Section', Icons.group),
            _buildTextField('Room Name', Icons.room),
            _buildDropdownField('Select Day', Icons.calendar_today, [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday',
            ]),
            // Wrap Start and End Time in a Row to display them horizontally
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Start Time', Icons.access_time),
                ),
                const SizedBox(width: 10), // Spacing between fields
                Expanded(
                  child: _buildTextField('End Time', Icons.access_time),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }

  // Helper function to build dropdown fields
  Widget _buildDropdownField(String labelText, IconData icon, List<String> items) {
    String selectedItem = items[0]; // default selected item

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(icon),
          border: const UnderlineInputBorder(),
        ),
        value: selectedItem,
        onChanged: (String? newValue) {
          selectedItem = newValue!;
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Helper function to build the modal form structure
  Widget _buildForm(BuildContext context, String title, List<Widget> fields) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      height: 400, // Set height for the form
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
