import 'dart:convert';

class Course {
  int id;
  String uniqueId;
  String sId;
  String courseId;
  String timeslotId;
  String courseName;

  Course({required this.id, required this.uniqueId, required this.sId, required this.courseId, required this.timeslotId, required this.courseName});

  // Getters and Setters
  int get getId => id;
  set setId(int newId) => id = newId;

  String get getUniqueId => uniqueId;
  set setUniqueId(String newUniqueId) => uniqueId = newUniqueId;

  String get getSId => sId;
  set setSId(String newSId) => sId = newSId;

  String get getCourseId => courseId;
  set setCourseId(String newCourseId) => courseId = newCourseId;

  String get getTimeslotId => timeslotId;
  set setTimeslotId(String newTimeslotId) => timeslotId = newTimeslotId;

  String get getCourseName => courseName;
  set setCourseName(String newCourseName) => courseName = newCourseName;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
      'sId': sId,
      'courseId': courseId,
      'timeslotId': timeslotId,
      'courseName': courseName,
    };
  }

  // Convert from Map
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      courseId: map['courseId'],
      timeslotId: map['timeslotId'],
      courseName: map['courseName'],
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Convert from JSON
  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));
}
