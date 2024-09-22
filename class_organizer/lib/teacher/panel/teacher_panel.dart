import 'package:class_organizer/teacher/panel/t_drawer_Widget.dart';
import 'package:class_organizer/teacher/panel/teacher_companion.dart';
import 'package:class_organizer/teacher/screen/edit_teacher_profile.dart';
import 'package:class_organizer/ui/screens/students_screen/campus_routine.dart';
import 'package:class_organizer/ui/screens/students_screen/class_manager_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/edit_profile_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/academic_calender_screen.dart';
import 'package:class_organizer/ui/screens/students_screen/student_companion_screen.dart';
import 'package:class_organizer/ui/widgets/drawer_widget.dart';
import 'package:class_organizer/utility/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../utility/profile_app_bar_teacher.dart';
class TeacherPanel extends StatefulWidget {
  const TeacherPanel({super.key});

  @override
  State<TeacherPanel> createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  int index = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: index == 0
          ? ProfileAppBarTeacher(
          title:  'Teacher Companions',
          actionIcon: Icons.more_vert,
          onActionPressed: (){},
          appBarbgColor: const Color(0xFF01579B),
      )
      : null,
      drawer: const t_DrawerWidget(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
        children: [
          const TeacherCompanion(),
          ClassManagerScreen(),
          const CampusRoutine(),
          const AcademicCalender(),
          const EditTeacherProfile(),
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
