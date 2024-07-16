class Calendar {
  int? _id;
  String? _taskName;
  String? _uniqueId;
  String? _scheduleId;
  String? _sId;
  String? _stdId;
  String? _uId;
  String? _userId;
  int? _aStatus;
  String? _taskDetails;
  String? _taskLocation;
  String? _taskId;
  String? _taskCode;
  String? _calendar;
  String? _time;
  String? _day;
  String? _url;
  String? _link;
  String? _dateTime;
  int? _done;
  int? _syncStatus;
  String? _syncKey;

  Calendar({
    int? id,
    String? taskName,
    String? uniqueId,
    String? scheduleId,
    String? sId,
    String? stdId,
    String? uId,
    String? userId,
    int? aStatus,
    String? taskDetails,
    String? taskLocation,
    String? taskId,
    String? taskCode,
    String? calendar,
    String? time,
    String? day,
    String? url,
    String? link,
    String? dateTime,
    int? done,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _taskName = taskName,
        _uniqueId = uniqueId,
        _scheduleId = scheduleId,
        _sId = sId,
        _stdId = stdId,
        _uId = uId,
        _userId = userId,
        _aStatus = aStatus,
        _taskDetails = taskDetails,
        _taskLocation = taskLocation,
        _taskId = taskId,
        _taskCode = taskCode,
        _calendar = calendar,
        _time = time,
        _day = day,
        _url = url,
        _link = link,
        _dateTime = dateTime,
        _done = done,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get taskName => _taskName;
  String? get uniqueId => _uniqueId;
  String? get scheduleId => _scheduleId;
  String? get sId => _sId;
  String? get stdId => _stdId;
  String? get uId => _uId;
  String? get userId => _userId;
  int? get aStatus => _aStatus;
  String? get taskDetails => _taskDetails;
  String? get taskLocation => _taskLocation;
  String? get taskId => _taskId;
  String? get taskCode => _taskCode;
  String? get calendar => _calendar;
  String? get time => _time;
  String? get day => _day;
  String? get url => _url;
  String? get link => _link;
  String? get dateTime => _dateTime;
  int? get done => _done;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set taskName(String? taskName) => _taskName = taskName;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set scheduleId(String? scheduleId) => _scheduleId = scheduleId;
  set sId(String? sId) => _sId = sId;
  set stdId(String? stdId) => _stdId = stdId;
  set uId(String? uId) => _uId = uId;
  set userId(String? userId) => _userId = userId;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set taskDetails(String? taskDetails) => _taskDetails = taskDetails;
  set taskLocation(String? taskLocation) => _taskLocation = taskLocation;
  set taskId(String? taskId) => _taskId = taskId;
  set taskCode(String? taskCode) => _taskCode = taskCode;
  set calendar(String? calendar) => _calendar = calendar;
  set time(String? time) => _time = time;
  set day(String? day) => _day = day;
  set url(String? url) => _url = url;
  set link(String? link) => _link = link;
  set dateTime(String? dateTime) => _dateTime = dateTime;
  set done(int? done) => _done = done;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  // Convert Calendar object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'task_name': _taskName,
      'uniqueId': _uniqueId,
      'scheduleId': _scheduleId,
      'sId': _sId,
      'stdId': _stdId,
      'uId': _uId,
      'user_id': _userId,
      'aStatus': _aStatus,
      'task_details': _taskDetails,
      'task_location': _taskLocation,
      'task_id': _taskId,
      'task_code': _taskCode,
      'calendar': _calendar,
      'time': _time,
      'day': _day,
      'url': _url,
      'link': _link,
      'dateTime': _dateTime,
      'done': _done,
      'sync_status': _syncStatus,
      'sync_key': _syncKey,
    };
  }

  // Create Calendar object from Map
  static Calendar fromMap(Map<String, dynamic> map) {
    return Calendar(
      id: map['id'],
      taskName: map['task_name'],
      uniqueId: map['uniqueId'],
      scheduleId: map['scheduleId'],
      sId: map['sId'],
      stdId: map['stdId'],
      uId: map['uId'],
      userId: map['user_id'],
      aStatus: map['aStatus'],
      taskDetails: map['task_details'],
      taskLocation: map['task_location'],
      taskId: map['task_id'],
      taskCode: map['task_code'],
      calendar: map['calendar'],
      time: map['time'],
      day: map['day'],
      url: map['url'],
      link: map['link'],
      dateTime: map['dateTime'],
      done: map['done'],
      syncStatus: map['sync_status'],
      syncKey: map['sync_key'],
    );
  }
}
