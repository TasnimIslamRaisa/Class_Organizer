import 'package:flutter/material.dart';
import 'package:class_organizer/admin/school/exam/screen/section_edit_screen.dart';
import '../model/course.dart';
import '../model/section.dart';
import '../model/student_section.dart'; // Adjust the import as necessary
import 'add_student_dialog.dart'; // Import the dialog to add a student

class SectionDetailsScreen extends StatefulWidget {
  final Section section;
  final Course course;

  SectionDetailsScreen({required this.section, required this.course});

  @override
  _SectionDetailsScreenState createState() => _SectionDetailsScreenState();
}

class _SectionDetailsScreenState extends State<SectionDetailsScreen> {
  // Dummy data for demonstration; replace with actual data
  List<StudentSection> studentSections = [
    StudentSection(
      id: 1,
      uniqueId: 'unique1',
      sId: 's1',
      studentId: '0000221005312',
      sectionId: 'sec1',
      courseId: 'c1',
      timeSlotId: 'ts1',
      studentUniqueId: 'stu_unique1',
    ),
    StudentSection(
      id: 2,
      uniqueId: 'unique2',
      sId: 's2',
      studentId: '221003712',
      sectionId: 'sec1',
      courseId: 'c1',
      timeSlotId: 'ts2',
      studentUniqueId: 'stu_unique2',
    ),
    StudentSection(
      id: 3,
      uniqueId: 'unique3',
      sId: 's2',
      studentId: '221004712',
      sectionId: 'sec1',
      courseId: 'c1',
      timeSlotId: 'ts2',
      studentUniqueId: 'stu_unique2',
    ),
    // Add more students as needed
  ];

  void _addStudent() async {
    final newStudentIds = await showDialog<String>(
      context: context,
      builder: (context) {
        return AddStudentDialog(); // Show dialog to enter student IDs
      },
    );

    if (newStudentIds != null && newStudentIds.isNotEmpty) {
      final studentIdList = newStudentIds.split(',').map((id) => id.trim()).toList(); // Split by comma and trim spaces

      setState(() {
        for (String studentId in studentIdList) {
          if (studentId.isNotEmpty) {
            studentSections.add(StudentSection(
              id: studentSections.length + 1, // Incrementing ID for demo
              uniqueId: 'unique${studentSections.length + 1}',
              sId: 's${studentSections.length + 1}',
              studentId: studentId,
              sectionId: widget.section.sectionId,
              courseId: widget.course.courseId,
              timeSlotId: 'ts1', // Replace with actual time slot ID if necessary
              studentUniqueId: 'stu_unique${studentSections.length + 1}',
            ));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.section.sectionName} Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Name: ${widget.course.courseName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Section ID: ${widget.section.sectionId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Room Name: ${widget.section.roomName}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Total Students: ${widget.section.totalStudents}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Students:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  childAspectRatio: 2, // Adjust the aspect ratio as needed
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: studentSections.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          studentSections[index].studentId, // Display student ID
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addStudent();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SectionEditScreen(section: widget.section),
                //   ),
                // ).then((updatedSection) {
                //   if (updatedSection != null) {
                //     // Optionally handle updates
                //   }
                // });
              },
              child: Text('Add Student Ids'),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addStudent, // Call the function to add a student
      //   tooltip: 'Add Student',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('${widget.section.sectionName} Details'),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Course Name: ${widget.course.courseName}',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 16),
  //           Text(
  //             'Section ID: ${widget.section.sectionId}',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             'Room Name: ${widget.section.roomName}',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             'Total Students: ${widget.section.totalStudents}',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           SizedBox(height: 16),
  //           Text(
  //             'Students:',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: studentSections.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   title: Text(studentSections[index].studentId), // Display student ID
  //                 );
  //               },
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => SectionEditScreen(section: widget.section),
  //                 ),
  //               ).then((updatedSection) {
  //                 if (updatedSection != null) {
  //                   // Optionally handle updates
  //                 }
  //               });
  //             },
  //             child: Text('Edit Section'),
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _addStudent, // Call the function to add a student
  //       tooltip: 'Add Student',
  //       child: Icon(Icons.add),
  //     ),
  //   );
  // }
}
