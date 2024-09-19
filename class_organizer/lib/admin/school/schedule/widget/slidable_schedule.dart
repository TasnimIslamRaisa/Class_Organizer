import 'package:class_organizer/admin/school/schedule/schedule_card.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../utility/confirmationDialog.dart'; // Ensure this utility file includes necessary functions

class SlidableSchedule extends StatelessWidget {
  final ScheduleItem classItem;
  final void Function(ScheduleItem) onDeleteClass;
  final void Function(ScheduleItem) onEditClass;
  final void Function(ScheduleItem) onDuplicateClass;

  const SlidableSchedule({
    Key? key,
    required this.classItem,
    required this.onDeleteClass,
    required this.onEditClass,
    required this.onDuplicateClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Slidable(
      key: Key(classItem.subCode ?? ''),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialogV1(context, classItem, onDeleteClass, 'delete');
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialogV1(context, classItem, onEditClass, 'edit');
            },
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialogV1(context, classItem, onDuplicateClass, 'duplicate');
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.copy,
            label: 'Duplicate',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ScheduleCard(schedule: classItem),
        // child: Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: isLightMode ? Colors.blueGrey[50] : Colors.blueGrey[600],
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(right: 16),
        //         child: Icon(
        //           Icons.book,
        //           color: Colors.blueAccent,
        //           size: 40,
        //         ),
        //       ),
        //       Expanded(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               classItem.subName ?? "US",
        //               style: const TextStyle(
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             const SizedBox(height: 4),
        //             Text(
        //               classItem.subCode ?? "U",
        //               style: const TextStyle(
        //                 fontSize: 14,
        //                 color: Colors.black54,
        //               ),
        //             ),
        //             const SizedBox(height: 8),
        //             Row(
        //               children: [
        //                 Text(
        //                   'Teacher Initial: ${classItem.tName}',
        //                   style: const TextStyle(fontSize: 14),
        //                 ),
        //                 const SizedBox(width: 10),
        //                 Text(
        //                   'Section: ${classItem.section}',
        //                   style: const TextStyle(fontSize: 14),
        //                 ),
        //               ],
        //             ),
        //             const SizedBox(height: 8),
        //             Row(
        //               children: [
        //                 const Icon(
        //                   Icons.access_time,
        //                   size: 16,
        //                   color: Colors.grey,
        //                 ),
        //                 const SizedBox(width: 4),
        //                 Text(
        //                   classItem.startTime ?? "",
        //                   style: const TextStyle(fontSize: 14),
        //                 ),
        //                 const SizedBox(width: 10),
        //                 const Icon(
        //                   Icons.class_,
        //                   size: 16,
        //                   color: Colors.grey,
        //                 ),
        //                 const SizedBox(width: 4),
        //                 Text(
        //                   classItem.room ?? "",
        //                   style: const TextStyle(fontSize: 14),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
