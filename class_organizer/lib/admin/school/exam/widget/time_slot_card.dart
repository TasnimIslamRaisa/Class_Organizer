import 'package:flutter/material.dart';
import '../course_details_screen.dart';
import '../model/course.dart';
import '../model/time_slot.dart';

class TimeSlotCard extends StatefulWidget {
  final TimeSlot timeSlot;
  final Function onDelete;
  final Function onEdit;

  TimeSlotCard({required this.timeSlot, required this.onDelete, required this.onEdit});

  @override
  _TimeSlotCardState createState() => _TimeSlotCardState();
}

class _TimeSlotCardState extends State<TimeSlotCard> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = widget.timeSlot.courses; // Initialize with the courses from the time slot
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text('Time Slot: ${widget.timeSlot.startTime} - ${widget.timeSlot.endTime}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => widget.onDelete(),
            ),
          ),
          ..._courses.map((course) => _buildCourseCard(course)).toList(), // Build course cards
          ElevatedButton(
            onPressed: _addCourse,
            child: Text('Add Course'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card( // Optional: Wrapping in a Card for better visual appearance
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(course.courseName), // Use courseName from the model
        subtitle: Text('ID: ${course.courseId}, Section: ${course.sId}'), // Display course ID and section
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Makes sure buttons don't take extra space
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editCourse(course),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDeleteCourse(course), // Redirect to confirmation or delete page
            ),
          ],
        ),
        onTap: () => _viewCourseDetails(course), // Redirect to course details page on tap
      ),
    );
  }

// Method to view course details
  void _viewCourseDetails(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(course: course), // Replace with your details screen
      ),
    );
  }

// Method to confirm deletion of the course
  void _confirmDeleteCourse(Course course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Course'),
          content: Text('Are you sure you want to delete ${course.courseName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement deletion logic here
                Navigator.of(context).pop(); // Close dialog
                // Optionally navigate to a delete confirmation page
                // Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteConfirmationPage(course: course)));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  void _addCourse() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController sectionController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    final TextEditingController totalStudentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: sectionController,
                decoration: InputDecoration(labelText: 'Section'),
              ),
              TextField(
                controller: roomController,
                decoration: InputDecoration(labelText: 'Room'),
              ),
              TextField(
                controller: totalStudentsController,
                decoration: InputDecoration(labelText: 'Total Students'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    sectionController.text.isNotEmpty &&
                    roomController.text.isNotEmpty &&
                    totalStudentsController.text.isNotEmpty) {
                  Course newCourse = Course(
                    id: _courses.length + 1, // Assign a new ID, or handle as per your logic
                    uniqueId: DateTime.now().toString(), // Generate unique ID
                    sId: sectionController.text,
                    courseId: DateTime.now().millisecondsSinceEpoch.toString(), // Use timestamp as course ID
                    timeslotId: widget.timeSlot.uniqueId, // Assuming timeSlot has an ID
                    courseName: nameController.text,
                  );

                  setState(() {
                    _courses.add(newCourse);
                    widget.timeSlot.courses.add(newCourse); // Add to time slot's courses as well
                  });

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editCourse(Course course) {
    final TextEditingController nameController = TextEditingController(text: course.courseName);
    final TextEditingController sectionController = TextEditingController(text: course.sId);
    final TextEditingController roomController = TextEditingController(); // Assuming room is not part of Course model, update as necessary
    final TextEditingController totalStudentsController = TextEditingController(); // Update as needed

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: sectionController,
                decoration: InputDecoration(labelText: 'Section'),
              ),
              TextField(
                controller: roomController,
                decoration: InputDecoration(labelText: 'Room'),
              ),
              TextField(
                controller: totalStudentsController,
                decoration: InputDecoration(labelText: 'Total Students'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    sectionController.text.isNotEmpty &&
                    roomController.text.isNotEmpty &&
                    totalStudentsController.text.isNotEmpty) {
                  setState(() {
                    course.courseName = nameController.text;
                    course.sId = sectionController.text; // Update to correct property
                    // Add logic for updating room and totalStudents if applicable

                    // Notify parent about the edit
                    widget.onEdit(course);
                  });

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
