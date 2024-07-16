class Faculties {
  int? _id;
  int? _status;
  String? _uniqueid;
  String? _sync_key;
  int? _sync_status;
  String? _fname;
  String? _created_date;
  int _nums_dept;
  String _t_id;
  String? _sid;
  String? _userid;

  Faculties({
    int? id,
    int? status,
    String? uniqueid,
    String? sync_key,
    int? sync_status,
    String? fname,
    String? created_date,
    required int nums_dept,
    required String t_id,
    String? sid,
    String? userid,
  })  : _id = id,
        _status = status,
        _uniqueid = uniqueid,
        _sync_key = sync_key,
        _sync_status = sync_status,
        _fname = fname,
        _created_date = created_date,
        _nums_dept = nums_dept,
        _t_id = t_id,
        _sid = sid,
        _userid = userid;

  // Getters
  int? get id => _id;
  int? get status => _status;
  String? get uniqueid => _uniqueid;
  String? get sync_key => _sync_key;
  int? get sync_status => _sync_status;
  String? get fname => _fname;
  String? get created_date => _created_date;
  int get nums_dept => _nums_dept;
  String get t_id => _t_id;
  String? get sid => _sid;
  String? get userid => _userid;

  // Setters
  set id(int? id) => _id = id;
  set status(int? status) => _status = status;
  set uniqueid(String? uniqueid) => _uniqueid = uniqueid;
  set sync_key(String? sync_key) => _sync_key = sync_key;
  set sync_status(int? sync_status) => _sync_status = sync_status;
  set fname(String? fname) => _fname = fname;
  set created_date(String? created_date) => _created_date = created_date;
  set nums_dept(int nums_dept) => _nums_dept = nums_dept;
  set t_id(String t_id) => _t_id = t_id;
  set sid(String? sid) => _sid = sid;
  set userid(String? userid) => _userid = userid;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'status': _status,
      'uniqueid': _uniqueid,
      'sync_key': _sync_key,
      'sync_status': _sync_status,
      'fname': _fname,
      'created_date': _created_date,
      'nums_dept': _nums_dept,
      't_id': _t_id,
      'sid': _sid,
      'userid': _userid,
    };
  }

  static Faculties fromMap(Map<String, dynamic> map) {
    return Faculties(
      id: map['id'],
      status: map['status'],
      uniqueid: map['uniqueid'],
      sync_key: map['sync_key'],
      sync_status: map['sync_status'],
      fname: map['fname'],
      created_date: map['created_date'],
      nums_dept: map['nums_dept'],
      t_id: map['t_id'],
      sid: map['sid'],
      userid: map['userid'],
    );
  }
}
