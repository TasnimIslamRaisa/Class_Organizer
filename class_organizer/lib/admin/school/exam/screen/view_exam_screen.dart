import 'package:flutter/material.dart';
import '../model/time_slot.dart';
import '../widget/time_slot_card.dart';

class ViewExamScreen extends StatefulWidget {
  final String examId;
  final List<TimeSlot> timeSlots;

  ViewExamScreen({required this.examId, required this.timeSlots});

  @override
  _ViewExamScreenState createState() => _ViewExamScreenState();
}

class _ViewExamScreenState extends State<ViewExamScreen> {
  late List<TimeSlot> _timeSlots;

  @override
  void initState() {
    super.initState();
    _timeSlots = widget.timeSlots; // Initialize time slots with the passed data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addTimeSlot(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ListTile(
            title: Text('Exam ID: ${widget.examId}', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 10),
          ..._timeSlots.map((timeSlot) {
            return TimeSlotCard(
              timeSlot: timeSlot,
              onDelete: () => _deleteTimeSlot(timeSlot),
              onEdit: (updatedTimeSlot) {
                _editTimeSlot(updatedTimeSlot);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  // Add a new Time Slot
  void _addTimeSlot(BuildContext context) {
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController endTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                if (startTimeController.text.isNotEmpty &&
                    endTimeController.text.isNotEmpty) {
                  TimeSlot newTimeSlot = TimeSlot(
                    id: DateTime.now().millisecondsSinceEpoch,
                    uniqueId: DateTime.now().toIso8601String(),
                    sId: 'sample_sId',
                    timeslotId: 'sample_timeslotId',
                    examId: widget.examId,
                    startTime: startTimeController.text,
                    endTime: endTimeController.text,
                    courses: [], // Initially empty, can add courses later
                  );

                  setState(() {
                    _timeSlots.add(newTimeSlot); // Add new time slot to the list
                  });

                  print('Added Time Slot: ${newTimeSlot.startTime} - ${newTimeSlot.endTime}');
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

  // Handle Time Slot Deletion
  void _deleteTimeSlot(TimeSlot timeSlot) {
    setState(() {
      _timeSlots.remove(timeSlot); // Remove the time slot from the list
    });
    print('Deleted Time Slot: ${timeSlot.startTime} - ${timeSlot.endTime}');
  }

  // Handle Time Slot Editing
  void _editTimeSlot(TimeSlot updatedTimeSlot) {
    setState(() {
      final index = _timeSlots.indexWhere((t) => t.id == updatedTimeSlot.id);
      if (index != -1) {
        _timeSlots[index] = updatedTimeSlot; // Update the time slot in the list
      }
    });
    print('Edited Time Slot: ${updatedTimeSlot.startTime} - ${updatedTimeSlot.endTime}');
  }
}



// import 'package:flutter/material.dart';
// import '../model/time_slot.dart';
// import '../widget/time_slot_card.dart';
//
// class ViewExamScreen extends StatelessWidget {
//   final String examId;
//   final List<TimeSlot> timeSlots;
//
//   ViewExamScreen({required this.examId, required this.timeSlots});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Exam Details'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               // Logic to add a new time slot
//               _addTimeSlot(context);
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(10),
//         children: [
//           ListTile(
//             title: Text('Exam ID: $examId', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           SizedBox(height: 10),
//           ...timeSlots.map((timeSlot) {
//             return TimeSlotCard(
//               timeSlot: timeSlot,
//               onDelete: () => _deleteTimeSlot(timeSlot), onEdit: null,
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   void _addTimeSlot(BuildContext context) {
//     final TextEditingController startTimeController = TextEditingController();
//     final TextEditingController endTimeController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Time Slot'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: startTimeController,
//                 decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
//                 keyboardType: TextInputType.datetime,
//               ),
//               TextField(
//                 controller: endTimeController,
//                 decoration: InputDecoration(labelText: 'End Time (HH:MM)'),
//                 keyboardType: TextInputType.datetime,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Validate inputs
//                 if (startTimeController.text.isNotEmpty && endTimeController.text.isNotEmpty) {
//                   TimeSlot newTimeSlot = TimeSlot(
//                     id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
//                     uniqueId: DateTime.now().toIso8601String(), // Use current timestamp as unique ID
//                     sId: 'sample_sId', // Replace with actual sId as necessary
//                     timeslotId: 'sample_timeslotId', // Replace with actual timeslotId as necessary
//                     examId: 'sample_examId', // Replace with actual examId as necessary
//                     startTime: startTimeController.text,
//                     endTime: endTimeController.text,
//                     courses: [],
//                   );
//
//                   // Add the new TimeSlot to your state management (replace with your implementation)
//                   // For now, we'll just print to the console.
//                   print('Added Time Slot: ${newTimeSlot.startTime} - ${newTimeSlot.endTime}');
//
//                   // Close the dialog
//                   Navigator.of(context).pop();
//                 } else {
//                   // Show a warning if fields are empty
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Please fill in all fields.')),
//                   );
//                 }
//               },
//               child: Text('Add'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   void _deleteTimeSlot(TimeSlot timeSlot) {
//     // Logic to remove the time slot
//     print('Deleting Time Slot: ${timeSlot.startTime} - ${timeSlot.endTime}');
//     // Implement state management to remove the time slot from the list
//   }
// }