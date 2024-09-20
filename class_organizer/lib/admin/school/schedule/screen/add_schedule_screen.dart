import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';

class AddScheduleScreen extends StatefulWidget {
  final void Function(ScheduleItem) onAddClass;

  const AddScheduleScreen({Key? key, required this.onAddClass}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subNameController = TextEditingController();
  final _subCodeController = TextEditingController();
  final _teacherController = TextEditingController();
  final _sectionController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _roomController = TextEditingController();

  String selectedDay = 'Everyday';

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

    final newClass = ScheduleItem(
      subName: _subNameController.text,
      subCode: _subCodeController.text,
      tName: _teacherController.text,
      section: _sectionController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      room: _roomController.text,
      day: selectedDay,
    );

    widget.onAddClass(newClass);

    // Clear input fields after submission
    _subNameController.clear();
    _subCodeController.clear();
    _teacherController.clear();
    _sectionController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    _roomController.clear();

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
              Text("Add New Schedule", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedDay,
                items: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Everyday']
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
                controller: _subNameController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subCodeController,
                decoration: const InputDecoration(
                  labelText: 'Subject Code',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                  labelText: 'Teacher Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the teacher\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  prefixIcon: Icon(Icons.class_),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the section';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _startTimeController,
                readOnly: true, // To prevent manual editing
                onTap: () => _selectTime(context, _startTimeController),
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the start time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                onTap: () => _selectTime(context, _endTimeController),
                decoration: const InputDecoration(
                  labelText: 'End Time',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the end time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Room',
                  prefixIcon: Icon(Icons.room),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room';
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
    _subNameController.dispose();
    _subCodeController.dispose();
    _teacherController.dispose();
    _sectionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _roomController.dispose();
    super.dispose();
  }
}
