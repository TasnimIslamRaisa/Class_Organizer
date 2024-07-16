class SubAssigned {
  int? _id;
  int? _subId;
  String? _subjectId;
  String? _uniqueId;
  int? _secId;
  String? _sectionId;
  int? _clsId;
  String? _classId;
  String? _sId;
  String? _stdId;
  String? _feeTk;
  int? _aStatus;
  String? _subAId;
  int? _syncStatus;
  String? _syncKey;

  SubAssigned({
    int? id,
    int? subId,
    String? subjectId,
    String? uniqueId,
    int? secId,
    String? sectionId,
    int? clsId,
    String? classId,
    String? sId,
    String? stdId,
    String? feeTk,
    int? aStatus,
    String? subAId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _subId = subId,
        _subjectId = subjectId,
        _uniqueId = uniqueId,
        _secId = secId,
        _sectionId = sectionId,
        _clsId = clsId,
        _classId = classId,
        _sId = sId,
        _stdId = stdId,
        _feeTk = feeTk,
        _aStatus = aStatus,
        _subAId = subAId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  int? get subId => _subId;
  String? get subjectId => _subjectId;
  String? get uniqueId => _uniqueId;
  int? get secId => _secId;
  String? get sectionId => _sectionId;
  int? get clsId => _clsId;
  String? get classId => _classId;
  String? get sId => _sId;
  String? get stdId => _stdId;
  String? get feeTk => _feeTk;
  int? get aStatus => _aStatus;
  String? get subAId => _subAId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set subId(int? subId) => _subId = subId;
  set subjectId(String? subjectId) => _subjectId = subjectId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set secId(int? secId) => _secId = secId;
  set sectionId(String? sectionId) => _sectionId = sectionId;
  set clsId(int? clsId) => _clsId = clsId;
  set classId(String? classId) => _classId = classId;
  set sId(String? sId) => _sId = sId;
  set stdId(String? stdId) => _stdId = stdId;
  set feeTk(String? feeTk) => _feeTk = feeTk;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set subAId(String? subAId) => _subAId = subAId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'subId': _subId,
      'subjectId': _subjectId,
      'uniqueId': _uniqueId,
      'secId': _secId,
      'sectionId': _sectionId,
      'clsId': _clsId,
      'classId': _classId,
      'sId': _sId,
      'stdId': _stdId,
      'feeTk': _feeTk,
      'aStatus': _aStatus,
      'subAId': _subAId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static SubAssigned fromMap(Map<String, dynamic> map) {
    return SubAssigned(
      id: map['id'],
      subId: map['subId'],
      subjectId: map['subjectId'],
      uniqueId: map['uniqueId'],
      secId: map['secId'],
      sectionId: map['sectionId'],
      clsId: map['clsId'],
      classId: map['classId'],
      sId: map['sId'],
      stdId: map['stdId'],
      feeTk: map['feeTk'],
      aStatus: map['aStatus'],
      subAId: map['subAId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
