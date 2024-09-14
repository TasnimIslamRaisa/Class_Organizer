class User {
  int? _id;
  int? _utype;
  int? _status;
  String? _uniqueid;
  String? _sync_key;
  int? _sync_status;
  String? _uname;
  String? _email;
  String _pass;
  String _phone;
  String? _sid;
  String? _userid;

  User({
    int? id,
    int? utype,
    int? status,
    String? uniqueid,
    String? sync_key,
    int? sync_status,
    String? uname,
    String? email,
    required String pass,
    required String phone,
    String? sid,
    String? userid,
  })  : _id = id,
        _utype = utype,
        _status = status,
        _uniqueid = uniqueid,
        _sync_key = sync_key,
        _sync_status = sync_status,
        _uname = uname,
        _email = email,
        _pass = pass,
        _phone = phone,
        _sid = sid,
        _userid = userid;

  // Getters
  int? get id => _id;
  int? get utype => _utype;
  int? get status => _status;
  String? get uniqueid => _uniqueid;
  String? get sync_key => _sync_key;
  int? get sync_status => _sync_status;
  String? get uname => _uname;
  String? get email => _email;
  String get pass => _pass;
  String get phone => _phone;
  String? get sid => _sid;
  String? get userid => _userid;

  // Setters
  set id(int? id) => _id = id;
  set utype(int? utype) => _utype = utype;
  set status(int? status) => _status = status;
  set uniqueid(String? uniqueid) => _uniqueid = uniqueid;
  set sync_key(String? sync_key) => _sync_key = sync_key;
  set sync_status(int? sync_status) => _sync_status = sync_status;
  set uname(String? uname) => _uname = uname;
  set email(String? email) => _email = email;
  set pass(String pass) => _pass = pass;
  set phone(String phone) => _phone = phone;
  set sid(String? sid) => _sid = sid;
  set userid(String? userid) => _userid = userid;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'utype': _utype,
      'status': _status,
      'uniqueId': _uniqueid,
      'sync_key': _sync_key,
      'sync_status': _sync_status,
      'uname': _uname,
      'email': _email,
      'pass': _pass,
      'phone': _phone,
      'sId': _sid,
      'userid': _userid,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      utype: map['utype'],
      status: map['status'],
      uniqueid: map['uniqueId'],
      sync_key: map['sync_key'],
      sync_status: map['sync_status'],
      uname: map['uname'],
      email: map['email'],
      pass: map['pass'],
      phone: map['phone'],
      sid: map['sId'],
      userid: map['userid'],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'utype': _utype,
      'status': _status,
      'uniqueId': _uniqueid,
      'sync_key': _sync_key,
      'sync_status': _sync_status,
      'uname': _uname,
      'email': _email,
      'pass': _pass,
      'phone': _phone,
      'sId': _sid,
      'userid': _userid,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      utype: json['utype'],
      status: json['status'],
      uniqueid: json['uniqueId'],
      sync_key: json['sync_key'],
      sync_status: json['sync_status'],
      uname: json['uname'],
      email: json['email'],
      pass: json['pass'],
      phone: json['phone'],
      sid: json['sId'],
      userid: json['userid'],
    );
  }

}
