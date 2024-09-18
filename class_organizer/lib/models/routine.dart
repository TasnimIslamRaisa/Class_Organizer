class Routine {
  int? _id;
  String? _sId;
  String? _uId;
  String? _stdId;
  String? _tempName;
  String? _tempCode;
  String? _tempDetails;
  String? _tempNum;
  String? _uniqueId;
  String? _syncKey;
  int _syncStatus = 0;
  int _aStatus = 0;
  String? _key;
  String? _tId;

  Routine({
    int? id,
    String? sId,
    String? uId,
    String? stdId,
    String? tempName,
    String? tempCode,
    String? tempDetails,
    String? tempNum,
    String? uniqueId,
    String? syncKey,
    int syncStatus = 0,
    int aStatus = 0,
    String? key,
    String? tId,
  })  : _id = id,
        _sId = sId,
        _uId = uId,
        _stdId = stdId,
        _tempName = tempName,
        _tempCode = tempCode,
        _tempDetails = tempDetails,
        _tempNum = tempNum,
        _uniqueId = uniqueId,
        _syncKey = syncKey,
        _syncStatus = syncStatus,
        _aStatus = aStatus,
        _key = key,
        _tId = tId;

  // Getters
  int? get id => _id;
  String? get sId => _sId;
  String? get uId => _uId;
  String? get stdId => _stdId;
  String? get tempName => _tempName;
  String? get tempCode => _tempCode;
  String? get tempDetails => _tempDetails;
  String? get tempNum => _tempNum;
  String? get uniqueId => _uniqueId;
  String? get syncKey => _syncKey;
  int get syncStatus => _syncStatus;
  int get aStatus => _aStatus;
  String? get key => _key;
  String? get tId => _tId;

  // Setters
  set id(int? id) => _id = id;
  set sId(String? sId) => _sId = sId;
  set uId(String? uId) => _uId = uId;
  set stdId(String? stdId) => _stdId = stdId;
  set tempName(String? tempName) => _tempName = tempName;
  set tempCode(String? tempCode) => _tempCode = tempCode;
  set tempDetails(String? tempDetails) => _tempDetails = tempDetails;
  set tempNum(String? tempNum) => _tempNum = tempNum;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set syncKey(String? syncKey) => _syncKey = syncKey;
  set syncStatus(int syncStatus) => _syncStatus = syncStatus;
  set aStatus(int aStatus) => _aStatus = aStatus;
  set key(String? key) => _key = key;
  set tId(String? tId) => _tId = tId;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sId': _sId,
      'uId': _uId,
      'stdId': _stdId,
      'tempName': _tempName,
      'tempCode': _tempCode,
      'tempDetails': _tempDetails,
      'tempNum': _tempNum,
      'uniqueId': _uniqueId,
      'syncKey': _syncKey,
      'syncStatus': _syncStatus,
      'aStatus': _aStatus,
      'key': _key,
      'tId': _tId,
    };
  }

  static Routine fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'],
      sId: map['sId'],
      uId: map['uId'],
      stdId: map['stdId'],
      tempName: map['tempName'],
      tempCode: map['tempCode'],
      tempDetails: map['tempDetails'],
      tempNum: map['tempNum'],
      uniqueId: map['uniqueId'],
      syncKey: map['syncKey'],
      syncStatus: map['syncStatus'],
      aStatus: map['aStatus'],
      key: map['key'],
      tId: map['tId'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'sId': _sId,
      'uId': _uId,
      'stdId': _stdId,
      'tempName': _tempName,
      'tempCode': _tempCode,
      'tempDetails': _tempDetails,
      'tempNum': _tempNum,
      'uniqueId': _uniqueId,
      'syncKey': _syncKey,
      'syncStatus': _syncStatus,
      'aStatus': _aStatus,
      'key': _key,
      'tId': _tId,
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      sId: json['sId'],
      uId: json['uId'],
      stdId: json['stdId'],
      tempName: json['tempName'],
      tempCode: json['tempCode'],
      tempDetails: json['tempDetails'],
      tempNum: json['tempNum'],
      uniqueId: json['uniqueId'],
      syncKey: json['syncKey'],
      syncStatus: json['syncStatus'],
      aStatus: json['aStatus'],
      key: json['key'],
      tId: json['tId'],
    );
  }

  @override
  String toString() {
    return _tempName ?? '';
  }
}
