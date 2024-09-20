class Semester {
  int _id;
  int _semName; // Semester Name or Number
  String _uniqueId;
  String _sId; // Student ID or similar
  String _departmentId; // Department ID
  int _numSec; // Number of sections
  int _numCourses; // Number of courses
  String _uId; // User ID

  Semester({
    required int id,
    required int semName, // Add _semName to the constructor
    required String uniqueId,
    required String sId,
    required String departmentId,
    required int numSec,
    required int numCourses,
    required String uId,
  })  : _id = id,
        _semName = semName, // Initialize _semName
        _uniqueId = uniqueId,
        _sId = sId,
        _departmentId = departmentId,
        _numSec = numSec,
        _numCourses = numCourses,
        _uId = uId;

  // Getters
  int get id => _id;
  int get semName => _semName; // Getter for semName
  String get uniqueId => _uniqueId;
  String get sId => _sId;
  String get departmentId => _departmentId;
  int get numSec => _numSec;
  int get numCourses => _numCourses;
  String get uId => _uId;

  // Setters
  set id(int value) => _id = value;
  set semName(int value) => _semName = value; // Setter for semName
  set uniqueId(String value) => _uniqueId = value;
  set sId(String value) => _sId = value;
  set departmentId(String value) => _departmentId = value;
  set numSec(int value) => _numSec = value;
  set numCourses(int value) => _numCourses = value;
  set uId(String value) => _uId = value;

  // Factory method for creating a Semester from a map (e.g., from a database)
  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      id: map['id'],
      semName: map['semName'], // Map _semName
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      departmentId: map['departmentId'],
      numSec: map['numSec'],
      numCourses: map['numCourses'],
      uId: map['uId'],
    );
  }

  // Method to convert a Semester to a map (e.g., for saving to a database)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'semName': _semName, // Include _semName
      'uniqueId': _uniqueId,
      'sId': _sId,
      'departmentId': _departmentId,
      'numSec': _numSec,
      'numCourses': _numCourses,
      'uId': _uId,
    };
  }

  // Method to convert a Semester to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'semName': _semName, // Include _semName in toJson
      'uniqueId': _uniqueId,
      'sId': _sId,
      'departmentId': _departmentId,
      'numSec': _numSec,
      'numCourses': _numCourses,
      'uId': _uId,
    };
  }

  // Factory method to create a Semester from JSON
  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      semName: json['semName'], // Include _semName in fromJson
      uniqueId: json['uniqueId'],
      sId: json['sId'],
      departmentId: json['departmentId'],
      numSec: json['numSec'],
      numCourses: json['numCourses'],
      uId: json['uId'],
    );
  }
}
