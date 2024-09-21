class Room {
  int? _id;
  String? _userid;
  String? _campusId;
  String? _roomName;
  String? _instructorId;
  String? _roomCode;
  String? _sid;
  int? _status;
  int? _theoryLab;
  int? _syncStatus;
  String? _syncKey;

  Room({
    int? id,
    String? userid,
    String? campusId,
    String? roomName,
    String? instructorId,
    String? roomCode,
    String? sid,
    int? status,
    int? theoryLab,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _userid = userid,
        _campusId = campusId,
        _roomName = roomName,
        _instructorId = instructorId,
        _roomCode = roomCode,
        _sid = sid,
        _status = status,
        _theoryLab = theoryLab,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get userid => _userid;
  String? get campusId => _campusId;
  String? get roomName => _roomName;
  String? get instructorId => _instructorId;
  String? get roomCode => _roomCode;
  String? get sid => _sid;
  int? get status => _status;
  int? get theoryLab => _theoryLab;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set userid(String? userid) => _userid = userid;
  set campusId(String? campusId) => _campusId = campusId;
  set roomName(String? roomName) => _roomName = roomName;
  set instructorId(String? instructorId) => _instructorId = instructorId;
  set roomCode(String? roomCode) => _roomCode = roomCode;
  set sid(String? sid) => _sid = sid;
  set status(int? status) => _status = status;
  set theoryLab(int? theoryLab) => _theoryLab = theoryLab;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'userid': _userid,
      'campus_id': _campusId,
      'room_name': _roomName,
      'instructor_id': _instructorId,
      'room_code': _roomCode,
      'sId': _sid,
      'status': _status,
      'theory_lab': _theoryLab,
      'sync_status': _syncStatus,
      'sync_key': _syncKey,
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      userid: map['userid'],
      campusId: map['campus_id'],
      roomName: map['room_name'],
      instructorId: map['instructor_id'],
      roomCode: map['room_code'],
      sid: map['sId'],
      status: map['status'],
      theoryLab: map['theory_lab'],
      syncStatus: map['sync_status'],
      syncKey: map['sync_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userid': _userid,
      'campusId': _campusId,
      'roomName': _roomName,
      'instructorId': _instructorId,
      'roomCode': _roomCode,
      'sId': _sid,
      'status': _status,
      'theoryLab': _theoryLab,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      userid: json['userid'],
      campusId: json['campusId'],
      roomName: json['roomName'],
      instructorId: json['instructorId'],
      roomCode: json['roomCode'],
      sid: json['sId'],
      status: json['status'],
      theoryLab: json['theoryLab'],
      syncStatus: json['syncStatus'],
      syncKey: json['syncKey'],
    );
  }

  @override
  String toString() {
    return _roomName ?? '';
  }

}
