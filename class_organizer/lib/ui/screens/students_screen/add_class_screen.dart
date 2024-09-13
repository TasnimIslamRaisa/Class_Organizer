import 'package:flutter/material.dart';
import '../../../models/class_model.dart';

class AddClassBottomSheet extends StatefulWidget {
  final void Function(Class) onAddClass;

  AddClassBottomSheet({super.key, required this.onAddClass});

  @override
  State<AddClassBottomSheet> createState() => _AddClassBottomSheetState();
}

class _AddClassBottomSheetState extends State<AddClassBottomSheet> {

  final _courseNameController = TextEditingController();

  final _courseCodeController = TextEditingController();

  final _teacherController = TextEditingController();

  final _sectionController = TextEditingController();

  final _starttimeController = TextEditingController();

  final _endingtimeController = TextEditingController();

  final _classroomController = TextEditingController();

  String selectedDay = 'Monday';  // Default selected day

  void _submitForm(BuildContext context) {
    if (_courseNameController.text.isEmpty ||
        _courseCodeController.text.isEmpty ||
        _teacherController.text.isEmpty ||
        _sectionController.text.isEmpty ||
        _starttimeController.text.isEmpty ||
        _endingtimeController.text.isEmpty ||
        _classroomController.text.isEmpty) {
      // Show an error message or prevent submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Create and add the new class
    final newClass = Class(
      courseName: _courseNameController.text,
      courseCode: _courseCodeController.text,
      teacherInitial: _teacherController.text,
      section: _sectionController.text,
      startTime: _starttimeController.text,
      endTime: _endingtimeController.text,
      roomNumber: _classroomController.text,
      day: selectedDay,  // Use the selected day
    );

    widget.onAddClass(newClass);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

  }


  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Your Class", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),


      DropdownButton<String>(
        value: selectedDay,
        items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
            .map((day) => DropdownMenuItem<String>(
          value: day,
          child: Text(day),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedDay = value!;
          });
        },
      ),
        const SizedBox(height: 8),
            TextField(
              controller: _courseNameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _courseCodeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _teacherController,
              decoration: const InputDecoration(labelText: 'Teacher Initial'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _starttimeController,
              decoration: const InputDecoration(labelText: 'Start Time'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _endingtimeController,
              decoration: const InputDecoration(labelText: 'Ending Time'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _classroomController,
              decoration: const InputDecoration(labelText: 'Classroom'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: const Text('Add Class'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _teacherController.dispose();
    _sectionController.dispose();
    _starttimeController.dispose();
    _endingtimeController.dispose();
    _classroomController.dispose();
    super.dispose();
  }
}
