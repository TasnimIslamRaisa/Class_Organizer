import 'dart:async';
import 'dart:convert';
import 'package:class_organizer/ui/screens/students_screen/class_manager_screen.dart';
import 'package:class_organizer/web/black_box_online.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../db/database_helper.dart';
import '../../../models/schedule_item.dart';
import '../../../models/school.dart';
import '../../../models/teacher.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../style/app_color.dart';
import '../../../utility/auto_function_caller.dart';
import '../../../utility/card/flash_card_routine.dart';
import '../../../web/black_box.dart';
import '../../../web/black_box_online_e.dart';
import '../../../web/internet_connectivity.dart';
import '../controller/class_routine_controller.dart';
import '../controller/schedule_controller.dart';

class StudentCompanionScreen extends StatefulWidget {
  const StudentCompanionScreen({super.key});

  @override
  _StudentCompanionScreenState createState() => _StudentCompanionScreenState();
}

class _StudentCompanionScreenState extends State<StudentCompanionScreen> {
  String _userName = 'Tasnim';
  final ClassController classController = Get.put(ClassController());
  final ScheduleController scheduleController = Get.put(ScheduleController());
  List<ScheduleItem> schedules = [];
  List<ScheduleItem> nextDaySchedules = [];
  final _databaseRef = FirebaseDatabase.instance.ref();
  // final DatabaseReference _database = FirebaseDatabase.instance.ref().child('schedules');
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
  Teacher? teacher;

  final AutoFunctionCaller _functionCaller = AutoFunctionCaller();
  PageController _pageController1 = PageController();
  PageController _pageController2 = PageController();
  int _currentIndex1 = 0;
  int _currentIndex2 = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // First load user data
    await _loadUserData();

