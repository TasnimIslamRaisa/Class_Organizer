import 'package:class_organizer/admin/school/pages/courses.dart';
import 'package:class_organizer/admin/school/pages/departments.dart';
import 'package:class_organizer/admin/school/pages/programs.dart';
import 'package:class_organizer/admin/school/pages/rooms.dart';
import 'package:class_organizer/admin/school/pages/sessions.dart';
import 'package:class_organizer/admin/school/pages/students.dart';
import 'package:class_organizer/ui/screens/students_screen/settings_screen.dart';
import 'package:flutter/material.dart';

class SchoolSetup extends StatefulWidget {
  const SchoolSetup({super.key});

  @override
  State<SchoolSetup> createState() => _SchoolSetupState();
}

class _SchoolSetupState extends State<SchoolSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu Grid Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildMenuItem(Icons.bus_alert_outlined, 'Bus', () => _navigateToPage(context, 'bus')),
                  _buildMenuItem(Icons.event_busy, 'Absences', () => _navigateToPage(context, 'absence')),
                  _buildMenuItem(Icons.calculate, 'Calculation', () => _navigateToPage(context, 'calculation')),
                  _buildMenuItem(Icons.qr_code_scanner, 'Scanner', () => _navigateToPage(context, 'scanner')),
                  _buildMenuItem(Icons.schedule, 'Timetable', () => _navigateToPage(context, 'time')),
                  _buildMenuItem(Icons.event_note, 'Schedule', () => _navigateToPage(context, 'schedules'), hasNotification: true, notificationCount: 3),
                  _buildMenuItem(Icons.note, 'Notes', () => _navigateToPage(context, 'notes')),
                  _buildMenuItem(Icons.person_search_outlined, 'Students', () => _navigateToPage(context, 'students')),
                  _buildMenuItem(Icons.people, 'Teachers', () => _navigateToPage(context, 'faculty')),
                  _buildMenuItem(Icons.school_outlined, 'Exams', () => _navigateToPage(context, 'exams')),
                  _buildMenuItem(Icons.punch_clock_outlined, 'Routines', () => _navigateToPage(context, 'routines')),
                  _buildMenuItem(Icons.book, 'Subjects', () => _navigateToPage(context, 'courses')),
                  _buildMenuItem(Icons.room_outlined, 'Rooms', () => _navigateToPage(context, 'rooms')),
                  _buildMenuItem(Icons.segment_outlined, 'Sessions', () => _navigateToPage(context, 'sessions')),
                  _buildMenuItem(Icons.apartment_outlined, 'Departments', () => _navigateToPage(context, 'departments')),
                  _buildMenuItem(Icons.category_outlined, 'Programs', () => _navigateToPage(context, 'programs')),
                  _buildMenuItem(Icons.bar_chart, 'Statistics', () => _navigateToPage(context, 'StatisticsPage')),

                ],
              ),
            ),

            // Today's Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Setup and Customize Your School",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildSummaryCard(Icons.schedule, 'Timetable', 'There is no classes', 'You don\'t have classes timetable to attend today.', () => _navigateToPage(context, 'TimetableSummaryPage')),
                _buildSummaryCard(Icons.book, 'Homework', 'No homework', 'Today you have no scheduled tasks to present.', () => _navigateToPage(context, 'HomeworkPage')),
                _buildSummaryCard(Icons.school, 'Exams', 'No exams', 'You don\'t have scheduled exams today.', () => _navigateToPage(context, 'ExamsPage')),
                _buildSummaryCard(Icons.event, 'Events', 'Cse', 'FgF', () => _navigateToPage(context, 'EventsPage')),
                _buildSummaryCard(Icons.book, 'Books', 'There are no books', 'Today you have no borrowed books to return.', () => _navigateToPage(context, 'BooksPage')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build menu item with navigation
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool hasNotification = false, int notificationCount = 0}) {
    return InkWell(
      onTap: onTap, // This will handle navigation when tapped
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green[50],
                child: Icon(icon, color: Colors.green, size: 30),
              ),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 12)),
            ],
          ),
          if (hasNotification)
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  notificationCount.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build summary card with navigation
  Widget _buildSummaryCard(IconData icon, String title, String subtitle, String description, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: ListTile(
          onTap: onTap, // This will handle navigation when tapped
          leading: CircleAvatar(
            backgroundColor: Colors.green[50],
            child: Icon(icon, color: Colors.green),
          ),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(subtitle),
              SizedBox(height: 4),
              Text(description, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }


  void _navigateToPage(BuildContext context, String pageName) {
    if(pageName=='programs'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramListPage()));
    }else if(pageName=='students'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsPage()));
    }else if(pageName=='departments'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentListPage()));
    }else if(pageName=='sessions'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SessionListPage()));
    }else if(pageName=='rooms'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomListPage()));
    }else if(pageName=='courses'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesListPage()));
    }else if(pageName=='routines'){
      // Navigator.push(context, MaterialPageRoute(builder: (context) => RoutinePage()));
    }else{

    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     // Placeholder for different pages, replace with actual page widgets
    //     return Scaffold(
    //       appBar: AppBar(title: Text(pageName)),
    //       body: Center(child: Text('This is the $pageName page')),
    //     );
    //   }),
    // );
  }
}



















