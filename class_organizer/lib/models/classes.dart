class Classes {
  int? _id;
  String? _clsId;
  int? _maxSec;
  String? _uniqueId;
  String? _sId;
  String? _clsName;
  String? _clsCode;
  String? _aYear;
  int? _aStatus;
  int? _aYearId;
  String? _sessionId;
  int? _depId;
  int? _program;
  String? _departmentId;
  int? _syncStatus;
  String? _syncKey;

  Classes({
    int? id,
    String? clsId,
    int? maxSec,
    String? uniqueId,
    String? sId,
    String? clsName,
    String? clsCode,
    String? aYear,
    int? aStatus,
    int? aYearId,
    String? sessionId,
    int? depId,
    int? program,
    String? departmentId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _clsId = clsId,
        _maxSec = maxSec,
        _uniqueId = uniqueId,
        _sId = sId,
        _clsName = clsName,
        _clsCode = clsCode,
        _aYear = aYear,
        _aStatus = aStatus,
        _aYearId = aYearId,
        _sessionId = sessionId,
        _depId = depId,
        _program = program,
        _departmentId = departmentId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get clsId => _clsId;
  int? get maxSec => _maxSec;
  String? get uniqueId => _uniqueId;
  String? get sId => _sId;
  String? get clsName => _clsName;
  String? get clsCode => _clsCode;
  String? get aYear => _aYear;
  int? get aStatus => _aStatus;
  int? get aYearId => _aYearId;
  String? get sessionId => _sessionId;
  int? get depId => _depId;
  int? get program => _program;
  String? get departmentId => _departmentId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set clsId(String? clsId) => _clsId = clsId;
  set maxSec(int? maxSec) => _maxSec = maxSec;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set sId(String? sId) => _sId = sId;
  set clsName(String? clsName) => _clsName = clsName;
  set clsCode(String? clsCode) => _clsCode = clsCode;
  set aYear(String? aYear) => _aYear = aYear;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set aYearId(int? aYearId) => _aYearId = aYearId;
  set sessionId(String? sessionId) => _sessionId = sessionId;
  set depId(int? depId) => _depId = depId;
  set program(int? program) => _program = program;
  set departmentId(String? departmentId) => _departmentId = departmentId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  // Convert Classes object to a map of data
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'clsId': _clsId,
      'maxSec': _maxSec,
      'uniqueId': _uniqueId,
      'sId': _sId,
      'clsName': _clsName,
      'clsCode': _clsCode,
      'aYear': _aYear,
      'aStatus': _aStatus,
      'aYearId': _aYearId,
      'sessionId': _sessionId,
      'depId': _depId,
      'program': _program,
      'departmentId': _departmentId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  // Create a Classes object from a map of data
  static Classes fromMap(Map<String, dynamic> map) {
    return Classes(
      id: map['id'],
      clsId: map['clsId'],
      maxSec: map['maxSec'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      clsName: map['clsName'],
      clsCode: map['clsCode'],
      aYear: map['aYear'],
      aStatus: map['aStatus'],
      aYearId: map['aYearId'],
      sessionId: map['sessionId'],
      depId: map['depId'],
      program: map['program'],
      departmentId: map['departmentId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
