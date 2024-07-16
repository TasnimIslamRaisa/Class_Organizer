class Major {
  int? _id;
  String? _sId;
  String? _uniqueId;
  String? _location;
  String? _deanId;
  String? _phone;
  String? _mName;
  String? _mStart;
  String? _mEnd;
  int? _mStatus;
  String? _currentId;
  int? _syncStatus;
  String? _syncKey;

  Major({
    int? id,
    String? sId,
    String? uniqueId,
    String? location,
    String? deanId,
    String? phone,
    String? mName,
    String? mStart,
    String? mEnd,
    int? mStatus,
    String? currentId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _sId = sId,
        _uniqueId = uniqueId,
        _location = location,
        _deanId = deanId,
        _phone = phone,
        _mName = mName,
        _mStart = mStart,
        _mEnd = mEnd,
        _mStatus = mStatus,
        _currentId = currentId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get sId => _sId;
  String? get uniqueId => _uniqueId;
  String? get location => _location;
  String? get deanId => _deanId;
  String? get phone => _phone;
  String? get mName => _mName;
  String? get mStart => _mStart;
  String? get mEnd => _mEnd;
  int? get mStatus => _mStatus;
  String? get currentId => _currentId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set sId(String? sId) => _sId = sId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set location(String? location) => _location = location;
  set deanId(String? deanId) => _deanId = deanId;
  set phone(String? phone) => _phone = phone;
  set mName(String? mName) => _mName = mName;
  set mStart(String? mStart) => _mStart = mStart;
  set mEnd(String? mEnd) => _mEnd = mEnd;
  set mStatus(int? mStatus) => _mStatus = mStatus;
  set currentId(String? currentId) => _currentId = currentId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sId': _sId,
      'uniqueId': _uniqueId,
      'location': _location,
      'deanId': _deanId,
      'phone': _phone,
      'mName': _mName,
      'mStart': _mStart,
      'mEnd': _mEnd,
      'mStatus': _mStatus,
      'currentId': _currentId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static Major fromMap(Map<String, dynamic> map) {
    return Major(
      id: map['id'],
      sId: map['sId'],
      uniqueId: map['uniqueId'],
      location: map['location'],
      deanId: map['deanId'],
      phone: map['phone'],
      mName: map['mName'],
      mStart: map['mStart'],
      mEnd: map['mEnd'],
      mStatus: map['mStatus'],
      currentId: map['currentId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
