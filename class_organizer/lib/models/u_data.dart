class UData {
  int? _id;
  int _uid;
  int _sid;
  String _fname;
  String _lname;
  String _phone;
  String _address;
  String? _userid;

  UData({
    int? id,
    required int uid,
    required int sid,
    required String fname,
    required String lname,
    required String phone,
    required String address,
    required String? userid,
  })  : _id = id,
        _uid = uid,
        _sid = sid,
        _fname = fname,
        _lname = lname,
        _phone = phone,
        _address = address,
        _userid = userid;

  // Getters
  int? get id => _id;
  int get uid => _uid;
  int get sid => _sid;
  String get fname => _fname;
  String get lname => _lname;
  String get phone => _phone;
  String get address => _address;
  String? get userid => _userid;

  // Setters
  set id(int? id) => _id = id;
  set uid(int uid) => _uid = uid;
  set sid(int sid) => _sid = sid;
  set fname(String fname) => _fname = fname;
  set lname(String lname) => _lname = lname;
  set phone(String phone) => _phone = phone;
  set address(String address) => _address = address;
  set userid(String? userid) => _userid = userid;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'uid': _uid,
      'sid': _sid,
      'fname': _fname,
      'lname': _lname,
      'phone': _phone,
      'address': _address,
      'userid': _userid,
    };
  }

  static UData fromMap(Map<String, dynamic> map) {
    return UData(
      id: map['id'],
      uid: map['uid'],
      sid: map['sid'],
      fname: map['fname'],
      lname: map['lname'],
      phone: map['phone'],
      address: map['address'],
      userid: map['userid'],
    );
  }
}
