class CourseStructure {
  int? id;
  String? subName;
  String? subCode;
  String? section;
  String? semester;
  String? uniqueId;
  String? userId;
  String? sId;

  CourseStructure({
    this.id,
    this.subName,
    this.subCode,
    this.section,
    this.semester,
    this.uniqueId,
    this.userId,
    this.sId,
  });

  // Getters and Setters
  int? get getId => id;
  set setId(int? value) {
    id = value;
  }

  String? get getSubName => subName;
  set setSubName(String? value) {
    subName = value;
  }

  String? get getSubCode => subCode;
  set setSubCode(String? value) {
    subCode = value;
  }

  String? get getSection => section;
  set setSection(String? value) {
    section = value;
  }

  String? get getSemester => semester;
  set setSemester(String? value) {
    semester = value;
  }

  String? get getUniqueId => uniqueId;
  set setUniqueId(String? value) {
    uniqueId = value;
  }

  String? get getUserId => userId;
  set setUserId(String? value) {
    userId = value;
  }

  String? get getSId => sId;
  set setSId(String? value) {
    sId = value;
  }

  // Convert a CourseStructure object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subName': subName,
      'subCode': subCode,
      'section': section,
      'semester': semester,
      'uniqueId': uniqueId,
      'userId': userId,
      'sId': sId,
    };
  }

  // Create a CourseStructure object from a map
  factory CourseStructure.fromMap(Map<String, dynamic> map) {
    return CourseStructure(
      id: map['id'],
      subName: map['subName'],
      subCode: map['subCode'],
      section: map['section'],
      semester: map['semester'],
      uniqueId: map['uniqueId'],
      userId: map['userId'],
      sId: map['sId'],
    );
  }

  // Convert a CourseStructure object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subName': subName,
      'subCode': subCode,
      'section': section,
      'semester': semester,
      'uniqueId': uniqueId,
      'userId': userId,
      'sId': sId,
    };
  }

  // Create a CourseStructure object from a JSON object
  factory CourseStructure.fromJson(Map<String, dynamic> json) {
    return CourseStructure(
      id: json['id'],
      subName: json['subName'],
      subCode: json['subCode'],
      section: json['section'],
      semester: json['semester'],
      uniqueId: json['uniqueId'],
      userId: json['userId'],
      sId: json['sId'],
    );
  }
}