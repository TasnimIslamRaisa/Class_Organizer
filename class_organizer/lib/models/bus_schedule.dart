class BusSchedule {
  int? _id;
  String? _uniqueId;
  String? _fromLocation;
  String? _toLocation;
  String? _sId;
  int? _busNo;
  String? _remarks;
  String? _driverPhone;
  String? _startingTime;
  int? _fromToward;
  String? _towardTime;
  int? _status;

  BusSchedule({
    int? id,
    String? uniqueId,
    String? fromLocation,
    String? toLocation,
    String? sId,
    int? busNo,
    String? remarks,
    String? driverPhone,
    String? startingTime,
    int? fromToward,
    String? towardTime,
    int? status,
  })  : _id = id,
        _uniqueId = uniqueId,
        _fromLocation = fromLocation,
        _toLocation = toLocation,
        _sId = sId,
        _busNo = busNo,
        _remarks = remarks,
        _driverPhone = driverPhone,
        _startingTime = startingTime,
        _fromToward = fromToward,
        _towardTime = towardTime,
        _status = status;

  // Getters
  int? get id => _id;
  String? get uniqueId => _uniqueId;
  String? get fromLocation => _fromLocation;
  String? get toLocation => _toLocation;
  String? get sId => _sId;
  int? get busNo => _busNo;
  String? get remarks => _remarks;
  String? get driverPhone => _driverPhone;
  String? get startingTime => _startingTime;
  int? get fromToward => _fromToward;
  String? get towardTime => _towardTime;
  int? get status => _status;

  // Setters
  set id(int? id) => _id = id;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set fromLocation(String? fromLocation) => _fromLocation = fromLocation;
  set toLocation(String? toLocation) => _toLocation = toLocation;
  set sId(String? sId) => _sId = sId;
  set busNo(int? busNo) => _busNo = busNo;
  set remarks(String? remarks) => _remarks = remarks;
  set driverPhone(String? driverPhone) => _driverPhone = driverPhone;
  set startingTime(String? startingTime) => _startingTime = startingTime;
  set fromToward(int? fromToward) => _fromToward = fromToward;
  set towardTime(String? towardTime) => _towardTime = towardTime;
  set status(int? status) => _status = status;

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'uniqueId': _uniqueId,
      'fromLocation': _fromLocation,
      'toLocation': _toLocation,
      'sId': _sId,
      'busNo': _busNo,
      'remarks': _remarks,
      'driverPhone': _driverPhone,
      'startingTime': _startingTime,
      'fromToward': _fromToward,
      'towardTime': _towardTime,
      'status': _status,
    };
  }

  // Convert from Map
  static BusSchedule fromMap(Map<String, dynamic> map) {
    return BusSchedule(
      id: map['id'],
      uniqueId: map['uniqueId'],
      fromLocation: map['fromLocation'],
      toLocation: map['toLocation'],
      sId: map['sId'],
      busNo: map['busNo'],
      remarks: map['remarks'],
      driverPhone: map['driverPhone'],
      startingTime: map['startingTime'],
      fromToward: map['fromToward'],
      towardTime: map['towardTime'],
      status: map['status'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'uniqueId': _uniqueId,
      'fromLocation': _fromLocation,
      'toLocation': _toLocation,
      'sId': _sId,
      'busNo': _busNo,
      'remarks': _remarks,
      'driverPhone': _driverPhone,
      'startingTime': _startingTime,
      'fromToward': _fromToward,
      'towardTime': _towardTime,
      'status': _status,
    };
  }

  // Convert from JSON
  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'],
      uniqueId: json['uniqueId'],
      fromLocation: json['fromLocation'],
      toLocation: json['toLocation'],
      sId: json['sId'],
      busNo: json['busNo'],
      remarks: json['remarks'],
      driverPhone: json['driverPhone'],
      startingTime: json['startingTime'],
      fromToward: json['fromToward'],
      towardTime: json['towardTime'],
      status: json['status'],
    );
  }
}
