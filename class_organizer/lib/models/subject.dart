class Subject {
  int? _id;
  String? _subName;
  String? _uniqueId;
  String? _credit;
  String? _subCode;
  String? _subId;
  int? _depId;
  int? _typeId;
  String? _subFee;
  int? _status;
  String? _sId;
  String? _semester;
  int? _program;
  String? _departmentId;
  int? _syncStatus;
  String? _syncKey;

  Subject({
    int? id,
    String? subName,
    String? uniqueId,
    String? credit,
    String? subCode,
    String? subId,
    int? depId,
    int? typeId,
    String? subFee,
    int? status,
    String? sId,
    String? semester,
    int? program,
    String? departmentId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _subName = subName,
        _uniqueId = uniqueId,
        _credit = credit,
        _subCode = subCode,
        _subId = subId,
        _depId = depId,
        _typeId = typeId,
        _subFee = subFee,
        _status = status,
        _sId = sId,
        _semester = semester,
        _program = program,
        _departmentId = departmentId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get subName => _subName;
  String? get uniqueId => _uniqueId;
  String? get credit => _credit;
  String? get subCode => _subCode;
  String? get subId => _subId;
  int? get depId => _depId;
  int? get typeId => _typeId;
  String? get subFee => _subFee;
  int? get status => _status;
  String? get sId => _sId;
  String? get semester => _semester;
  int? get program => _program;
  String? get departmentId => _departmentId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set subName(String? subName) => _subName = subName;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set credit(String? credit) => _credit = credit;
  set subCode(String? subCode) => _subCode = subCode;
  set subId(String? subId) => _subId = subId;
  set depId(int? depId) => _depId = depId;
  set typeId(int? typeId) => _typeId = typeId;
  set subFee(String? subFee) => _subFee = subFee;
  set status(int? status) => _status = status;
  set sId(String? sId) => _sId = sId;
  set semester(String? semester) => _semester = semester;
  set program(int? program) => _program = program;
  set departmentId(String? departmentId) => _departmentId = departmentId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'subName': _subName,
      'uniqueId': _uniqueId,
      'credit': _credit,
      'subCode': _subCode,
      'subId': _subId,
      'depId': _depId,
      'typeId': _typeId,
      'subFee': _subFee,
      'status': _status,
      'sId': _sId,
      'semester': _semester,
      'program': _program,
      'departmentId': _departmentId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static Subject fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      subName: map['subName'],
      uniqueId: map['uniqueId'],
      credit: map['credit'],
      subCode: map['subCode'],
      subId: map['subId'],
      depId: map['depId'],
      typeId: map['typeId'],
      subFee: map['subFee'],
      status: map['status'],
      sId: map['sId'],
      semester: map['semester'],
      program: map['program'],
      departmentId: map['departmentId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
