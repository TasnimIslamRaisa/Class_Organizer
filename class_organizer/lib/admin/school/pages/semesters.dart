import 'dart:math';

import 'package:class_organizer/admin/school/pages/semester_course_structure.dart';
import 'package:class_organizer/utility/unique.dart';
import 'package:flutter/material.dart';
import '../../../models/major.dart';
import '../../../models/semester.dart';

class SemestersPage extends StatefulWidget {
  final Major department;

  SemestersPage({required this.department});

  @override
  _SemestersPageState createState() => _SemestersPageState();
}

class _SemestersPageState extends State<SemestersPage> {

  late Major department;

  List<Semester> semesters = [];

  @override
  void initState() {
    super.initState();
    generateSemesters();
    setState(() {
      department = widget.department;
    });
    print(widget.department.mName);
  }

  void generateSemesters() {
    final random = Random(); // Used to generate random values if needed
    for (int i = 1; i <= 12; i++) {
      Semester semester = Semester(
        id: i,
        semName: i,
        uniqueId: 'SEM_${widget.department.uniqueId}_$i',
        // sId: 'S${random.nextInt(10000)}',
        sId: widget.department.sId??"",
        departmentId: widget.department.uniqueId??"",
        numSec: 10,
        numCourses: 0,
        uId: 'U${random.nextInt(1000)}',
      );

      semesters.add(semester);
    }
    setState(() {

    });
  }

  void editSemester(int index) {
    // Handle editing a semester
    print('Editing ${semesters[index].sId}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateSemester(int index) {
    // Duplicate the semester and add to the list
    setState(() {
      final semesterToDuplicate = semesters[index];
      semesters.add(Semester(
        semName: semesters.length + 1,
        id: semesters.length + 1, // Increment ID for new semester
        uniqueId: '${semesterToDuplicate.uniqueId} (Duplicate)',
        sId: semesterToDuplicate.sId,
        departmentId: semesterToDuplicate.departmentId,
        numSec: semesterToDuplicate.numSec,
        numCourses: semesterToDuplicate.numCourses,
        uId: semesterToDuplicate.uId,
      ));
    });
  }

  void deleteSemester(int index) {
    setState(() {
      semesters.removeAt(index);
    });
  }

  void showSemesterDetails(int index) {
    final semester = semesters[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${semester.sId} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${semester.uniqueId}'),
              Text('sId: ${semester.sId}'),
              Text('Unique ID: ${semester.uniqueId}'),
              Text('Number of Sections: ${semester.numSec}'),
              Text('Number of Courses: ${semester.numCourses}'),
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
        title: Text('Semesters'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: semesters.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(semesters[index].uniqueId),
            onDismissed: (direction) {
              deleteSemester(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${semesters[index].uniqueId} deleted')),
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
              title: Text("SEM - ${semesters[index].semName}"),
              onTap: () {
                showSemesterDetails(index);
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pop(context);
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SemesterCourseStructure(semester: semesters[index],department: widget.department,)),
                    );
                  }
                });
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = semesters[index].sId;
                      print('Emailing $email');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editSemester(index);
                          break;
                        case 'Duplicate':
                          duplicateSemester(index);
                          break;
                        case 'Delete':
                          deleteSemester(index);
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
          // Handle add semester action
          setState(() {
            semesters.add(Semester(
              semName: semesters.length + 1,
              id: semesters.length + 1, // Increment ID for new semester
              uniqueId: Unique().generateUniqueID(),
              sId: widget.department.sId??"",
              departmentId: widget.department.uniqueId??"",
              numSec: 10,
              numCourses: 0,
              uId: widget.department.deanId??"",
            ));
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
