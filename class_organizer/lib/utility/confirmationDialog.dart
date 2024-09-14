import 'package:flutter/material.dart';
import '../../../models/class_model.dart';

Future<void> showConfirmationDialog(BuildContext context, Class classItem, void Function(Class) onDeleteClass,String command) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to "${command}" the class "${classItem.courseName}"?'),
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
