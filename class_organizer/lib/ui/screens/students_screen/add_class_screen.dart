import 'package:flutter/material.dart';
import '../../../models/class_model.dart';

class AddClassBottomSheet extends StatefulWidget {
  final void Function(Class) onAddClass;

  AddClassBottomSheet({super.key, required this.onAddClass});

  @override
  State<AddClassBottomSheet> createState() => _AddClassBottomSheetState();
}

class _AddClassBottomSheetState extends State<AddClassBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _teacherController = TextEditingController();
  final _sectionController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endingtimeController = TextEditingController();
  final _classroomController = TextEditingController();

  String selectedDay = 'Monday'; // Default selected day

  // Time picker for better time input
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context); // Format the selected time
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return; // If validation fails, don't submit
    }

    final newClass = Class(
      courseName: _courseNameController.text,
      courseCode: _courseCodeController.text,
      teacherInitial: _teacherController.text,
      section: _sectionController.text,
      startTime: _starttimeController.text,
      endTime: _endingtimeController.text,
      roomNumber: _classroomController.text,
      day: selectedDay,
    );

    widget.onAddClass(newClass);

    // Clear input fields after submission
    _courseNameController.clear();
    _courseCodeController.clear();
    _teacherController.clear();
    _sectionController.clear();
    _starttimeController.clear();
    _endingtimeController.clear();
    _classroomController.clear();

    Navigator.pop(context); // Close the bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Your Class", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedDay,
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                    .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _courseNameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _courseCodeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(labelText: 'Teacher Initial'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the teacher\'s initials';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(labelText: 'Section'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the section';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _starttimeController,
                readOnly: true, // To prevent manual editing
                onTap: () => _selectTime(context, _starttimeController),
                decoration: const InputDecoration(labelText: 'Start Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the start time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _endingtimeController,
                readOnly: true,
                onTap: () => _selectTime(context, _endingtimeController),
                decoration: const InputDecoration(labelText: 'Ending Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the end time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _classroomController,
                decoration: const InputDecoration(labelText: 'Classroom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the classroom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Add Class'),
              ),
            ],
          ),
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
