import 'package:flutter/material.dart';
import '../model/time_slot.dart';
import '../widget/time_slot_card.dart';

class AddEditExamScreen extends StatefulWidget {
  @override
  _AddEditExamScreenState createState() => _AddEditExamScreenState();
}

class _AddEditExamScreenState extends State<AddEditExamScreen> {
  DateTime _selectedDate = DateTime.now();
  List<TimeSlot> _timeSlots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit Exam')),
      body: Column(
        children: [
          ListTile(
            title: Text('Exam Date'),
            subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                return TimeSlotCard(
                  timeSlot: _timeSlots[index],
                  onDelete: () => _deleteTimeSlot(index),
                  onEdit: () => _editTimeSlot(index), // Callback for editing
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _addTimeSlot(),
            child: Text('Add Time Slot'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save exam details logic
          // e.g. send _selectedDate and _timeSlots to a backend or database
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void _addTimeSlot() {
    String uniqueId = 'unique_${DateTime.now().millisecondsSinceEpoch}';
    String timeslotId = 'timeslot_${_timeSlots.length + 1}';
    String examId = 'exam_${_timeSlots.length + 1}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController startTimeController = TextEditingController();
        final TextEditingController endTimeController = TextEditingController();

        return AlertDialog(
          title: Text('Add Time Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: endTimeController,
                decoration: InputDecoration(labelText: 'End Time (HH:MM)'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validate inputs
                if (startTimeController.text.isNotEmpty && endTimeController.text.isNotEmpty) {
                  setState(() {
                    _timeSlots.add(TimeSlot(
                      id: _timeSlots.length + 1,
                      uniqueId: uniqueId,
                      sId: 'sId_example',
                      timeslotId: timeslotId,
                      examId: examId,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                      courses: [],
                    ));
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

  void _editTimeSlot(int index) {
    final timeSlot = _timeSlots[index];
    final TextEditingController startTimeController = TextEditingController(text: timeSlot.startTime);
    final TextEditingController endTimeController = TextEditingController(text: timeSlot.endTime);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Time Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: endTimeController,
                decoration: InputDecoration(labelText: 'End Time (HH:MM)'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (startTimeController.text.isNotEmpty && endTimeController.text.isNotEmpty) {
                  setState(() {
                    _timeSlots[index].startTime = startTimeController.text;
                    _timeSlots[index].endTime = endTimeController.text;
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

  void _deleteTimeSlot(int index) {
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}





// import 'package:flutter/material.dart';
//
// class AddEditExamScreen extends StatefulWidget {
//   @override
//   _AddEditExamScreenState createState() => _AddEditExamScreenState();
// }
//
// class _AddEditExamScreenState extends State<AddEditExamScreen> {
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add/Edit Exam')),
//       body: Column(
//         children: [
//           ListTile(
//             title: Text('Exam Date'),
//             subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
//             trailing: Icon(Icons.calendar_today),
//             onTap: () => _selectDate(context),
//           ),
//           // Add TimeSlot widgets dynamically
//           ElevatedButton(
//             onPressed: () {
//               // Logic to add a new time slot
//             },
//             child: Text('Add Time Slot'),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Save exam details logic
//         },
//         child: Icon(Icons.save),
//       ),
//     );
//   }
//
//   _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
// }
