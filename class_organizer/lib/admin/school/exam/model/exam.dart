import 'dart:convert';

class Exam {
  int id;
  String uniqueId;
  String sId;
  String examId;
  String examDate;

  Exam({required this.id, required this.uniqueId, required this.sId, required this.examId, required this.examDate});

  // Getters and Setters
  int get getId => id;
  set setId(int newId) => id = newId;

  String get getUniqueId => uniqueId;
  set setUniqueId(String newUniqueId) => uniqueId = newUniqueId;

  String get getSId => sId;
  set setSId(String newSId) => sId = newSId;

  String get getExamId => examId;
  set setExamId(String newExamId) => examId = newExamId;

  String get getExamDate => examDate;
  set setExamDate(String newExamDate) => examDate = newExamDate;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
      'sId': sId,
      'examId': examId,
      'examDate': examDate,
    };
  }

  // Convert from Map
  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      examId: map['examId'],
      examDate: map['examDate'],
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Convert from JSON
  factory Exam.fromJson(String source) => Exam.fromMap(json.decode(source));
}
