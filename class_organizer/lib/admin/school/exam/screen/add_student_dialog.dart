import 'package:flutter/material.dart';

class AddStudentDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Student IDs'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter Student IDs (comma-separated)'),
        keyboardType: TextInputType.text,
        maxLines: 100, // Limit to a single line for compactness
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_controller.text); // Return the entered IDs
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
