import 'dart:io';

import 'package:class_organizer/admin/school/pages/routines.dart';
import 'package:class_organizer/admin/school/school_setup.dart';
import 'package:class_organizer/ui/screens/students_screen/academic_calender_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/events_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/notes_screen.dart';
import 'package:class_organizer/web/black_box.dart';
import 'package:class_organizer/web/black_box_online.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/school.dart';
import '../../models/teacher.dart';
import '../../models/user.dart';
import '../../preference/logout.dart';
import '../../style/app_color.dart';
import '../../ui/screens/auth/SignInScreen.dart';
import '../../ui/screens/students_screen/edit_profile_screen.dart';
import '../../ui/screens/students_screen/settings_screen.dart';
import '../bus_schedule_screen.dart';

class DrawerWidgetAdmin extends StatefulWidget {
  const DrawerWidgetAdmin({Key? key}) : super(key: key);

  @override
  _DrawerWidgetAdminState createState() => _DrawerWidgetAdminState();
}

class _DrawerWidgetAdminState extends State<DrawerWidgetAdmin> {
  String? userName;
  String? userPhone;
  String? userEmail;
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
    _loadUserData();
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
        userName = userData['uname'];
        userPhone = userData['phone'];
        userEmail = userData['email'];
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
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
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
                  userName ?? 'T A S N I M',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  // Enable horizontal scrolling
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        userPhone ?? '+008 1800-445566',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.email_outlined,
                          size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        userEmail ?? 'r@gmail.com',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('B L A C K B O X'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BlackBoxOnline()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('P R O F I L E'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('S C H O O L  M E N U'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SchoolSetup()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('N O T E S & T A S K S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  NotesScreen()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page_outlined),
            title: const Text('R O U T I N E S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  RoutinesListPage()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.bus_alert_rounded),
            title: const Text('B U S - S C H E D U L E S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShuttleScheduleApp()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('ACADEMIC - C A L E N D A R'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AcademicCalender()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add_outlined),
            title: const Text('N O T I C E & E V E N T S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EventsScreen()));

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
                MaterialPageRoute(builder: (context) => const SettingScreen()),
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
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

// import 'package:class_organizer/ui/screens/auth/SignInScreen.dart';
// import 'package:class_organizer/ui/screens/students_screen/settings_screen.dart';
// import 'package:flutter/material.dart';

// import '../../style/app_color.dart';
// import '../screens/students_screen/edit_profile_screen.dart';

// class DrawerWidgetAdmin extends StatelessWidget {
//   const DrawerWidgetAdmin({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           const DrawerHeader(
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.person_pin_circle_sharp,
//                   size: 60,
//                   color: Colors.white,
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'T A S N I M ',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.phone,size:14,color: Colors.white,),
//                     Text(
//                       '+008 1800-445566',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(width: 15),
//                     Icon(Icons.email_outlined,size:14,color: Colors.white,),
//                     Text(
//                       ' r@gmail.com',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.account_box),
//             title: const Text('B L A C K B O X'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.palette),
//             title: const Text('P R O F I L E'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.bloodtype),
//             title: const Text('B L O O D B A N K'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.note),
//             title: const Text('N O T E S & T A S K S'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.request_page_outlined),
//             title: const Text('R O U T I N E S'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.bus_alert_rounded),
//             title: const Text('B U S - S C H E D U L E S'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.calendar_month_outlined),
//             title: const Text('ACADEMIC - C A L E N D A R'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.notification_add_outlined),
//             title: const Text('N O T I C E & E V E N T S'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.laptop_chromebook_rounded),
//             title: const Text('C L U B - M A N A G E M E N T'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('S E T T I N G S'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context)=>const SettingScreen()),

//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('L O G O U T'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context)=>const SignInScreen()),
//                   (route)=>false
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
