class ScheduleItem {
  int? _id;
  String? _uniqueId;
  String? _sId;
  String? _stdId;
  String? _tId;
  String? _tempCode;
  String? _tempNum;
  String? _subName;
  String? _subCode;
  String? _tId2;  // To differentiate from _tId, given t_id is a field in the Java class
  String? _tName;
  String? _room;
  String? _campus;
  String? _section;
  String? _startTime;
  String? _endTime;
  String? _day;
  String? _key;
  String? _syncKey;
  int? _min;
  int? _syncStatus;
  DateTime? _dateTime;

  ScheduleItem({
    int? id,
    String? uniqueId,
    String? sId,
    String? stdId,
    String? tId,
    String? tempCode,
    String? tempNum,
    String? subName,
    String? subCode,
    String? tId2,
    String? tName,
    String? room,
    String? campus,
    String? section,
    String? startTime,
    String? endTime,
    String? day,
    String? key,
    String? syncKey,
    int? min,
    int? syncStatus,
    DateTime? dateTime,
  })  : _id = id,
        _uniqueId = uniqueId,
        _sId = sId,
        _stdId = stdId,
        _tId = tId,
        _tempCode = tempCode,
        _tempNum = tempNum,
        _subName = subName,
        _subCode = subCode,
        _tId2 = tId2,
        _tName = tName,
        _room = room,
        _campus = campus,
        _section = section,
        _startTime = startTime,
        _endTime = endTime,
        _day = day,
        _key = key,
        _syncKey = syncKey,
        _min = min,
        _syncStatus = syncStatus,
        _dateTime = dateTime;

  // Getters
  int? get id => _id;
  String? get uniqueId => _uniqueId;
  String? get sId => _sId;
  String? get stdId => _stdId;
  String? get tId => _tId;
  String? get tempCode => _tempCode;
  String? get tempNum => _tempNum;
  String? get subName => _subName;
  String? get subCode => _subCode;
  String? get tId2 => _tId2;
  String? get tName => _tName;
  String? get room => _room;
  String? get campus => _campus;
  String? get section => _section;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get day => _day;
  String? get key => _key;
  String? get syncKey => _syncKey;
  int? get min => _min;
  int? get syncStatus => _syncStatus;
  DateTime? get dateTime => _dateTime;

  // Setters
  set id(int? id) => _id = id;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set sId(String? sId) => _sId = sId;
  set stdId(String? stdId) => _stdId = stdId;
  set tId(String? tId) => _tId = tId;
  set tempCode(String? tempCode) => _tempCode = tempCode;
  set tempNum(String? tempNum) => _tempNum = tempNum;
  set subName(String? subName) => _subName = subName;
  set subCode(String? subCode) => _subCode = subCode;
  set tId2(String? tId2) => _tId2 = tId2;
  set tName(String? tName) => _tName = tName;
  set room(String? room) => _room = room;
  set campus(String? campus) => _campus = campus;
  set section(String? section) => _section = section;
  set startTime(String? startTime) => _startTime = startTime;
  set endTime(String? endTime) => _endTime = endTime;
  set day(String? day) => _day = day;
  set key(String? key) => _key = key;
  set syncKey(String? syncKey) => _syncKey = syncKey;
  set min(int? min) => _min = min;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set dateTime(DateTime? dateTime) => _dateTime = dateTime;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'uniqueId': _uniqueId,
      'sId': _sId,
      'stdId': _stdId,
      'tId': _tId,
      'temp_code': _tempCode,
      'temp_num': _tempNum,
      'sub_name': _subName,
      'sub_code': _subCode,
      't_id': _tId2,
      't_name': _tName,
      'room': _room,
      'campus': _campus,
      'section': _section,
      'start_time': _startTime,
      'end_time': _endTime,
      'day': _day,
      'key': _key,
      'sync_key': _syncKey,
      'min': _min,
      'sync_status': _syncStatus,
      'dateTime': _dateTime?.toIso8601String(),
    };
  }

  static ScheduleItem fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      id: map['id'],
      uniqueId: map['uniqueId'],
      sId: map['sId'],
      stdId: map['stdId'],
      tId: map['tId'],
      tempCode: map['temp_code'],
      tempNum: map['temp_num'],
      subName: map['sub_name'],
      subCode: map['sub_code'],
      tId2: map['t_id'],
      tName: map['t_name'],
      room: map['room'],
      campus: map['campus'],
      section: map['section'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      day: map['day'],
      key: map['key'],
      syncKey: map['sync_key'],
      min: map['min'],
      syncStatus: map['sync_status'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
