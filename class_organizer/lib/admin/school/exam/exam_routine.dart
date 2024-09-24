import 'package:class_organizer/admin/school/exam/screen/add_edit_exam_screen.dart';
import 'package:class_organizer/admin/school/exam/widget/exam_card.dart';
import 'package:flutter/material.dart';

import 'model/course.dart';
import 'model/time_slot.dart';

class ExamRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample time slots for the exams with real Course objects
    List<TimeSlot> exam1TimeSlots = [
      TimeSlot(
        id: 1,
        uniqueId: 'exam1_slot1',
        sId: 'section1',
        timeslotId: 'ts1',
        examId: 'Exam1',
        startTime: '09:00',
        endTime: '11:00',
        courses: [
          Course(
            id: 101,
            uniqueId: 'course1',
            sId: 'section1',
            courseId: 'c1',
            timeslotId: 'ts1',
            courseName: 'Math',
          ),
          Course(
            id: 102,
            uniqueId: 'course2',
            sId: 'section1',
            courseId: 'c2',
            timeslotId: 'ts1',
            courseName: 'Physics',
          ),
        ],
      ),
      TimeSlot(
        id: 2,
        uniqueId: 'exam1_slot2',
        sId: 'section2',
        timeslotId: 'ts2',
        examId: 'Exam1',
        startTime: '12:00',
        endTime: '14:00',
        courses: [
          Course(
            id: 103,
            uniqueId: 'course3',
            sId: 'section2',
            courseId: 'c3',
            timeslotId: 'ts2',
            courseName: 'Biology',
          ),
          Course(
            id: 104,
            uniqueId: 'course4',
            sId: 'section2',
            courseId: 'c4',
            timeslotId: 'ts2',
            courseName: 'Chemistry',
          ),
        ],
      ),
    ];

    List<TimeSlot> exam2TimeSlots = [
      TimeSlot(
        id: 3,
        uniqueId: 'exam2_slot1',
        sId: 'section1',
        timeslotId: 'ts3',
        examId: 'Exam2',
        startTime: '10:00',
        endTime: '12:00',
        courses: [
          Course(
            id: 105,
            uniqueId: 'course5',
            sId: 'section1',
            courseId: 'c5',
            timeslotId: 'ts3',
            courseName: 'History',
          ),
          Course(
            id: 106,
            uniqueId: 'course6',
            sId: 'section1',
            courseId: 'c6',
            timeslotId: 'ts3',
            courseName: 'Geography',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Exam Schedules')),
      body: ListView(
        children: [
          ExamCard(
            examId: 'Exam1',
            examDate: '2024-09-30',
            timeSlots: exam1TimeSlots, // Pass the time slots for Exam1
          ),
          ExamCard(
            examId: 'Exam2',
            examDate: '2024-10-01',
            timeSlots: exam2TimeSlots, // Pass the time slots for Exam2
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddEditExamScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}




// import 'package:class_organizer/admin/school/exam/screen/add_edit_exam_screen.dart';
// import 'package:class_organizer/admin/school/exam/widget/exam_card.dart';
// import 'package:flutter/material.dart';
//
// class ExamRoutine extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exam Schedules')),
//       body: ListView(
//         children: [
//           // Dynamic list of Exam Cards
//           ExamCard(examId: 'Exam1', examDate: '2024-09-30'),
//           ExamCard(examId: 'Exam2', examDate: '2024-10-01'),
//           // More Exam Cards...
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditExamScreen()));
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