    loadSchedules();
    getSchedules();
    _startAutomaticUpdates();
    // Then load teacher data
    // _loadTeacherData();
  }

  void _startAutomaticUpdates() {
    _functionCaller.startTimer(
      interval: Duration(seconds: 10),
      functionToCall: getSchedules,
    );
  }

  // Stop the timer
  void _stopAutomaticUpdates() {
    _functionCaller.stopTimer();
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

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['uname'];
        userPhone = userData['phone'];
        userEmail = userData['email'];
      });
    }
  }

  Future<void> _loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUserData = prefs.getString('user_logged_in');

    if (savedUserData != null) {
      Map<String, dynamic> userData = jsonDecode(savedUserData);
      setState(() {
        _userName = userData['uname'] ?? 'Tasnim';
      });
    }
  }

  Future<void> _loadUser() async {
    Logout logout = Logout();
    User? user = await logout.getUserDetails(key: 'user_data');
    Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
    User user_data = User.fromMap(userMap!);
    setState(() {
      _user = user;
      _user_data = user_data;
    });
  }

  void showSnackBarMsg(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onSwipe1(int index) {
    setState(() {
      _currentIndex1 = index;
    });
  }

  void _onSwipe2(int index) {
    setState(() {
      _currentIndex2 = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'title': 'TODAY',
        'date': 'Sat, 31 August',
        'icon': 'thumb_up',
        'text': 'No Class Today',
      },
      {
        'title': 'NEXT CLASS',
        'date': 'Thu, 5 September',
        'icon': 'book',
        'text': 'CSE 412.1',
      },
    ];

    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // Original Row with Icon, Name, and Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:isLightMode ? Colors.blueGrey[100] : Colors.blueGrey[600],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                // Name and Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userName, // Display the fetched user name here
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.school_outlined),
                            const SizedBox(width: 8),
                            Text(
                              "Bs in CSE",
                              style: TextStyle(
                                fontSize: 16,
                                color: isLightMode ? AppColors.textColor : Colors.blueGrey[300],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Buttons
                Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("PROFILE"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BlackBoxOnlineE()));
                      },
                      child: const Text("RDS"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ListView Builder
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: PageView.builder(
                      controller: _pageController1,
                      onPageChanged: _onSwipe1,
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        return FlashcardRoutine(
                          flashcard: schedules[index],
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 1,
                    child: PageView.builder(
                      controller: _pageController2,
                      onPageChanged: _onSwipe2,
                      itemCount: nextDaySchedules.length,
                      itemBuilder: (context, index) {
                        return FlashcardRoutine(
                          flashcard: nextDaySchedules[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
              // child: ListView.builder(
              //   itemCount: items.length,
              //   itemBuilder: (context, index) {
              //     final item = items[index];
              //     return Padding(
              //       padding: const EdgeInsets.only(bottom: 12.0),
              //       child: Container(
              //         padding: const EdgeInsets.all(12),
              //         decoration: BoxDecoration(
              //           color: isLightMode ? Colors.blueGrey[50] : Colors.blueGrey[600],
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: ListTile(
              //           contentPadding: EdgeInsets.zero,
              //           title: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(
              //                 item['title']!,
              //                 style: const TextStyle(
              //                   color: AppColors.textColor,
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               Text(
              //                 item['date']!,
              //                 style: const TextStyle(
              //                   color: AppColors.textColor,
              //                   fontSize: 16,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           subtitle: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Container(
              //                 width: 80,
              //                 height: 80,
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Colors.grey.withOpacity(0.2),
              //                 ),
              //                 child: Icon(
              //                   item['icon'] == 'thumb_up'
              //                       ? Icons.thumb_up
              //                       : Icons.laptop_chromebook_sharp,
              //                   color: Colors.grey,
              //                   size: 40,
              //                 ),
              //               ),
              //               const SizedBox(height: 8),
              //               Text(
              //                 item['text']!,
              //                 style: const TextStyle(
              //                   color: AppColors.textColor,
              //                   fontSize: 18,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSchedules() async {
    print("farhad foysal timer");
    List<ScheduleItem> fetchedSchedules = await DatabaseHelper().getTodaySchedulesById(_user!.uniqueid!);
    if(fetchedSchedules.isNotEmpty){
      schedules.clear();
    }else{

    }
    if (!mounted) return;
    setState(() {
      schedules = fetchedSchedules;
    });

    final DateTime now = DateTime.now();
    final DateTime nextDay = now.add(Duration(days: 1));
    final String nextDayString = DateFormat('EEEE').format(nextDay);

    List<ScheduleItem> fetchedNextSchedules = await DatabaseHelper().getSchedulesByDayAndTimeId(nextDayString,_user!.uniqueid!);
    if(fetchedNextSchedules.isNotEmpty){
      nextDaySchedules.clear();
    }else{

    }
    if (!mounted) return;
    setState(() {
      nextDaySchedules = fetchedNextSchedules;
    });

  }
  String incrementDay(int incrementBy) {
    final DateTime now = DateTime.now();
    final DateTime newDay = now.add(Duration(days: incrementBy));
    return DateFormat('EEEE').format(newDay);
  }

  Future<void> loadSchedules() async {

    if (await InternetConnectionChecker().hasConnection) {

      DatabaseReference schedulesRef = _databaseRef.child('schedules');

      Query query = schedulesRef.orderByChild('temp_code').equalTo(_user?.uniqueid);

      query.once().then((DatabaseEvent event) {
        final dataSnapshot = event.snapshot;

        if (dataSnapshot.exists) {
          final Map<dynamic, dynamic> schedulesData = dataSnapshot.value as Map<dynamic, dynamic>;

          // Convert the schedules data into a list of ScheduleItems
          List<ScheduleItem> fetchedSchedules = schedulesData.entries.map((entry) {
            Map<String, dynamic> scheduleMap = {
              'id': entry.value['id'] ?? null,
              'uniqueId': entry.value['uniqueId'] ?? '',
              'sId': entry.value['sId'] ?? '',
              'stdId': entry.value['stdId'] ?? '',
              'tId': entry.value['tId'] ?? '',
              'temp_code': entry.value['temp_code'] ?? '',
              'temp_num': entry.value['temp_num'] ?? '',
              'sub_name': entry.value['sub_name'] ?? '',
              'sub_code': entry.value['sub_code'] ?? '',
              't_id': entry.value['t_id'] ?? '',
              't_name': entry.value['t_name'] ?? '',
              'room': entry.value['room'] ?? '',
              'campus': entry.value['campus'] ?? '',
              'section': entry.value['section'] ?? '',
              'start_time': entry.value['start_time'] ?? '',
              'end_time': entry.value['end_time'] ?? '',
              'day': entry.value['day'] ?? '',
              'key': entry.value['key'] ?? '',
              'sync_key': entry.value['sync_key'] ?? '',
              'min': entry.value['min'] ?? 0,
              'sync_status': entry.value['sync_status'] ?? 0,
              'dateTime': entry.value['dateTime'] != null ? DateTime.parse(entry.value['dateTime']) : null,
            };
            return ScheduleItem.fromMap(scheduleMap);
          }).toList();
          schedules.clear();
          schedules = fetchedSchedules;
          saveSchedulesOffline(fetchedSchedules);
          classController.clearClasses();
          // Pass the fetched schedules to the ScheduleController
          classController.setSchedules(fetchedSchedules);

        } else {
          print('No schedules available for the given routine.');
        }
      }).catchError((error) {
        print('Failed to load schedules: $error');
      });
    } else {
      // Handle offline mode
      showSnackBarMsg(context, "You are offline. Please connect to the internet.");
      // getSchedulesOffline();
    }
  }
  Future<void> saveSchedulesOffline(List<ScheduleItem> fetchedSchedules) async {
    deleteSchedules();
    await DatabaseHelper().setSchedulesList(fetchedSchedules);
  }
  Future<void> deleteSchedules() async {
    await DatabaseHelper().deleteSchedules(_user?.uniqueid??"");
  }


  @override
  void dispose() {
    _stopAutomaticUpdates();
    super.dispose();
  }
}




// import 'package:flutter/material.dart';

// import '../../../style/app_color.dart';

// class StudentCompanionScreen extends StatelessWidget {
//   const StudentCompanionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> items = [
//       {
//         'title': 'TODAY',
//         'date': 'Sat, 31 August',
//         'icon': 'thumb_up',
//         'text': 'No Class Today',
//       },
//       {
//         'title': 'NEXT CLASS',
//         'date': 'Thu, 5 September',
//         'icon': 'book',
//         'text': 'CSE 412.1',
//       },
//       // Add more items here as needed
//     ];

//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(22),
//         child: Column(
//           children: [
//             // Original Row with Icon, Name, and Buttons
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Icon
//                 Container(
//                   width: 65,
//                   height: 65,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.blueGrey[100],
//                   ),
//                   child: const Icon(
//                     Icons.person,
//                     color: Colors.white,
//                     size: 60,
//                   ),
//                 ),

//                 // Name and Details
//                 const Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Tasnim",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(Icons.school_outlined),
//                             SizedBox(width: 8),
//                             Text(
//                               "Bs in CSE",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: AppColors.textColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Buttons
//                 Column(
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text("PROFILE"),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text("RDS"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // ListView Builder
//             Expanded(
//               child: ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   final item = items[index];
//                   return Padding(
//                       padding: const EdgeInsets.only(bottom: 12.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey[50],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 item['title']!,
//                                 style: const TextStyle(
//                                   color: AppColors.textColor,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Text(
//                                 item['date']!,
//                                 style: const TextStyle(
//                                   color: AppColors.textColor,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           subtitle: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.grey.withOpacity(0.2),
//                                 ),
//                                 child: Icon(
//                                   item['icon'] == 'thumb_up'
//                                       ? Icons.thumb_up
//                                       : Icons.laptop_chromebook_sharp,
//                                   color: Colors.grey,
//                                   size: 40,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 item['text']!,
//                                 style: const TextStyle(
//                                   color: AppColors.textColor,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )

//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }