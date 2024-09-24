import 'dart:convert';

class Section {
  int id;
  String uniqueId;
  String sId;
  String sectionId;
  String courseId;
  String sectionName;
  String roomName;
  int totalStudents;

  Section({required this.id, required this.uniqueId, required this.sId, required this.sectionId, required this.courseId, required this.sectionName, required this.roomName, required this.totalStudents});

  // Getters and Setters
  int get getId => id;
  set setId(int newId) => id = newId;

  String get getUniqueId => uniqueId;
  set setUniqueId(String newUniqueId) => uniqueId = newUniqueId;

  String get getSId => sId;
  set setSId(String newSId) => sId = newSId;

  String get getSectionId => sectionId;
  set setSectionId(String newSectionId) => sectionId = newSectionId;

  String get getCourseId => courseId;
  set setCourseId(String newCourseId) => courseId = newCourseId;

  String get getSectionName => sectionName;
  set setSectionName(String newSectionName) => sectionName = newSectionName;

  String get getRoomName => roomName;
  set setRoomName(String newRoomName) => roomName = newRoomName;

  int get getTotalStudents => totalStudents;
  set setTotalStudents(int newTotalStudents) => totalStudents = newTotalStudents;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
      'sId': sId,
      'sectionId': sectionId,
      'courseId': courseId,
      'sectionName': sectionName,
      'roomName': roomName,
      'totalStudents': totalStudents,
    };
  }

  // Convert from Map
  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      sectionId: map['sectionId'],
      courseId: map['courseId'],
      sectionName: map['sectionName'],
      roomName: map['roomName'],
      totalStudents: map['totalStudents'],
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Convert from JSON
  factory Section.fromJson(String source) => Section.fromMap(json.decode(source));
}
