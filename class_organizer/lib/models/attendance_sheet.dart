class AttendanceSheet {
  int? _id;
  String? _sId;
  String? _uniqueId;
  String? _stdId;
  int? _subId;
  String? _subjectId;
  int? _secId;
  String? _sectionId;
  String? _clsId;
  String? _teacherId;
  String? _date;
  String? _time;
  int? _status;
  String? _attendance;
  int? _syncStatus;
  String? _syncKey;

  AttendanceSheet({
    int? id,
    String? sId,
    String? uniqueId,
    String? stdId,
    int? subId,
    String? subjectId,
    int? secId,
    String? sectionId,
    String? clsId,
    String? teacherId,
    String? date,
    String? time,
    int? status,
    String? attendance,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _sId = sId,
        _uniqueId = uniqueId,
        _stdId = stdId,
        _subId = subId,
        _subjectId = subjectId,
        _secId = secId,
        _sectionId = sectionId,
        _clsId = clsId,
        _teacherId = teacherId,
        _date = date,
        _time = time,
        _status = status,
        _attendance = attendance,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get sId => _sId;
  String? get uniqueId => _uniqueId;
  String? get stdId => _stdId;
  int? get subId => _subId;
  String? get subjectId => _subjectId;
  int? get secId => _secId;
  String? get sectionId => _sectionId;
  String? get clsId => _clsId;
  String? get teacherId => _teacherId;
  String? get date => _date;
  String? get time => _time;
  int? get status => _status;
  String? get attendance => _attendance;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set sId(String? sId) => _sId = sId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set stdId(String? stdId) => _stdId = stdId;
  set subId(int? subId) => _subId = subId;
  set subjectId(String? subjectId) => _subjectId = subjectId;
  set secId(int? secId) => _secId = secId;
  set sectionId(String? sectionId) => _sectionId = sectionId;
  set clsId(String? clsId) => _clsId = clsId;
  set teacherId(String? teacherId) => _teacherId = teacherId;
  set date(String? date) => _date = date;
  set time(String? time) => _time = time;
  set status(int? status) => _status = status;
  set attendance(String? attendance) => _attendance = attendance;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sId': _sId,
      'uniqueId': _uniqueId,
      'stdId': _stdId,
      'subId': _subId,
      'subjectId': _subjectId,
      'secId': _secId,
      'sectionId': _sectionId,
      'clsId': _clsId,
      'teacherId': _teacherId,
      'date': _date,
      'time': _time,
      'status': _status,
      'attendance': _attendance,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static AttendanceSheet fromMap(Map<String, dynamic> map) {
    return AttendanceSheet(
      id: map['id'],
      sId: map['sId'],
      uniqueId: map['uniqueId'],
      stdId: map['stdId'],
      subId: map['subId'],
      subjectId: map['subjectId'],
      secId: map['secId'],
      sectionId: map['sectionId'],
      clsId: map['clsId'],
      teacherId: map['teacherId'],
      date: map['date'],
      time: map['time'],
      status: map['status'],
      attendance: map['attendance'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
