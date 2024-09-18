class AYear {
  int? _id;
  String? _uId;
  String? _aYname;
  String? _uniqueId;
  String? _sYear;
  String? _sMonth;
  String? _eYear;
  String? _eMonth;
  int? _aStatus;
  String? _sId;
  int? _syncStatus;
  String? _syncKey;

  AYear({
    int? id,
    String? uId,
    String? aYname,
    String? uniqueId,
    String? sYear,
    String? sMonth,
    String? eYear,
    String? eMonth,
    int? aStatus,
    String? sId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _uId = uId,
        _aYname = aYname,
        _uniqueId = uniqueId,
        _sYear = sYear,
        _sMonth = sMonth,
        _eYear = eYear,
        _eMonth = eMonth,
        _aStatus = aStatus,
        _sId = sId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get uId => _uId;
  String? get aYname => _aYname;
  String? get uniqueId => _uniqueId;
  String? get sYear => _sYear;
  String? get sMonth => _sMonth;
  String? get eYear => _eYear;
  String? get eMonth => _eMonth;
  int? get aStatus => _aStatus;
  String? get sId => _sId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set uId(String? uId) => _uId = uId;
  set aYname(String? aYname) => _aYname = aYname;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set sYear(String? sYear) => _sYear = sYear;
  set sMonth(String? sMonth) => _sMonth = sMonth;
  set eYear(String? eYear) => _eYear = eYear;
  set eMonth(String? eMonth) => _eMonth = eMonth;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set sId(String? sId) => _sId = sId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'uId': _uId,
      'aYname': _aYname,
      'uniqueId': _uniqueId,
      'sYear': _sYear,
      'sMonth': _sMonth,
      'eYear': _eYear,
      'eMonth': _eMonth,
      'aStatus': _aStatus,
      'sId': _sId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static AYear fromMap(Map<String, dynamic> map) {
    return AYear(
      id: map['id'],
      uId: map['uId'],
      aYname: map['aYname'],
      uniqueId: map['uniqueId'],
      sYear: map['sYear'],
      sMonth: map['sMonth'],
      eYear: map['eYear'],
      eMonth: map['eMonth'],
      aStatus: map['aStatus'],
      sId: map['sId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'uId': _uId,
      'aYname': _aYname,
      'uniqueId': _uniqueId,
      'sYear': _sYear,
      'sMonth': _sMonth,
      'eYear': _eYear,
      'eMonth': _eMonth,
      'aStatus': _aStatus,
      'sId': _sId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  factory AYear.fromJson(Map<String, dynamic> json) {
    return AYear(
      id: json['id'],
      uId: json['uId'],
      aYname: json['aYname'],
      uniqueId: json['uniqueId'],
      sYear: json['sYear'],
      sMonth: json['sMonth'],
      eYear: json['eYear'],
      eMonth: json['eMonth'],
      aStatus: json['aStatus'],
      sId: json['sId'],
      syncStatus: json['syncStatus'],
      syncKey: json['syncKey'],
    );
  }
}
