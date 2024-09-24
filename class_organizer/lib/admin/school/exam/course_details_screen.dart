import 'package:class_organizer/admin/school/exam/screen/section_details_screen.dart';
import 'package:class_organizer/admin/school/exam/screen/section_edit_screen.dart';
import 'package:flutter/material.dart';
import 'model/course.dart'; // Adjust the import as necessary
import 'model/section.dart'; // Adjust the import as necessary


class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  CourseDetailsScreen({required this.course});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  // Dummy sections for demonstration; replace with actual data
  List<Section> sections = [
    Section(id: 1, uniqueId: 'sec1', sId: 'sec1', sectionId: 's1', courseId: 'c1', sectionName: 'Section A', roomName: 'Room 101', totalStudents: 30),
    Section(id: 2, uniqueId: 'sec2', sId: 'sec2', sectionId: 's2', courseId: 'c1', sectionName: 'Section B', roomName: 'Room 102', totalStudents: 25),
  ];

  void _editSection(Section section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionEditScreen(section: section),
      ),
    ).then((updatedSection) {
      if (updatedSection != null) {
        setState(() {
          // Update the section in the list
          int index = sections.indexWhere((s) => s.id == section.id);
          if (index != -1) {
            sections[index] = updatedSection; // Replace with updated section
          }
        });
      }
    });
  }


  void _deleteSection(Section section) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Section'),
          content: Text('Are you sure you want to delete ${section.sectionName}?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  sections.remove(section); // Remove the section from the list
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addSection() {
    final _formKey = GlobalKey<FormState>(); // Key to identify the form
    String sectionName = '';
    String roomName = '';
    int totalStudents = 0; // Default value

    // Show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Section'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Section Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a section name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    sectionName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Room Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a room name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    roomName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Total Students'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the total number of students';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    totalStudents = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, create a new section
                  Section newSection = Section(
                    id: sections.length + 1, // Generate a new ID
                    uniqueId: 'sec${sections.length + 1}', // Generate a unique ID
                    sId: 'sec${sections.length + 1}',
                    sectionId: 's${sections.length + 1}',
                    courseId: widget.course.courseId,
                    sectionName: sectionName,
                    roomName: roomName,
                    totalStudents: totalStudents,
                  );

                  setState(() {
                    sections.add(newSection); // Add the new section to the list
                  });
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
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
        title: Text(widget.course.courseName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course ID: ${widget.course.courseId}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Section: ${widget.course.sId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Sections:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(section.sectionName),
                      subtitle: Text('Room: ${section.roomName}, Total Students: ${section.totalStudents}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SectionDetailsScreen(section: section, course: widget.course), // Implement this screen
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editSection(section),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteSection(section),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addSection,
        child: Icon(Icons.add),
        tooltip: 'Add Section', // Tooltip for the FAB
      ),
    );
  }
}
