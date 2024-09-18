import 'package:flutter/material.dart';

class ClassManagerPage extends StatefulWidget {
  const ClassManagerPage({Key? key}) : super(key: key);

  @override
  _ClassManagerPageState createState() => _ClassManagerPageState();
}

class _ClassManagerPageState extends State<ClassManagerPage> {
  String selectedShift = 'Day'; // Shift initialized to 'Day'
  String selectedSection = 'A'; // Section initialized to 'A'
  List<Map<String, String>> selectedCourses = []; // List to store selected courses
  String? pendingCourse; // To store the course selected in the dialog

  void _addNewCourse() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedCourse = 'CSE112: Computer Fundamentals'; // Default selected course

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Please select your course'),
              content: DropdownButton<String>(
                value: selectedCourse,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCourse = newValue!;
                  });
                },
                items: [
                  'CSE112: Computer Fundamentals',
                  'CSE113: Programming Basics',
                  'CSE114: Data Structures',
                  'CSE115: Algorithms',
                  'CSE116: Computer Architecture',
                  'CSE117: Operating Systems',
                  'CSE118: Database Systems',
                  'CSE119: Software Engineering',
                  'CSE120: Artificial Intelligence',
                  // Add more courses if needed
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog without adding
                  },
                ),
                TextButton(
                  child: const Text('CONFIRM'),
                  onPressed: () {
                    setState(() {
                      pendingCourse = selectedCourse!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a section to continue'),
                        ),
                      );
                    });
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _selectSection() {
    setState(() {
      if (pendingCourse != null) {
        // Add selected course and section to the list
        selectedCourses.add({
          'course': pendingCourse!,
          'section': selectedSection,
        });
        pendingCourse = null; // Clear pending course
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Manager'),
        backgroundColor: Colors.lightBlue, // Changed to sky blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Shift and Section inputs
            Row(
              children: [
                // Shift dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Changed to white
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.lightBlue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Shift'),
                        DropdownButton<String>(
                          value: selectedShift,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedShift = newValue!;
                            });
                          },
                          items: ['Day', 'Night'].map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Section dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Changed to white
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.lightGreen),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Section'),
                        DropdownButton<String>(
                          value: selectedSection,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSection = newValue!;
                              _selectSection(); // Trigger course and section confirmation
                            });
                          },
                          items: List.generate(10, (index) {
                            return DropdownMenuItem(
                              value: String.fromCharCode(65 + index), // Sections A-J
                              child: Text(String.fromCharCode(65 + index)),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display selected courses below the Shift and Section containers
            if (selectedCourses.isNotEmpty)
              Column(
                children: selectedCourses.map((course) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Course: ${course['course']}'),
                              const SizedBox(height: 4),
                              Text('Section: ${course['section']}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              selectedCourses.remove(course);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            // Add new course button
            ElevatedButton(
              onPressed: _addNewCourse,
              child: const Text('ADD NEW COURSE'),
            ),
          ],
        ),
      ),
    );
  }
}
