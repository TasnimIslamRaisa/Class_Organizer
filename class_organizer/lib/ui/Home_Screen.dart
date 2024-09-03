import 'package:class_organizer/style/app_color.dart';
import 'package:class_organizer/ui/screens/students_screen/edit_profile.dart';
import 'package:class_organizer/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      // Add more items here as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Companion"),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected option
              switch (value) {
                case 'edit':
                // Navigate to the Edit screen or perform edit action
                  break;
                case 'settings':
                // Navigate to the Settings screen or perform settings action
                  break;
                case 'logout':
                // Perform logout action
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));

                },
                child: const Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            icon: const Icon(Icons.more_vert), // Options icon
          ),
        ],
      ),

      drawer: const DrawerWidget(),
      body: SafeArea(
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
                      color: Colors.grey[400],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),

                  // Name and Details
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tasnim",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.school_outlined),
                              SizedBox(width: 8),
                              Text(
                                "Bs in CSE",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textColor,
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
                        onPressed: () {},
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
                          color: Colors.grey[300],
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
      ),
    );
  }
}
