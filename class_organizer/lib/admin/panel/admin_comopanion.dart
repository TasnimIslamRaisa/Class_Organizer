import 'dart:async';
import 'dart:convert';
import 'package:class_organizer/web/black_box_online.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user.dart';
import '../../../preference/logout.dart';
import '../../../style/app_color.dart';
import '../../../web/black_box.dart';
import '../../../web/black_box_online_e.dart';

class AdminComopanion extends StatefulWidget {
  const AdminComopanion({super.key});

  @override
  _AdminComopanionState createState() => _AdminComopanionState();
}

class _AdminComopanionState extends State<AdminComopanion> {
  String _userName = 'Tasnim';

  User? _user;

  User? _user_data; // Default user name

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isLightMode ? Colors.blueGrey[50] : Colors.blueGrey[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item['date']!,
                              style: const TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              child: Icon(
                                item['icon'] == 'thumb_up'
                                    ? Icons.thumb_up
                                    : Icons.laptop_chromebook_sharp,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['text']!,
                              style: const TextStyle(
                                color: AppColors.textColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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