class SecAssigned {
  int? _id;
  int? _secId;
  String? _uniqueId;
  int? _clsId;
  String? _stdId;
  String? _sectionId;
  String? _sessionId;
  String? _classId;
  String? _sId;
  String? _date;
  int? _aYear;
  int? _aStatus;
  String? _feeTk;
  String? _secAId;
  int? _aYearId;
  int? _syncStatus;
  String? _syncKey;

  SecAssigned({
    int? id,
    int? secId,
    String? uniqueId,
    int? clsId,
    String? stdId,
    String? sectionId,
    String? sessionId,
    String? classId,
    String? sId,
    String? date,
    int? aYear,
    int? aStatus,
    String? feeTk,
    String? secAId,
    int? aYearId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _secId = secId,
        _uniqueId = uniqueId,
        _clsId = clsId,
        _stdId = stdId,
        _sectionId = sectionId,
        _sessionId = sessionId,
        _classId = classId,
        _sId = sId,
        _date = date,
        _aYear = aYear,
        _aStatus = aStatus,
        _feeTk = feeTk,
        _secAId = secAId,
        _aYearId = aYearId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  int? get secId => _secId;
  String? get uniqueId => _uniqueId;
  int? get clsId => _clsId;
  String? get stdId => _stdId;
  String? get sectionId => _sectionId;
  String? get sessionId => _sessionId;
  String? get classId => _classId;
  String? get sId => _sId;
  String? get date => _date;
  int? get aYear => _aYear;
  int? get aStatus => _aStatus;
  String? get feeTk => _feeTk;
  String? get secAId => _secAId;
  int? get aYearId => _aYearId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set secId(int? secId) => _secId = secId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set clsId(int? clsId) => _clsId = clsId;
  set stdId(String? stdId) => _stdId = stdId;
  set sectionId(String? sectionId) => _sectionId = sectionId;
  set sessionId(String? sessionId) => _sessionId = sessionId;
  set classId(String? classId) => _classId = classId;
  set sId(String? sId) => _sId = sId;
  set date(String? date) => _date = date;
  set aYear(int? aYear) => _aYear = aYear;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set feeTk(String? feeTk) => _feeTk = feeTk;
  set secAId(String? secAId) => _secAId = secAId;
  set aYearId(int? aYearId) => _aYearId = aYearId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'secId': _secId,
      'uniqueId': _uniqueId,
      'clsId': _clsId,
      'stdId': _stdId,
      'sectionId': _sectionId,
      'sessionId': _sessionId,
      'classId': _classId,
      'sId': _sId,
      'date': _date,
      'aYear': _aYear,
      'aStatus': _aStatus,
      'feeTk': _feeTk,
      'secAId': _secAId,
      'aYearId': _aYearId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static SecAssigned fromMap(Map<String, dynamic> map) {
    return SecAssigned(
      id: map['id'],
      secId: map['secId'],
      uniqueId: map['uniqueId'],
      clsId: map['clsId'],
      stdId: map['stdId'],
      sectionId: map['sectionId'],
      sessionId: map['sessionId'],
      classId: map['classId'],
      sId: map['sId'],
      date: map['date'],
      aYear: map['aYear'],
      aStatus: map['aStatus'],
      feeTk: map['feeTk'],
      secAId: map['secAId'],
      aYearId: map['aYearId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
