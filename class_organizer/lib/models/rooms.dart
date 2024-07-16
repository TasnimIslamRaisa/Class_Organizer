class Room {
  int? _id;
  String? _roomCode;
  String? _sid;
  String? _userid;
  int? _campusId;
  int? _theoryLab;
  String? _instructorId;
  int? _status;
  int? _syncStatus;
  String? _syncKey;
  String? _roomName;

  Room({
    int? id,
    String? roomCode,
    String? sid,
    String? userid,
    int? campusId,
    int? theoryLab,
    String? instructorId,
    int? status,
    int? syncStatus,
    String? syncKey,
    String? roomName,
  })  : _id = id,
        _roomCode = roomCode,
        _sid = sid,
        _userid = userid,
        _campusId = campusId,
        _theoryLab = theoryLab,
        _instructorId = instructorId,
        _status = status,
        _syncStatus = syncStatus,
        _syncKey = syncKey,
        _roomName = roomName;

  // Getters
  int? get id => _id;
  String? get roomCode => _roomCode;
  String? get sid => _sid;
  String? get userid => _userid;
  int? get campusId => _campusId;
  int? get theoryLab => _theoryLab;
  String? get instructorId => _instructorId;
  int? get status => _status;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;
  String? get roomName => _roomName;

  // Setters
  set id(int? id) => _id = id;
  set roomCode(String? roomCode) => _roomCode = roomCode;
  set sid(String? sid) => _sid = sid;
  set userid(String? userid) => _userid = userid;
  set campusId(int? campusId) => _campusId = campusId;
  set theoryLab(int? theoryLab) => _theoryLab = theoryLab;
  set instructorId(String? instructorId) => _instructorId = instructorId;
  set status(int? status) => _status = status;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;
  set roomName(String? roomName) => _roomName = roomName;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'room_code': _roomCode,
      'sid': _sid,
      'userid': _userid,
      'campus_id': _campusId,
      'theory_lab': _theoryLab,
      'instructorid': _instructorId,
      'status': _status,
      'sync_status': _syncStatus,
      'sync_key': _syncKey,
      'room_name': _roomName,
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      roomCode: map['room_code'],
      sid: map['sid'],
      userid: map['userid'],
      campusId: map['campus_id'],
      theoryLab: map['theory_lab'],
      instructorId: map['instructorid'],
      status: map['status'],
      syncStatus: map['sync_status'],
      syncKey: map['sync_key'],
      roomName: map['room_name'],
    );
  }
}
