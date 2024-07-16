class Section {
  int? _id;
  String? _sId;
  String? _uniqueId;
  String? _subId;
  String? _sessionId;
  String? _clsId;
  String? _secName;
  String? _secCode;
  String? _secFee;
  int? _secNumStd;
  String? _secTeaId;
  int? _aStatus;
  int? _syncStatus;
  String? _syncKey;

  Section({
    int? id,
    String? sId,
    String? uniqueId,
    String? subId,
    String? sessionId,
    String? clsId,
    String? secName,
    String? secCode,
    String? secFee,
    int? secNumStd,
    String? secTeaId,
    int? aStatus,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _sId = sId,
        _uniqueId = uniqueId,
        _subId = subId,
        _sessionId = sessionId,
        _clsId = clsId,
        _secName = secName,
        _secCode = secCode,
        _secFee = secFee,
        _secNumStd = secNumStd,
        _secTeaId = secTeaId,
        _aStatus = aStatus,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get sId => _sId;
  String? get uniqueId => _uniqueId;
  String? get subId => _subId;
  String? get sessionId => _sessionId;
  String? get clsId => _clsId;
  String? get secName => _secName;
  String? get secCode => _secCode;
  String? get secFee => _secFee;
  int? get secNumStd => _secNumStd;
  String? get secTeaId => _secTeaId;
  int? get aStatus => _aStatus;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set sId(String? sId) => _sId = sId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set subId(String? subId) => _subId = subId;
  set sessionId(String? sessionId) => _sessionId = sessionId;
  set clsId(String? clsId) => _clsId = clsId;
  set secName(String? secName) => _secName = secName;
  set secCode(String? secCode) => _secCode = secCode;
  set secFee(String? secFee) => _secFee = secFee;
  set secNumStd(int? secNumStd) => _secNumStd = secNumStd;
  set secTeaId(String? secTeaId) => _secTeaId = secTeaId;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sId': _sId,
      'uniqueId': _uniqueId,
      'subId': _subId,
      'sessionId': _sessionId,
      'clsId': _clsId,
      'secName': _secName,
      'secCode': _secCode,
      'secFee': _secFee,
      'secNumStd': _secNumStd,
      'secTeaId': _secTeaId,
      'aStatus': _aStatus,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static Section fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      sId: map['sId'],
      uniqueId: map['uniqueId'],
      subId: map['subId'],
      sessionId: map['sessionId'],
      clsId: map['clsId'],
      secName: map['secName'],
      secCode: map['secCode'],
      secFee: map['secFee'],
      secNumStd: map['secNumStd'],
      secTeaId: map['secTeaId'],
      aStatus: map['aStatus'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
