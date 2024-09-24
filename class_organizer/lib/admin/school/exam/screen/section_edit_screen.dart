import 'package:flutter/material.dart';

import '../model/section.dart';


class SectionEditScreen extends StatefulWidget {
  final Section section;

  SectionEditScreen({required this.section});

  @override
  _SectionEditScreenState createState() => _SectionEditScreenState();
}

class _SectionEditScreenState extends State<SectionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String sectionName;
  late String roomName;
  late int totalStudents;

  @override
  void initState() {
    super.initState();
    // Initialize fields with existing section details
    sectionName = widget.section.sectionName;
    roomName = widget.section.roomName;
    totalStudents = widget.section.totalStudents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Section'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: sectionName,
                decoration: InputDecoration(labelText: 'Section Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a section name';
                  }
                  return null;
                },
                onChanged: (value) {
                  sectionName = value;
                },
              ),
              TextFormField(
                initialValue: roomName,
                decoration: InputDecoration(labelText: 'Room Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a room name';
                  }
                  return null;
                },
                onChanged: (value) {
                  roomName = value;
                },
              ),
              TextFormField(
                initialValue: totalStudents.toString(),
                decoration: InputDecoration(labelText: 'Total Students'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total number of students';
                  }
                  return null;
                },
                onChanged: (value) {
                  totalStudents = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create updated section
                    Section updatedSection = Section(
                      id: widget.section.id, // Keep the same ID
                      uniqueId: widget.section.uniqueId, // Keep the same unique ID
                      sId: widget.section.sId, // Keep the same sId
                      sectionId: widget.section.sectionId, // Keep the same sectionId
                      courseId: widget.section.courseId, // Keep the same courseId
                      sectionName: sectionName,
                      roomName: roomName,
                      totalStudents: totalStudents,
                    );

                    Navigator.pop(context, updatedSection); // Return the updated section
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
