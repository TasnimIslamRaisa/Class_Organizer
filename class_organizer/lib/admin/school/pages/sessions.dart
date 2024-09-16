import 'package:flutter/material.dart';

class SessionListPage extends StatefulWidget {
  @override
  _SessionListPageState createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  final List<Map<String, dynamic>> sessions = [
    {'name': 'Day', 'sId': 'da@example.com', 'uniqueId': '123456789'},
    {'name': 'Evening', 'sId': 'ev@example.com', 'uniqueId': '987654321'},
    {'name': 'Bangla', 'sId': 'ba@example.com', 'uniqueId': '123456289'},
    {'name': 'English', 'sId': 'en@example.com', 'uniqueId': '987655321'},
  ];

  void editSession(int index) {
    // Handle editing a session
    print('Editing ${sessions[index]['name']}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateSession(int index) {
    // Duplicate the session and add to the list
    setState(() {
      sessions.add({
        'name': '${sessions[index]['name']} (Duplicate)',
        'email': sessions[index]['email'],
        'phone': sessions[index]['phone'],
      });
    });
  }

  void deleteSession(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  void showSessionDetails(int index) {
    final session = sessions[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${session['name']} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${session['name']}'),
              Text('sId: ${session['sId']}'),
              Text('Unique ID: ${session['uniqueId']}'),
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
        title: Text('Sessions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(sessions[index]['name']),
            onDismissed: (direction) {
              deleteSession(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${sessions[index]['name']} deleted')),
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
              title: Text(sessions[index]['name']),
              onTap: () {
                showSessionDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = sessions[index]['email'];
                      print('Emailing $email');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.teal),
                    onPressed: () {
                      final phone = sessions[index]['phone'];
                      print('Calling $phone');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editSession(index);
                          break;
                        case 'Duplicate':
                          duplicateSession(index);
                          break;
                        case 'Delete':
                          deleteSession(index);
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
          // Handle add session action
          setState(() {
            sessions.add({
              'name': 'New Session',
              'email': 'newsession@example.com',
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
