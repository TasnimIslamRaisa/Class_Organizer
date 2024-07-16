class SubOnSec {
  int? _id;
  String? _subAId;
  String? _uniqueId;
  String? _sId;
  int? _subId;
  String? _subjectId;
  String? _sectionId;
  int? _secId;
  int? _aStatus;
  String? _subFee;
  String? _secFee;
  int? _syncStatus;
  String? _syncKey;

  SubOnSec({
    int? id,
    String? subAId,
    String? uniqueId,
    String? sId,
    int? subId,
    String? subjectId,
    String? sectionId,
    int? secId,
    int? aStatus,
    String? subFee,
    String? secFee,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _subAId = subAId,
        _uniqueId = uniqueId,
        _sId = sId,
        _subId = subId,
        _subjectId = subjectId,
        _sectionId = sectionId,
        _secId = secId,
        _aStatus = aStatus,
        _subFee = subFee,
        _secFee = secFee,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get subAId => _subAId;
  String? get uniqueId => _uniqueId;
  String? get sId => _sId;
  int? get subId => _subId;
  String? get subjectId => _subjectId;
  String? get sectionId => _sectionId;
  int? get secId => _secId;
  int? get aStatus => _aStatus;
  String? get subFee => _subFee;
  String? get secFee => _secFee;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set subAId(String? subAId) => _subAId = subAId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set sId(String? sId) => _sId = sId;
  set subId(int? subId) => _subId = subId;
  set subjectId(String? subjectId) => _subjectId = subjectId;
  set sectionId(String? sectionId) => _sectionId = sectionId;
  set secId(int? secId) => _secId = secId;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set subFee(String? subFee) => _subFee = subFee;
  set secFee(String? secFee) => _secFee = secFee;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'subAId': _subAId,
      'uniqueId': _uniqueId,
      'sId': _sId,
      'subId': _subId,
      'subjectId': _subjectId,
      'sectionId': _sectionId,
      'secId': _secId,
      'aStatus': _aStatus,
      'subFee': _subFee,
      'secFee': _secFee,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static SubOnSec fromMap(Map<String, dynamic> map) {
    return SubOnSec(
      id: map['id'],
      subAId: map['subAId'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      subId: map['subId'],
      subjectId: map['subjectId'],
      sectionId: map['sectionId'],
      secId: map['secId'],
      aStatus: map['aStatus'],
      subFee: map['subFee'],
      secFee: map['secFee'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
