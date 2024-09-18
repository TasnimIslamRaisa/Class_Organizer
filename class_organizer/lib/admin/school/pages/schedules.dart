import 'package:class_organizer/models/routine.dart';
import 'package:flutter/material.dart';

import '../../../models/major.dart';

class SchedulesPage extends StatefulWidget {
  final Routine routine;

  SchedulesPage({required this.routine});

  @override
  _SchedulesPageState createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final List<Map<String, dynamic>> semesters = [
    {'name': 'Semester 1', 'sId': 'sem1@example.com', 'uniqueId': '123456789'},
    {'name': 'Semester 2', 'sId': 'sem2@example.com', 'uniqueId': '987654321'},
    {'name': 'Semester 3', 'sId': 'sem3@example.com', 'uniqueId': '123456289'},
    {'name': 'Semester 4', 'sId': 'sem4@example.com', 'uniqueId': '987655321'},
  ];

  @override
  void initState() {
    super.initState();
    print(widget.routine.tempName);
  }

  void editSemester(int index) {
    // Handle editing a semester
    print('Editing ${semesters[index]['name']}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateSemester(int index) {
    // Duplicate the semester and add to the list
    setState(() {
      semesters.add({
        'name': '${semesters[index]['name']} (Duplicate)',
        'email': semesters[index]['email'],
        'phone': semesters[index]['phone'],
      });
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
          title: Text('${semester['name']} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${semester['name']}'),
              Text('sId: ${semester['sId']}'),
              Text('Unique ID: ${semester['uniqueId']}'),
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
            key: Key(semesters[index]['name']),
            onDismissed: (direction) {
              deleteSemester(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${semesters[index]['name']} deleted')),
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
              title: Text(semesters[index]['name']),
              onTap: () {
                showSemesterDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = semesters[index]['email'];
                      print('Emailing $email');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.teal),
                    onPressed: () {
                      final phone = semesters[index]['phone'];
                      print('Calling $phone');
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
            semesters.add({
              'name': 'New Semester',
              'email': 'newsemester@example.com',
              'phone': '111111111',
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