// import 'package:flutter/material.dart';
//
// class SchoolSetup extends StatefulWidget {
//   const SchoolSetup({super.key});
//
//   @override
//   State<SchoolSetup> createState() => _SchoolSetupState();
// }
//
// class _SchoolSetupState extends State<SchoolSetup> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Menu'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Menu Grid Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.count(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 crossAxisCount: 4,
//                 childAspectRatio: 1,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//                 children: [
//                   _buildMenuItem(Icons.book, 'Subjects'),
//                   _buildMenuItem(Icons.event_busy, 'Absences'),
//                   _buildMenuItem(Icons.calculate, 'Calculation'),
//                   _buildMenuItem(Icons.schedule, 'Timetable'),
//                   _buildMenuItem(Icons.event_note, 'Schedule', hasNotification: true, notificationCount: 3),
//                   _buildMenuItem(Icons.note, 'Notes'),
//                   _buildMenuItem(Icons.people, 'Teachers'),
//                   _buildMenuItem(Icons.qr_code_scanner, 'Scanner'),
//                   _buildMenuItem(Icons.bar_chart, 'Statistics'),
//                 ],
//               ),
//             ),
//
//             // Today's Summary Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "Today's Summary",
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//             ),
//             ListView(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               children: [
//                 _buildSummaryCard(Icons.schedule, 'Timetable', 'There is no classes', 'You don\'t have classes timetable to attend today.'),
//                 _buildSummaryCard(Icons.book, 'Homework', 'No homework', 'Today you have no scheduled tasks to present.'),
//                 _buildSummaryCard(Icons.school, 'Exams', 'No exams', 'You don\'t have scheduled exams today.'),
//                 _buildSummaryCard(Icons.event, 'Events', 'Cse', 'FgF'),
//                 _buildSummaryCard(Icons.book, 'Books', 'There are no books', 'Today you have no borrowed books to return.'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(IconData icon, String title, {bool hasNotification = false, int notificationCount = 0}) {
//     return Stack(
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.green[50],
//               child: Icon(icon, color: Colors.green, size: 30),
//             ),
//             SizedBox(height: 8),
//             Text(title, style: TextStyle(fontSize: 12)),
//           ],
//         ),
//         if (hasNotification)
//           Positioned(
//             right: 0,
//             child: CircleAvatar(
//               radius: 10,
//               backgroundColor: Colors.red,
//               child: Text(
//                 notificationCount.toString(),
//                 style: TextStyle(fontSize: 12, color: Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildSummaryCard(IconData icon, String title, String subtitle, String description) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Card(
//         child: ListTile(
//           leading: CircleAvatar(
//             backgroundColor: Colors.green[50],
//             child: Icon(icon, color: Colors.green),
//           ),
//           title: Text(title),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 4),
//               Text(subtitle),
//               SizedBox(height: 4),
//               Text(description, style: TextStyle(fontSize: 12, color: Colors.grey)),
//             ],
//           ),
//           trailing: Icon(Icons.arrow_forward),
//         ),
//       ),
//     );
//   }
// }
