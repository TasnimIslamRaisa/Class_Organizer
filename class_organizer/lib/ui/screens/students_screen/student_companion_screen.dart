import 'package:flutter/material.dart';

import '../../../style/app_color.dart';

class StudentCompanionScreen extends StatelessWidget {
  const StudentCompanionScreen({super.key});

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
                    color: Colors.blueGrey[100],
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
                          color: Colors.blueGrey[50],
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
                      )

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