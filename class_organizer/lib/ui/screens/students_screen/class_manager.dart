import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding/decoding data

class ClassManagerPage extends StatefulWidget {
  const ClassManagerPage({Key? key}) : super(key: key);

  @override
  _ClassManagerPageState createState() => _ClassManagerPageState();
}

class _ClassManagerPageState extends State<ClassManagerPage> {
  int selectedSemester = 1; // Semester initialized to '1'
  String selectedSection = 'A'; // Section initialized to 'A'
  List<Map<String, String>> selectedCourses = []; // List to store selected courses
  String? pendingCourse; // To store the course selected in the dialog

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load saved data on initialization
  }

  // Function to load saved courses, semester, and section from SharedPreferences
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? coursesData = prefs.getString('selectedCourses');
    if (coursesData != null) {
      setState(() {
        selectedCourses = List<Map<String, String>>.from(json.decode(coursesData));
      });
    }

    // Load the saved semester and section, if available
    setState(() {
      selectedSemester = prefs.getInt('selectedSemester') ?? 1;
      selectedSection = prefs.getString('selectedSection') ?? 'A';
    });
  }

  // Function to save data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCourses', json.encode(selectedCourses));
    await prefs.setInt('selectedSemester', selectedSemester);
    await prefs.setString('selectedSection', selectedSection);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Courses have been saved successfully!'),
      ),
    );
  }

  // Function to add a new course via a pop-up dialog
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
                    });
                    Navigator.of(context).pop(); // Close dialog
                    _selectSection(); // Confirm the selection after course is added
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to confirm the selection of course and section
  void _selectSection() {
    // Only add the course if a pendingCourse is selected
    if (pendingCourse != null) {
      setState(() {
        // Add selected course and section to the list
        selectedCourses.add({
          'course': pendingCourse!,
          'section': selectedSection,
          'semester': selectedSemester.toString(),
        });
        pendingCourse = null; // Clear pending course
      });
    }
  }

  // Function to remove a selected course
  void _removeCourse(Map<String, String> course) {
    setState(() {
      selectedCourses.remove(course);
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
            // Semester and Section inputs
            Row(
              children: [
                // Semester dropdown
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
                        const Text('Semester'),
                        DropdownButton<int>(
                          value: selectedSemester,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedSemester = newValue!;
                            });
                          },
                          items: List.generate(8, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1, // Semesters 1-8
                              child: Text('Semester ${index + 1}'),
                            );
                          }),
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

            // Display selected courses below the Semester and Section containers
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
                              const SizedBox(height: 4),
                              Text('Semester: ${course['semester']}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            _removeCourse(course); // Remove the selected course
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

            // Save button to persist the courses
            ElevatedButton(
              onPressed: _saveData, // Save the updated list of courses
              child: const Text('SAVE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
