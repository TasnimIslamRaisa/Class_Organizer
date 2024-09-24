import 'dart:convert';

class StudentSection {
  int id;
  String uniqueId;
  String sId;
  String studentId;
  String sectionId;
  String courseId;       // Added courseId property
  String timeSlotId;     // Added timeSlotId property
  String studentUniqueId;

  StudentSection({
    required this.id,
    required this.uniqueId,
    required this.sId,
    required this.studentId,
    required this.sectionId,
    required this.courseId,       // Include courseId in the constructor
    required this.timeSlotId,     // Include timeSlotId in the constructor
    required this.studentUniqueId,
  });

  // Getters and Setters
  int get getId => id;
  set setId(int newId) => id = newId;

  String get getUniqueId => uniqueId;
  set setUniqueId(String newUniqueId) => uniqueId = newUniqueId;

  String get getSId => sId;
  set setSId(String newSId) => sId = newSId;

  String get getStudentId => studentId;
  set setStudentId(String newStudentId) => studentId = newStudentId;

  String get getSectionId => sectionId;
  set setSectionId(String newSectionId) => sectionId = newSectionId;

  String get getCourseId => courseId;          // Getter for courseId
  set setCourseId(String newCourseId) => courseId = newCourseId; // Setter for courseId

  String get getTimeSlotId => timeSlotId;      // Getter for timeSlotId
  set setTimeSlotId(String newTimeSlotId) => timeSlotId = newTimeSlotId; // Setter for timeSlotId

  String get getStudentUniqueId => studentUniqueId;
  set setStudentUniqueId(String newStudentUniqueId) => studentUniqueId = newStudentUniqueId;

  // Convert a StudentSection instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
      'sId': sId,
      'studentId': studentId,
      'sectionId': sectionId,
      'courseId': courseId,          // Include courseId in the map
      'timeSlotId': timeSlotId,      // Include timeSlotId in the map
      'studentUniqueId': studentUniqueId,
    };
  }

  // Create a StudentSection instance from a Map
  factory StudentSection.fromMap(Map<String, dynamic> map) {
    return StudentSection(
      id: map['id'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      studentId: map['studentId'],
      sectionId: map['sectionId'],
      courseId: map['courseId'],          // Include courseId when creating from map
      timeSlotId: map['timeSlotId'],      // Include timeSlotId when creating from map
      studentUniqueId: map['studentUniqueId'],
    );
  }

  // Convert a StudentSection instance to a JSON string
  String toJson() => json.encode(toMap());

  // Create a StudentSection instance from a JSON string
  factory StudentSection.fromJson(String source) => StudentSection.fromMap(json.decode(source));
}
