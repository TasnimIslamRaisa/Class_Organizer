import 'package:flutter/material.dart';
import '../screen/view_exam_screen.dart';
import '../model/time_slot.dart';

class ExamCard extends StatefulWidget {
  final String examId;
  final String examDate;
  final List<TimeSlot> timeSlots; // Accept timeSlots

  ExamCard({
    required this.examId,
    required this.examDate,
    required this.timeSlots,
  });

  @override
  _ExamCardState createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('Exam: ${widget.examId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${widget.examDate}'),
            // Show time slot summary below the exam date
            ...widget.timeSlots.map((timeSlot) => Text(
              'Time: ${timeSlot.startTime} - ${timeSlot.endTime}',
            )),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewExamScreen(
                examId: widget.examId,
                timeSlots: widget.timeSlots,
              ),
            ),
          );
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import '../screen/view_exam_screen.dart';
// import '../model/time_slot.dart';
//
// class ExamCard extends StatelessWidget {
//   final String examId;
//   final String examDate;
//   final List<TimeSlot> timeSlots; // Accept timeSlots
//
//   ExamCard({
//     required this.examId,
//     required this.examDate,
//     required this.timeSlots,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       child: ListTile(
//         title: Text('Exam: $examId'),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Date: $examDate'),
//             // Show time slot summary below the exam date
//             ...timeSlots.map((timeSlot) => Text(
//               'Time: ${timeSlot.startTime} - ${timeSlot.endTime}',
//             )),
//           ],
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ViewExamScreen(
//                 examId: examId,
//                 timeSlots: timeSlots,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
//
// import '../screen/view_exam_screen.dart';
//
// class ExamCard extends StatelessWidget {
//   final String examId;
//   final String examDate;
//
//   ExamCard({required this.examId, required this.examDate});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       child: ListTile(
//         title: Text('Exam: $examId'),
//         subtitle: Text('Date: $examDate'),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ViewExamScreen(examId: examId)),
//           );
//         },
//       ),
//     );
//   }
// }
