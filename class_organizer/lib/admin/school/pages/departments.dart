import 'package:flutter/material.dart';

class DepartmentListPage extends StatefulWidget {
  @override
  _DepartmentListPageState createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  final List<Map<String, dynamic>> departments = [
    {'name': 'Day', 'sId': 'da@example.com', 'uniqueId': '123456789'},
    {'name': 'Evening', 'sId': 'ev@example.com', 'uniqueId': '987654321'},
    {'name': 'Bangla', 'sId': 'ba@example.com', 'uniqueId': '123456289'},
    {'name': 'English', 'sId': 'en@example.com', 'uniqueId': '987655321'},
  ];

  void editDepartment(int index) {
    // Handle editing a department
    print('Editing ${departments[index]['name']}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateDepartment(int index) {
    // Duplicate the department and add to the list
    setState(() {
      departments.add({
        'name': '${departments[index]['name']} (Duplicate)',
        'email': departments[index]['email'],
        'phone': departments[index]['phone'],
      });
    });
  }

  void deleteDepartment(int index) {
    setState(() {
      departments.removeAt(index);
    });
  }

  void showDepartmentDetails(int index) {
    final department = departments[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${department['name']} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${department['name']}'),
              Text('sId: ${department['sId']}'),
              Text('Unique ID: ${department['uniqueId']}'),
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
        title: Text('Departments'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(departments[index]['name']),
            onDismissed: (direction) {
              deleteDepartment(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${departments[index]['name']} deleted')),
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
              title: Text(departments[index]['name']),
              onTap: () {
                showDepartmentDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = departments[index]['email'];
                      print('Emailing $email');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.teal),
                    onPressed: () {
                      final phone = departments[index]['phone'];
                      print('Calling $phone');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editDepartment(index);
                          break;
                        case 'Duplicate':
                          duplicateDepartment(index);
                          break;
                        case 'Delete':
                          deleteDepartment(index);
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
          // Handle add department action
          setState(() {
            departments.add({
              'name': 'New Department',
              'email': 'newdepartment@example.com',
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
