class Admin {
  final int id;
  final int sid;
  final String aname;
  final String phone;
  final String email;
  final int uid;

  Admin({required this.id, required this.sid, required this.aname, required this.phone, required this.email, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sid': sid,
      'aname': aname,
      'phone': phone,
      'email': email,
      'uid': uid,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      sid: map['sid'],
      aname: map['aname'],
      phone: map['phone'],
      email: map['email'],
      uid: map['uid'],
    );
  }
}
