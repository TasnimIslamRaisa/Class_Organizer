import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../models/class_model.dart';
import '../../../utility/confirmationDialog.dart';

class SlidableClassItem extends StatelessWidget {
  final Class classItem;
  final void Function(Class) onDeleteClass;

  const SlidableClassItem({
    Key? key,
    required this.classItem,
    required this.onDeleteClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Slidable(
      key: Key(classItem.courseCode),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialog(context, classItem, onDeleteClass,'delete');
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialog(context, classItem, onDeleteClass,'edit');
            },
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // Colors.blueGrey[50]   Colors.blueGrey[600]
            color:isLightMode ? Colors.blueGrey[50] : Colors.blueGrey[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.book,
                  color: Colors.blueAccent,
                  size: 40,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classItem.courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      classItem.courseCode,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Teacher Initial: ${classItem.teacherInitial}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Section: ${classItem.section}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          classItem.startTime,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.class_,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          classItem.roomNumber,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
