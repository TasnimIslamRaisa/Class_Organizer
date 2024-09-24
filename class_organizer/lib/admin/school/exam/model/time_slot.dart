import 'dart:convert';
import 'course.dart'; // Make sure to import your Course model

class TimeSlot {
  int id;
  String uniqueId;
  String sId;
  String timeslotId;
  String examId;
  String startTime;
  String endTime;
  List<Course> courses; // Add this field

  TimeSlot({
    required this.id,
    required this.uniqueId,
    required this.sId,
    required this.timeslotId,
    required this.examId,
    required this.startTime,
    required this.endTime,
    List<Course>? courses, // Optional parameter for courses
  }) : courses = courses ?? []; // Initialize with an empty list if null

  // Getters and Setters
  int get getId => id;
  set setId(int newId) => id = newId;

  String get getUniqueId => uniqueId;
  set setUniqueId(String newUniqueId) => uniqueId = newUniqueId;

  String get getSId => sId;
  set setSId(String newSId) => sId = newSId;

  String get getTimeslotId => timeslotId;
  set setTimeslotId(String newTimeslotId) => timeslotId = newTimeslotId;

  String get getExamId => examId;
  set setExamId(String newExamId) => examId = newExamId;

  String get getStartTime => startTime;
  set setStartTime(String newStartTime) => startTime = newStartTime;

  String get getEndTime => endTime;
  set setEndTime(String newEndTime) => endTime = newEndTime;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
      'sId': sId,
      'timeslotId': timeslotId,
      'examId': examId,
      'startTime': startTime,
      'endTime': endTime,
      'courses': courses.map((course) => course.toMap()).toList(), // Add courses to map
    };
  }

  // Convert from Map
  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      id: map['id'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      timeslotId: map['timeslotId'],
      examId: map['examId'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      courses: List<Course>.from(map['courses']?.map((x) => Course.fromMap(x)) ?? []), // Initialize courses
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Convert from JSON
  factory TimeSlot.fromJson(String source) => TimeSlot.fromMap(json.decode(source));
}
