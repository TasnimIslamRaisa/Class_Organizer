import 'package:class_organizer/ui/screens/students_screen/campus_routine.dart';
import 'package:class_organizer/ui/screens/students_screen/class_manager_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/edit_profile_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/academic_calender_screen.dart';
import 'package:flutter/material.dart';

import '../../utility/profile_app_bar_admin.dart';
import '../widgets/drawer_widget_admin.dart';
import 'admin_comopanion.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int index = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: index == 0
          ? ProfileAppBarAdmin(
        title:  'Admin Companions',
        actionIcon: Icons.more_vert,
        onActionPressed: (){},
        appBarbgColor: const Color(0xFF01579B),
      )
          : null,
      drawer: const DrawerWidgetAdmin(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
        children:  [
          AdminComopanion(),
          ClassManagerScreen(),
          CampusRoutine(),
          AcademicCalender(),
          EditProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          _pageController.jumpToPage(value);
          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        elevation: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_outlined),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),

    );
  }
}
