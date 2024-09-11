import 'package:flutter/material.dart';

class MondayContent extends StatelessWidget {
  const MondayContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'courseName': 'Software Engineering',
        'courseCode': 'CSE 412.1',
        'teacher': 'JK',
        'section': 'A',
        'time': '10:00 AM - 12:00 PM',
        'classroom': 'Room 302',
      },
      {
        'courseName': 'Operating Systems',
        'courseCode': 'CSE 313.2',
        'teacher': 'SD',
        'section': 'B',
        'time': '12:00 PM - 2:00 PM',
        'classroom': 'Room 304',
      },
      {
        'courseName': 'Database Systems',
        'courseCode': 'CSE 323.1',
        'teacher': 'AH',
        'section': 'C',
        'time': '2:00 PM - 4:00 PM',
        'classroom': 'Room 305',
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
