class Campus {
  int? _id;
  String? _sid;
  String? _uniqueid;
  String? _userid;
  String? _campusName;
  String? _campusCode;
  String? _syncKey;
  int? _syncStatus;

  Campus({
    int? id,
    String? sid,
    String? uniqueid,
    String? userid,
    String? campusName,
    String? campusCode,
    String? syncKey,
    int? syncStatus,
  })  : _id = id,
        _sid = sid,
        _uniqueid = uniqueid,
        _userid = userid,
        _campusName = campusName,
        _campusCode = campusCode,
        _syncKey = syncKey,
        _syncStatus = syncStatus;

  // Getters
  int? get id => _id;
  String? get sid => _sid;
  String? get uniqueid => _uniqueid;
  String? get userid => _userid;
  String? get campusName => _campusName;
  String? get campusCode => _campusCode;
  String? get syncKey => _syncKey;
  int? get syncStatus => _syncStatus;

  // Setters
  set id(int? id) => _id = id;
  set sid(String? sid) => _sid = sid;
  set uniqueid(String? uniqueid) => _uniqueid = uniqueid;
  set userid(String? userid) => _userid = userid;
  set campusName(String? campusName) => _campusName = campusName;
  set campusCode(String? campusCode) => _campusCode = campusCode;
  set syncKey(String? syncKey) => _syncKey = syncKey;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sid': _sid,
      'uniqueid': _uniqueid,
      'userid': _userid,
      'campus_name': _campusName,
      'campus_code': _campusCode,
      'sync_key': _syncKey,
      'sync_status': _syncStatus,
    };
  }

  static Campus fromMap(Map<String, dynamic> map) {
    return Campus(
      id: map['id'],
      sid: map['sid'],
      uniqueid: map['uniqueid'],
      userid: map['userid'],
      campusName: map['campus_name'],
      campusCode: map['campus_code'],
      syncKey: map['sync_key'],
      syncStatus: map['sync_status'],
    );
  }
}
