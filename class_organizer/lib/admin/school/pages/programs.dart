import 'package:flutter/material.dart';

class ProgramListPage extends StatefulWidget {
  @override
  _ProgramListPageState createState() => _ProgramListPageState();
}

class _ProgramListPageState extends State<ProgramListPage> {
  final List<Map<String, dynamic>> programs = [
    {'name': 'Day', 'sId': 'da@example.com', 'uniqueId': '123456789'},
    {'name': 'Evening', 'sId': 'ev@example.com', 'uniqueId': '987654321'},
    {'name': 'Bangla', 'sId': 'ba@example.com', 'uniqueId': '123456289'},
    {'name': 'English', 'sId': 'en@example.com', 'uniqueId': '987655321'},
  ];

  void editProgram(int index) {
    // Handle editing a program
    print('Editing ${programs[index]['name']}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateProgram(int index) {
    // Duplicate the program and add to the list
    setState(() {
      programs.add({
        'name': '${programs[index]['name']} (Duplicate)',
        'email': programs[index]['email'],
        'phone': programs[index]['phone'],
      });
    });
  }

  void deleteProgram(int index) {
    setState(() {
      programs.removeAt(index);
    });
  }

  void showProgramDetails(int index) {
    final program = programs[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${program['name']} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${program['name']}'),
              Text('sId: ${program['sId']}'),
              Text('Unique ID: ${program['uniqueId']}'),
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
        title: Text('Programs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(programs[index]['name']),
            onDismissed: (direction) {
              deleteProgram(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${programs[index]['name']} deleted')),
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
              title: Text(programs[index]['name']),
              onTap: () {
                showProgramDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = programs[index]['email'];
                      print('Emailing $email');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.teal),
                    onPressed: () {
                      final phone = programs[index]['phone'];
                      print('Calling $phone');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editProgram(index);
                          break;
                        case 'Duplicate':
                          duplicateProgram(index);
                          break;
                        case 'Delete':
                          deleteProgram(index);
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
          // Handle add program action
          setState(() {
            programs.add({
              'name': 'New Program',
              'email': 'newprogram@example.com',
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






// import 'package:flutter/material.dart';
//
// class ProgramListPage extends StatefulWidget {
//   @override
//   _ProgramListPageState createState() => _ProgramListPageState();
// }
//
// class _ProgramListPageState extends State<ProgramListPage> {
//   final List<Map<String, dynamic>> programs = [
//     {'name': 'Computer Science', 'email': 'cs@example.com', 'phone': '123456789'},
//     {'name': 'Business Administration', 'email': 'ba@example.com', 'phone': '987654321'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Programs'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: programs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(programs[index]['name']),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.email, color: Colors.teal),
//                   onPressed: () {
//                     // Handle email action
//                     final email = programs[index]['email'];
//                     print('Emailing $email');
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.phone, color: Colors.teal),
//                   onPressed: () {
//                     // Handle phone action
//                     final phone = programs[index]['phone'];
//                     print('Calling $phone');
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle add program action
//           setState(() {
//             // Example: Add a new program to the list
//             programs.add({
//               'name': 'New Program',
//               'email': 'newprogram@example.com',
//               'phone': '111111111',
//             });
//           });
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.teal,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       // bottomNavigationBar: Padding(
//       //   padding: const EdgeInsets.all(8.0),
//       //   child: ElevatedButton(
//       //     onPressed: () {
//       //       // Handle save action
//       //     },
//       //     child: Text('Saved'),
//       //     style: ElevatedButton.styleFrom(
//       //       foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
//       //       shape: RoundedRectangleBorder(
//       //         borderRadius: BorderRadius.circular(20),
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
