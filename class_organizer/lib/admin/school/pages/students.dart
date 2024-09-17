import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final List<Map<String, dynamic>> students = [
    {'name': 'Student 1', 'email': 'student1@example.com', 'phone': '123456789'},
    {'name': 'Student 2', 'email': 'student2@example.com', 'phone': '987654321'},
    {'name': 'Student 3', 'email': 'student3@example.com', 'phone': '123456289'},
    {'name': 'Student 4', 'email': 'student4@example.com', 'phone': '987655321'},
  ];

  void editStudent(int index) {
    // Handle editing a student
    print('Editing ${students[index]['name']}');
    // Implement your editing functionality here
  }

  void duplicateStudent(int index) {
    setState(() {
      students.add({
        'name': '${students[index]['name']} (Duplicate)',
        'email': students[index]['email'],
        'phone': students[index]['phone'],
      });
    });
  }

  void deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  void showStudentDetails(int index) {
    final student = students[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${student['name']} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${student['name']}'),
              Text('Email: ${student['email']}'),
              Text('Phone: ${student['phone']}'),
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
        title: Text('Students'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(students[index]['name']),
            onDismissed: (direction) {
              deleteStudent(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${students[index]['name']} deleted')),
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
              leading: Icon(Icons.circle, color: Colors.redAccent), // Icon on the left
              title: Text(students[index]['name']), // Student name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Short Detail'), // Placeholder for short detail
                  SizedBox(height: 4), // Spacing between text
                  Text('Delivery date: 17/09/2024'), // Placeholder delivery date
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Edit':
                      editStudent(index);
                      break;
                    case 'Duplicate':
                      duplicateStudent(index);
                      break;
                    case 'Delete':
                      deleteStudent(index);
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
                icon: Icon(Icons.more_vert, color: Colors.teal), // Menu icon on the right
              ),
              onTap: () {
                showStudentDetails(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            students.add({
              'name': 'New Student',
              'email': 'newstudent@example.com',
              'phone': '000000000',
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
