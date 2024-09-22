import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
import '../../../models/class_model.dart';

Future<void> showConfirmationDialog(BuildContext context, ScheduleItem classItem, void Function(ScheduleItem) onDeleteClass,String command) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to "${command}" the class "${classItem.subName}"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              onDeleteClass(classItem);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showConfirmationDialogV1(BuildContext context, ScheduleItem classItem, void Function(ScheduleItem) onDeleteClass,String command) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Action'),
        content: Text('Are you sure you want to "${command}" the Schedule "${classItem.subName}"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("${command ?? ""}"),
            onPressed: () {
              onDeleteClass(classItem);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
