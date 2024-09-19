import 'dart:async';
import 'dart:convert';

import 'package:class_organizer/models/rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../models/faculties.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/school.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../utility/unique.dart';
import '../../../web/internet_connectivity.dart';

class RoomListPage extends StatefulWidget {
  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomCodeController = TextEditingController();
  final TextEditingController _roomCampusController = TextEditingController();
  List<Room> rooms = [];

  final _databaseRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('rooms');
  bool _isLoading = true;
  bool isConnected = false;
  late StreamSubscription subscription;
  final internetChecker = InternetConnectivity();
  StreamSubscription<InternetConnectionStatus>? connectionSubscription;
  String? userName;
  String? userPhone;
  String? userEmail;
  User? _user, _user_data;
  final _formKey = GlobalKey<FormState>();
  String? sid;
  School? school;

  String? _selectedRoomType;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRoomsData();
    startListening();
    checkConnection();
    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });
  }


  void checkConnection() async {
    bool result = await internetChecker.hasInternetConnection();
    setState(() {
      isConnected = result;
    });
  }


  StreamSubscription<InternetConnectionStatus> checkConnectionContinuously() {
    return InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected) {
        isConnected = true;
        print('Connected to the internet');
        _loadRoomsData();
      } else {
        isConnected = false;
        print('Disconnected from the internet');
        // _loadFacultiesData();
      }
    });
  }

  void startListening() {
    connectionSubscription = checkConnectionContinuously();
  }

  void stopListening() {
    connectionSubscription?.cancel();
  }

  Future<void> _loadRoomsData() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isLoading = true;
      });

      // Reference to the rooms node in Firebase
      DatabaseReference roomsRef = _databaseRef.child('rooms');

      // Query rooms that match the current school's sId
      Query query = roomsRef.orderByChild('sId').equalTo(school?.sId);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> roomsData = dataSnapshot.value as Map<dynamic, dynamic>;

          setState(() {
            rooms = roomsData.entries.map((entry) {
              final Map<String, dynamic> roomMap = {
                'id': entry.value['id'],
                'userid': entry.value['userid'],
                'campus_id': entry.value['campus_id'],
                'room_name': entry.value['room_name'],
                'instructor_id': entry.value['instructor_id'],
                'room_code': entry.value['room_code'],
                'sId': entry.value['sId'],
                'status': entry.value['status'],
                'theory_lab': entry.value['theory_lab'],
                'sync_status': entry.value['sync_status'],
                'sync_key': entry.value['sync_key'],
              };
              return Room.fromMap(roomMap);
            }).toList();
            _isLoading = false;
          });
        } else {
          print('No Rooms data available for the current school.');
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        print('Failed to load rooms data: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // Handle offline mode
      setState(() {
        _isLoading = true;
      });
      showSnackBarMsg(context, "You are in Offline mode now, Please, connect Internet!");
      setState(() {
        _isLoading = false;
      });
      final String response = await rootBundle.loadString('assets/rooms.json');
      final data = json.decode(response) as List<dynamic>;
      setState(() {
        rooms = data.map((json) => Room.fromJson(json)).toList();
        _isLoading = false;
      });
    }
  }





  Future<void> _loadUserData() async {
    Logout logout = Logout();
    User? user = await logout.getUserDetails(key: 'user_data');

    Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
    Map<String, dynamic>? schoolMap = await logout.getSchool(key: 'school_data');

    if (userMap != null) {
      User user_data = User.fromMap(userMap);
      setState(() {
        _user_data = user_data;
      });
    } else {
      print("User map is null");
    }

    if (schoolMap != null) {
      School schoolData = School.fromMap(schoolMap);
      setState(() {
        _user = user;
        school = schoolData;
        sid = school?.sId;
        print(schoolData.sId);
      });
    } else {
      // Handle the case where `schoolMap` is null
      print("School data is null");
    }


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_logged_in');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['uname'];
        userPhone = userData['phone'];
        userEmail = userData['email'];
      });
    }
  }

  void showSnackBarMsg(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomCodeController.dispose();
    _roomCampusController.dispose();
    super.dispose();
  }

  void saveNewRoom() async {
    String roomName = _roomNameController.text.trim();
    String roomCode = _roomCodeController.text.trim();
    String roomCampus = _roomCampusController.text.trim();
    await _loadUserData();
    var uuid = Uuid();
    String uniqueId = uuid.v4(); // Generating a unique ID using Uuid package
    int lab = 1;
    if(_selectedRoomType != null && _selectedRoomType == "Theory Room"){
      lab = 1;
    }else{
      lab = 0;
    }

    if (roomName.isNotEmpty) {
      Room newRoom = Room(
        id: null,
        roomCode: uniqueId,
        sid: school?.sId,
        userid: DateTime.now().millisecondsSinceEpoch.toString(),
        campusId: roomCampus,
        theoryLab: lab,
        instructorId: 'T-new',
        status: 1,
        roomName: roomName,
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newRoom.roomCode != null && newRoom.roomCode!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("rooms")
              .child(newRoom.roomCode!);

          _database.set(newRoom.toMap()).then((_) {
            setState(() {
              rooms.add(newRoom);
            });
            _roomNameController.clear();
            _roomCodeController.clear();
            _roomCampusController.clear();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Room added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add room: $error')),
            );
            print("Error adding room: $error");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid room code')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room name cannot be empty')),
      );
    }
  }


  void editRoom(int index) {
    // Handle editing a faculty
    print('Editing ${rooms[index].roomName}');
    // You can add a TextField or dialog to actually edit the details.
  }

  void duplicateRoom(int index) {
    // Duplicate the room and add to the list
    setState(() {
      rooms.add(Room(
        id: null, // ID will be null for the new instance
        roomCode: '${rooms[index].roomCode}-DUP', // Create a unique roomCode
        sid: rooms[index].sid,
        userid: rooms[index].userid,
        campusId: rooms[index].campusId,
        theoryLab: rooms[index].theoryLab,
        instructorId: rooms[index].instructorId,
        status: rooms[index].status,
        syncStatus: rooms[index].syncStatus,
        syncKey: rooms[index].syncKey,
        roomName: '${rooms[index].roomName} (Duplicate)', // Update the name to indicate duplication
      ));
    });
  }


  void deleteRoom(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }

  void showRoomDetails(int index) {
    final room = rooms[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${room.roomName} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Name: ${room.roomName}'),
              Text('Room Code: ${room.roomCode}'),
              Text('sId: ${room.sid}'),
              Text('Instructor ID: ${room.instructorId}'),
              Text('Status: ${room.status}'),
              Text('Sync Status: ${room.syncStatus}'),
              Text('Sync Key: ${room.syncKey}'),
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
        title: Text('Class Room'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(rooms[index].roomCode ?? rooms[index].roomName ?? ''),
            onDismissed: (direction) {
              deleteRoom(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${rooms[index].roomName} deleted')),
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
              title: Text(rooms[index].roomName ?? ''),
              onTap: () {
                showRoomDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.teal),
                    onPressed: () {
                      final email = rooms[index].userid;
                      print('Emailing $email');
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          editRoom(index);
                          break;
                        case 'Duplicate':
                          duplicateRoom(index);
                          break;
                        case 'Delete':
                          deleteRoom(index);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Edit', 'Duplicate', 'Delete']
                          .map((String choice) {
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
          _showRoomForm(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }




  void _showRoomForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildForm(
          context,
          'Create Class Room',
          [
            _buildSelectionField(
              labelText: 'Room Type',
              icon: Icons.room,
              controller: _roomCodeController,
            ),
            _buildTextField('Room Name|Code(*)', Icons.business, _roomNameController),
            _buildTextField('Room Campus', Icons.house_outlined, _roomCampusController),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String labelText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildSelectionField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedRoomType,
        hint: Text(labelText),
        icon: Icon(icon),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
        ),
        items: <String>['Theory Room', 'Lab Room'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedRoomType = newValue;
            controller.text = newValue ?? '';
          });
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, String title, List<Widget> fields) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: fields,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Center(child: Text('SAVE')),
                onPressed: saveNewRoom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
