import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:class_organizer/models/teacher.dart';
import 'package:class_organizer/teacher/panel/teacher_panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/major.dart';
import '../../models/school.dart';
import '../../models/user.dart';
import '../../preference/logout.dart';
import '../../ui/Home_Screen.dart';
import '../../ui/screens/students_screen/settings_screen.dart';
import '../../ui/widgets/background_widget.dart';
import '../../ui/widgets/drawer_widget.dart';
import '../../utility/profile_app_bar.dart';
import '../../utility/profile_app_bar_teacher.dart';
import '../../utility/unique.dart';
import '../../web/internet_connectivity.dart';
import '../panel/t_drawer_Widget.dart';


class EditTeacherProfile extends StatefulWidget {
  const EditTeacherProfile({super.key});

  @override
  _EditTeacherProfileState createState() => _EditTeacherProfileState();
}

class _EditTeacherProfileState extends State<EditTeacherProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  TextEditingController creditsController = TextEditingController();
  String? selectedDepartment;
  String? selectedSemester;
  File? _selectedImage;
  bool _showSaveButton = false;

  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('routines');
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
  Teacher? teacher; // use this object to display teacher data in textField

  List<Major> departments = [];
  Major? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // First load user data
    await _loadUserData();

    // Then load teacher data
    _loadTeacherData();
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
      print("School data is null");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_logged_in');
    String? imagePath = prefs.getString('profile_picture-${_user?.uniqueid!}');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['uname'];
        userPhone = userData['phone'];
        userEmail = userData['email'];
        nameController.text = userData['uname'] ?? '';
        if (imagePath != null) {
          _selectedImage = File(imagePath);
        }
      });
    }
  }

  Future<void> _saveUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> updatedUserData = {
      'uname': nameController.text,
      'university': universityController.text,
      'department': selectedDepartment,
      'semester': selectedSemester,
      'cgpa': cgpaController.text,
      'creditsCompleted': creditsController.text,
    };

    await prefs.setString('user_logged_in', jsonEncode(updatedUserData));
    if (_selectedImage != null) {
      await prefs.setString('profile_picture-${_user?.uniqueid!}', _selectedImage!.path);
    }

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Center(child: Text("Successfully Updated")),
        );
      },
    );

    // Navigate to HomeScreen after a delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TeacherPanel()),
      );
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _showSaveButton = true; // Show save button after image selection
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    return Scaffold(
      appBar: ProfileAppBarTeacher(
        title: 'Edit Teacher Profile',
        actionIcon: Icons.more_vert,
        onActionPressed: () {},
        appBarbgColor: Colors.cyan,
      ),
      drawer: const t_DrawerWidget(),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture with Camera Icon
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            image: _selectedImage != null
                                ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: _selectedImage == null
                              ? const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage, // Call the image picker on tap
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Container(
                        //     width: 40,
                        //     height: 40,
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.grey,
                        //       border: Border.all(
                        //         color: Colors.white,
                        //         width: 2,
                        //       ),
                        //     ),
                        //     child: const Icon(
                        //       Icons.camera_alt,
                        //       color: Colors.white,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_showSaveButton)
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveUserData,
                        child: const Text('Save Picture'),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Name TextField
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      //isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600]
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // University TextField
                  TextField(
                    controller: universityController,
                    decoration: InputDecoration(
                      labelText: 'University',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Department Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedDepartment,
                    decoration: InputDecoration(
                      labelText: 'Department',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                    items: const [
                      DropdownMenuItem(value: 'CSE', child: Text('CSE')),
                      DropdownMenuItem(value: 'EEE', child: Text('EEE')),
                      DropdownMenuItem(value: 'BBA', child: Text('BBA')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Semester Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedSemester,
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                    items: const [
                      DropdownMenuItem(value: '1st', child: Text('1st')),
                      DropdownMenuItem(value: '2nd', child: Text('2nd')),
                      DropdownMenuItem(value: '3rd', child: Text('3rd')),
                      DropdownMenuItem(value: '4th', child: Text('4th')),
                      DropdownMenuItem(value: '5th', child: Text('5th')),
                      DropdownMenuItem(value: '6th', child: Text('6th')),
                      DropdownMenuItem(value: '7th', child: Text('7th')),
                      DropdownMenuItem(value: '8th', child: Text('8th')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSemester = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // CGPA TextField
                  TextField(
                    controller: cgpaController,
                    decoration: InputDecoration(
                      labelText: 'CGPA',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Credits TextField
                  TextField(
                    controller: creditsController,
                    decoration: InputDecoration(
                      labelText: 'Credits Completed',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Id',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Edit',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Notes
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• Ensure all information is correct."),
                        SizedBox(height: 4),
                        Text("• Update your profile picture."),
                        SizedBox(height: 4),
                        Text("• Verify CGPA and credits."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),


      // Floating Action Buttons for Settings and Save
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[500],
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (contex) => const SettingScreen()),
                );
              },
              heroTag: 'settings',
              child: const Icon(Icons.settings),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: _saveUserData,
              heroTag: 'save',
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTeacherData() async {
    _loadUserData();
    Teacher? teacherr = await getTeacherByUniqueId(_user?.uniqueid??"");
    if(teacherr==null){
      saveNewTeacher();
    }else{
      setState(() {
        teacher = teacherr;
      });
    }

  }

  Future<Teacher?> getTeacherByUniqueId(String uniqueId) async {
    print("farhad ${uniqueId}");
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref("teachers");

    try {
      // Querying the teachers node by uniqueId
      DatabaseEvent event = await dbRef.orderByChild('uniqueId').equalTo(uniqueId).once();

      // Check if the snapshot has data
      if (event.snapshot.value != null) {
        // The result will be a map of teachers with unique keys
        Map<dynamic, dynamic> teacherMap = event.snapshot.value as Map<dynamic, dynamic>;

        // Check if we got at least one result
        if (teacherMap.isNotEmpty) {
          // Get the first teacher entry from the map
          var teacherData = teacherMap.values.first;

          // Convert the map to a Teacher object
          Teacher teacher = Teacher.fromMap(Map<String, dynamic>.from(teacherData));

          return teacher;
        } else {
          print('No teacher found with this uniqueId');
          return null;
        }
      } else {
        print('No teacher data found in the database');
        return null;
      }
    } catch (e) {
      print('Error fetching teacher: $e');
      return null;
    }
  }







  void saveNewTeacher() async {
    String teacherName = _user?.uname??"";
    String teacherEmail = _user?.email??"";
    String teacherPhone = _user?.phone??"";
    String teacherAddress = "Address";

    String uniqueId = Unique().generateUniqueID();

    if (teacherName.isNotEmpty && teacherEmail.isNotEmpty && teacherPhone.isNotEmpty) {
      Teacher newTeacher = Teacher(
        id: null,
        sId: school?.sId,
        uniqueId: _user?.uniqueid??"",
        tName: teacherName,
        tEmail: teacherEmail,
        tPhone: teacherPhone,
        tAddress: teacherAddress,
        aStatus: 1,
        uId: uniqueId,
        tPass: teacherPhone,
      );

      if (await InternetConnectionChecker().hasConnection) {
        if (newTeacher.uniqueId != null && newTeacher.uniqueId!.isNotEmpty) {
          final DatabaseReference _database = FirebaseDatabase.instance
              .ref("teachers")
              .child(newTeacher.uniqueId!);

          _database.set(newTeacher.toJson()).then((_) {
            setState(() {
              teacher = newTeacher;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Teacher added')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add teacher: $error')),
            );
            print("Error adding teacher: $error");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid unique ID')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection')),
        );
      }



    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

}

// import 'dart:async';
// import 'package:class_organizer/ui/screens/students_screen/settings_screen.dart';
// import 'package:flutter/material.dart';
// import '../../Home_Screen.dart';
// import '../../widgets/drawer_widget_admin.dart';
// import '../../../utility/profile_app_bar.dart';
// import '../../widgets/background_widget.dart';

// class EditProfileScreen extends StatelessWidget {
//   const EditProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ProfileAppBar(
//         title: 'Edit Profile',
//         actionIcon: Icons.more_vert,
//         onActionPressed: () {},
//         appBarbgColor: Colors.cyan,
//       ),
//       drawer: const DrawerWidget(),
//       body: SingleChildScrollView(
//         child: BackgroundWidget(
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Profile Picture with Camera Icon
//                   Center(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey[300],
//                           ),
//                           child: const Icon(
//                             Icons.person,
//                             size: 80,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 2,
//                               ),
//                             ),
//                             child: const Icon(
//                               Icons.camera_alt,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Name TextField
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.all(16),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // University TextField
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'University',
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.all(16),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Department Dropdown
//                   DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       labelText: 'Department',
//                       border: InputBorder.none,
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                     items: const [
//                       DropdownMenuItem(value: 'CSE', child: Text('CSE')),
//                       DropdownMenuItem(value: 'EEE', child: Text('EEE')),
//                       DropdownMenuItem(value: 'BBA', child: Text('BBA')),
//                     ],
//                     onChanged: (value) {
//                       // Handle department selection
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Semester Dropdown
//                   DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       labelText: 'Semester',
//                       border: InputBorder.none,
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                     items: const [
//                       DropdownMenuItem(value: '1st', child: Text('1st')),
//                       DropdownMenuItem(value: '2nd', child: Text('2nd')),
//                       DropdownMenuItem(value: '3rd', child: Text('3rd')),
//                       DropdownMenuItem(value: '4th', child: Text('4th')),
//                       DropdownMenuItem(value: '5th', child: Text('5th')),
//                       DropdownMenuItem(value: '6th', child: Text('6th')),
//                       DropdownMenuItem(value: '7th', child: Text('7th')),
//                       DropdownMenuItem(value: '8th', child: Text('8th')),
//                       DropdownMenuItem(value: '9th', child: Text('9th')),
//                       DropdownMenuItem(value: '10th', child: Text('10th')),
//                       DropdownMenuItem(value: '11th', child: Text('11th')),
//                       DropdownMenuItem(value: '12th', child: Text('12th')),
//                     ],
//                     onChanged: (value) {
//                       // Handle semester selection
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // CGPA TextField
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'CGPA',
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.all(16),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Credits TextField
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Credits Completed',
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.all(16),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Notes with Dots
//                   const Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("• Ensure all information is correct."),
//                         SizedBox(height: 4),
//                         Text("• Update your profile picture."),
//                         SizedBox(height: 4),
//                         Text("• Verify CGPA and credits."),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       // Floating Action Buttons for both Settings and Save
//       floatingActionButton: Stack(
//         children: [
//           Positioned(
//             bottom: 16,
//             left: 50,
//             child: FloatingActionButton(
//               backgroundColor: Colors.blueGrey[500],
//               foregroundColor: Colors.white,
//               shape: const CircleBorder(),
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (contex)=>const SettingScreen())
//                 );
//               },
//               heroTag: 'settings', // Unique heroTag for each button
//               child: const Icon(Icons.settings),
//             ),
//           ),
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: FloatingActionButton(
//               backgroundColor: Colors.cyan,
//               foregroundColor: Colors.white,
//               shape: const CircleBorder(),
//               onPressed: () {
//                 // Show alert dialog with "Profile updated"
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return const AlertDialog(
//                       title: Center(child: Text("Successfully Updated",style: TextStyle(
//                         fontSize: 18
//                       ),)),
//                       //content: Text("Profile updated!"),
//                     );
//                   },
//                 );

//                 // Delay for 3 seconds before navigating to HomeScreen
//                 Future.delayed(const Duration(seconds: 1), () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => const HomeScreen()),
//                   );
//                 });
//               },
//               heroTag: 'save', // Unique heroTag for each button
//               child: const Icon(Icons.check),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
