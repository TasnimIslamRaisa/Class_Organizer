import 'dart:typed_data';

class Teacher {
  int? _id;
  String? _sId;
  String? _uniqueId;
  String? _designation;
  String? _tName;
  String? _tPhone;
  String? _tPass;
  String? _tEmail;
  String? _tAddress;
  int? _aStatus;
  String? _tMajor;
  String? _tBal;
  String? _tLogo;
  String? _tId;
  int? _uType;
  Uint8List? _proPic;
  String? _nidBirth;
  String? _uId;
  int? _syncStatus;
  String? _syncKey;

  Teacher({
    int? id,
    String? sId,
    String? uniqueId,
    String? designation,
    String? tName,
    String? tPhone,
    String? tPass,
    String? tEmail,
    String? tAddress,
    int? aStatus,
    String? tMajor,
    String? tBal,
    String? tLogo,
    String? tId,
    int? uType,
    Uint8List? proPic,
    String? nidBirth,
    String? uId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _sId = sId,
        _uniqueId = uniqueId,
        _designation = designation,
        _tName = tName,
        _tPhone = tPhone,
        _tPass = tPass,
        _tEmail = tEmail,
        _tAddress = tAddress,
        _aStatus = aStatus,
        _tMajor = tMajor,
        _tBal = tBal,
        _tLogo = tLogo,
        _tId = tId,
        _uType = uType,
        _proPic = proPic,
        _nidBirth = nidBirth,
        _uId = uId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get sId => _sId;
  String? get uniqueId => _uniqueId;
  String? get designation => _designation;
  String? get tName => _tName;
  String? get tPhone => _tPhone;
  String? get tPass => _tPass;
  String? get tEmail => _tEmail;
  String? get tAddress => _tAddress;
  int? get aStatus => _aStatus;
  String? get tMajor => _tMajor;
  String? get tBal => _tBal;
  String? get tLogo => _tLogo;
  String? get tId => _tId;
  int? get uType => _uType;
  Uint8List? get proPic => _proPic;
  String? get nidBirth => _nidBirth;
  String? get uId => _uId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set sId(String? sId) => _sId = sId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set designation(String? designation) => _designation = designation;
  set tName(String? tName) => _tName = tName;
  set tPhone(String? tPhone) => _tPhone = tPhone;
  set tPass(String? tPass) => _tPass = tPass;
  set tEmail(String? tEmail) => _tEmail = tEmail;
  set tAddress(String? tAddress) => _tAddress = tAddress;
  set aStatus(int? aStatus) => _aStatus = aStatus;
  set tMajor(String? tMajor) => _tMajor = tMajor;
  set tBal(String? tBal) => _tBal = tBal;
  set tLogo(String? tLogo) => _tLogo = tLogo;
  set tId(String? tId) => _tId = tId;
  set uType(int? uType) => _uType = uType;
  set proPic(Uint8List? proPic) => _proPic = proPic;
  set nidBirth(String? nidBirth) => _nidBirth = nidBirth;
  set uId(String? uId) => _uId = uId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sId': _sId,
      'uniqueId': _uniqueId,
      'designation': _designation,
      'tName': _tName,
      'tPhone': _tPhone,
      'tPass': _tPass,
      'tEmail': _tEmail,
      'tAddress': _tAddress,
      'aStatus': _aStatus,
      'tMajor': _tMajor,
      'tBal': _tBal,
      'tLogo': _tLogo,
      'tId': _tId,
      'uType': _uType,
      'proPic': _proPic,
      'nidBirth': _nidBirth,
      'uId': _uId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static Teacher fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      sId: map['sId'],
      uniqueId: map['uniqueId'],
      designation: map['designation'],
      tName: map['tName'],
      tPhone: map['tPhone'],
      tPass: map['tPass'],
      tEmail: map['tEmail'],
      tAddress: map['tAddress'],
      aStatus: map['aStatus'],
      tMajor: map['tMajor'],
      tBal: map['tBal'],
      tLogo: map['tLogo'],
      tId: map['tId'],
      uType: map['uType'],
      proPic: map['proPic'],
      nidBirth: map['nidBirth'],
      uId: map['uId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'sId': _sId,
      'uniqueId': _uniqueId,
      'designation': _designation,
      'tName': _tName,
      'tPhone': _tPhone,
      'tPass': _tPass,
      'tEmail': _tEmail,
      'tAddress': _tAddress,
      'aStatus': _aStatus,
      'tMajor': _tMajor,
      'tBal': _tBal,
      'tLogo': _tLogo,
      'tId': _tId,
      'uType': _uType,
      'proPic': _proPic != null ? _proPic!.toList() : null, // Uint8List needs to be converted to List<int>
      'nidBirth': _nidBirth,
      'uId': _uId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  // Parse a Map (from JSON) to create a Teacher object
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      sId: json['sId'],
      uniqueId: json['uniqueId'],
      designation: json['designation'],
      tName: json['tName'],
      tPhone: json['tPhone'],
      tPass: json['tPass'],
      tEmail: json['tEmail'],
      tAddress: json['tAddress'],
      aStatus: json['aStatus'],
      tMajor: json['tMajor'],
      tBal: json['tBal'],
      tLogo: json['tLogo'],
      tId: json['tId'],
      uType: json['uType'],
      proPic: json['proPic'] != null ? Uint8List.fromList(List<int>.from(json['proPic'])) : null,
      nidBirth: json['nidBirth'],
      uId: json['uId'],
      syncStatus: json['syncStatus'],
      syncKey: json['syncKey'],
    );
  }

  @override
  String toString() {
    return _tName ?? "";
  }

}
