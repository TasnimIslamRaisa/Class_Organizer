import 'package:flutter/material.dart';

import '../models/subject.dart';

class AutocompleteSubjectExample extends StatefulWidget {
  @override
  _AutocompleteSubjectExampleState createState() => _AutocompleteSubjectExampleState();
}

class _AutocompleteSubjectExampleState extends State<AutocompleteSubjectExample> {
  // List of Subjects
  final List<Subject> _subjects = [
    Subject(subName: 'Mathematics', subCode: 'MATH101'),
    Subject(subName: 'Physics', subCode: 'PHYS101'),
    Subject(subName: 'Chemistry', subCode: 'CHEM101'),
    Subject(subName: 'Biology', subCode: 'BIO101'),
    Subject(subName: 'Computer Science', subCode: 'CS101'),
  ];

  // Controllers for the text fields
  final TextEditingController _subNameController = TextEditingController();
  final TextEditingController _subCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autocomplete with Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Autocomplete for subName
            Autocomplete<Subject>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Subject>.empty();
                }
                return _subjects.where((Subject subject) {
                  return subject.subName!.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Subject option) => option.subName!,
              onSelected: (Subject selection) {
                print('Selected Subject: ${selection.subName}');
                _subNameController.text = selection.subName!;
                _subCodeController.text = selection.subCode!; // Update subCode automatically
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                _subNameController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Subject Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Autocomplete for subCode
            Autocomplete<Subject>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Subject>.empty();
                }
                return _subjects.where((Subject subject) {
                  return subject.subCode!.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Subject option) => option.subCode!,
              onSelected: (Subject selection) {
                print('Selected Subject Code: ${selection.subCode}');
                _subCodeController.text = selection.subCode!;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                _subCodeController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Subject Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
