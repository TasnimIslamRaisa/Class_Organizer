import 'package:flutter/material.dart';

class ThursdayContent extends StatelessWidget {
  const ThursdayContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'courseName': 'Computer Graphics',
        'courseCode': 'CSE 321',
        'teacher': 'TJ',
        'section': 'A',
        'time': '10:00 AM - 11:30 AM',
        'classroom': 'Room 108',
      },
      {
        'courseName': 'Compiler Design',
        'courseCode': 'CSE 319',
        'teacher': 'ASZ',
        'section': 'A',
        'time': '11:30 AM - 1:00 PM',
        'classroom': 'Room 108',
      },
      {
        'courseName': 'Computer Graphics Lab',
        'courseCode': 'CSE 322',
        'teacher': 'TJ',
        'section': 'A',
        'time': '01:30 PM - 03:00 AM',
        'classroom': 'Lab 115',
      },

    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ListView Builder
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];  // Use index to access the items
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon in center
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.book,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          ),
                          // Column for course details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['courseName'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['courseCode'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Teacher Initial: ${item['teacher']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Section: ${item['section']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['time'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.class_,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['classroom'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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