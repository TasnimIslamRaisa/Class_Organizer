class Class {
  final String courseName;
  final String courseCode;
  final String teacherInitial;
  final String section;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String day;

  Class({
    required this.courseName,
    required this.courseCode,
    required this.teacherInitial,
    required this.section,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.day,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'courseCode': courseCode,
      'teacherInitial': teacherInitial,
      'section': section,
      'startTime': startTime,
      'endTime': endTime,
      'roomNumber': roomNumber,
      'day': day,
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      courseName: map['courseName'],
      courseCode: map['courseCode'],
      teacherInitial: map['teacherInitial'],
      section: map['section'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      roomNumber: map['roomNumber'],
      day: map['day'],
    );
  }
}
