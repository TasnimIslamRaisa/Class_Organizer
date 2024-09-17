class School {
  String? _sId;
  String? _sName;
  String? _sPhone;
  String? _sEmail;
  String? _sPass;
  String? _sAdrs;
  String? _sEiin;
  String? _sFundsBal;
  String? _sAYear;
  String? _sVerification;
  String? _currSessId;
  String? _sItp1;
  String? _sItp2;
  String? _sItEmail;
  String? _sWeb;
  String? _sFundsBank;
  String? _sFundsAN;
  String? _sLogo;
  int? _id;
  int? _sActivate;
  int? _sEmpl;
  int? _sCourse;
  int? _sClass;
  int? _sSec;
  int? _sUser;
  int? _sTeacher;
  int? _sStudent;
  String? _syncKey;
  int _syncStatus = 0;
  String? _key;
  String? _uniqueId;

  // Constructor
  School({
    int? id,
    String? sId,
    String? sName,
    String? sPhone,
    String? sEmail,
    String? sPass,
    String? sAdrs,
    String? sEiin,
    String? sFundsBal,
    String? sAYear,
    String? sVerification,
    String? currSessId,
    String? sItp1,
    String? sItp2,
    String? sItEmail,
    String? sWeb,
    String? sFundsBank,
    String? sFundsAN,
    String? sLogo,
    int? sActivate,
    int? sEmpl,
    int? sCourse,
    int? sClass,
    int? sSec,
    int? sUser,
    int? sTeacher,
    int? sStudent,
    String? syncKey,
    int? syncStatus,
    String? uniqueId,
    String? key,
  })  : _id = id,
        _sId = sId,
        _sName = sName,
        _sPhone = sPhone,
        _sEmail = sEmail,
        _sPass = sPass,
        _sAdrs = sAdrs,
        _sEiin = sEiin,
        _sFundsBal = sFundsBal,
        _sAYear = sAYear,
        _sVerification = sVerification,
        _currSessId = currSessId,
        _sItp1 = sItp1,
        _sItp2 = sItp2,
        _sItEmail = sItEmail,
        _sWeb = sWeb,
        _sFundsBank = sFundsBank,
        _sFundsAN = sFundsAN,
        _sLogo = sLogo,
        _sActivate = sActivate,
        _sEmpl = sEmpl,
        _sCourse = sCourse,
        _sClass = sClass,
        _sSec = sSec,
        _sUser = sUser,
        _sTeacher = sTeacher,
        _sStudent = sStudent,
        _syncKey = syncKey,
        _syncStatus = syncStatus ?? 0,
        _uniqueId = uniqueId,
        _key = key;

  // Getters and Setters
  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;

  String? get sName => _sName;
  set sName(String? sName) => _sName = sName;

  String? get sPhone => _sPhone;
  set sPhone(String? sPhone) => _sPhone = sPhone;

  String? get sEmail => _sEmail;
  set sEmail(String? sEmail) => _sEmail = sEmail;

  String? get sPass => _sPass;
  set sPass(String? sPass) => _sPass = sPass;

  String? get sAdrs => _sAdrs;
  set sAdrs(String? sAdrs) => _sAdrs = sAdrs;

  String? get sEiin => _sEiin;
  set sEiin(String? sEiin) => _sEiin = sEiin;

  String? get sFundsBal => _sFundsBal;
  set sFundsBal(String? sFundsBal) => _sFundsBal = sFundsBal;

  String? get sAYear => _sAYear;
  set sAYear(String? sAYear) => _sAYear = sAYear;

  String? get sVerification => _sVerification;
  set sVerification(String? sVerification) => _sVerification = sVerification;

  String? get currSessId => _currSessId;
  set currSessId(String? currSessId) => _currSessId = currSessId;

  String? get sItp1 => _sItp1;
  set sItp1(String? sItp1) => _sItp1 = sItp1;

  String? get sItp2 => _sItp2;
  set sItp2(String? sItp2) => _sItp2 = sItp2;

  String? get sItEmail => _sItEmail;
  set sItEmail(String? sItEmail) => _sItEmail = sItEmail;

  String? get sWeb => _sWeb;
  set sWeb(String? sWeb) => _sWeb = sWeb;

  String? get sFundsBank => _sFundsBank;
  set sFundsBank(String? sFundsBank) => _sFundsBank = sFundsBank;

  String? get sFundsAN => _sFundsAN;
  set sFundsAN(String? sFundsAN) => _sFundsAN = sFundsAN;

  String? get sLogo => _sLogo;
  set sLogo(String? sLogo) => _sLogo = sLogo;

  int? get id => _id;
  set id(int? id) => _id = id;

  int? get sActivate => _sActivate;
  set sActivate(int? sActivate) => _sActivate = sActivate;

  int? get sEmpl => _sEmpl;
  set sEmpl(int? sEmpl) => _sEmpl = sEmpl;

  int? get sCourse => _sCourse;
  set sCourse(int? sCourse) => _sCourse = sCourse;

  int? get sClass => _sClass;
  set sClass(int? sClass) => _sClass = sClass;

  int? get sSec => _sSec;
  set sSec(int? sSec) => _sSec = sSec;

  int? get sUser => _sUser;
  set sUser(int? sUser) => _sUser = sUser;

  int? get sTeacher => _sTeacher;
  set sTeacher(int? sTeacher) => _sTeacher = sTeacher;

  int? get sStudent => _sStudent;
  set sStudent(int? sStudent) => _sStudent = sStudent;

  String? get syncKey => _syncKey;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  int get syncStatus => _syncStatus;
  set syncStatus(int syncStatus) => _syncStatus = syncStatus;

  String? get uniqueId => _uniqueId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;

  String? get key => _key;
  set key(String? key) => _key = key;

  // Map to Object
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sId': _sId,
      'sName': _sName,
      'sPhone': _sPhone,
      'sEmail': _sEmail,
      'sPass': _sPass,
      'sAdrs': _sAdrs,
      'sEiin': _sEiin,
      'sFundsBal': _sFundsBal,
      'sAYear': _sAYear,
      'sVerification': _sVerification,
      'currSessId': _currSessId,
      'sItp1': _sItp1,
      'sItp2': _sItp2,
      'sItEmail': _sItEmail,
      'sWeb': _sWeb,
      'sFundsBank': _sFundsBank,
      'sFundsAN': _sFundsAN,
      'sLogo': _sLogo,
      'sActivate': _sActivate,
      'sEmpl': _sEmpl,
      'sCourse': _sCourse,
      'sClass': _sClass,
      'sSec': _sSec,
      'sUser': _sUser,
      'sTeacher': _sTeacher,
      'sStudent': _sStudent,
      'sync_key': _syncKey,
      'sync_status': _syncStatus,
      'uniqueId': _uniqueId,
      'key': _key,
    };
  }

  // Object from Map
  static School fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'],
      sId: map['sId'] ?? '',
      sName: map['sName'] ?? '',
      sPhone: map['sPhone'] ?? '',
      sEmail: map['sEmail'] ?? '',
      sPass: map['sPass'] ?? '',
      sAdrs: map['sAdrs'] ?? '',
      sEiin: map['sEiin'] ?? '',
      sFundsBal: map['sFundsBal'] ?? '',
      sAYear: map['sAYear'] ?? '',
      sVerification: map['sVerification'] ?? '',
      currSessId: map['currSessId'] ?? '',
      sItp1: map['sItp1'] ?? '',
      sItp2: map['sItp2'] ?? '',
      sItEmail: map['sItEmail'] ?? '',
      sWeb: map['sWeb'] ?? '',
      sFundsBank: map['sFundsBank'] ?? '',
      sFundsAN: map['sFundsAN'] ?? '',
      sLogo: map['sLogo'] ?? '',
      sActivate: map['sActivate'],
      sEmpl: map['sEmpl'],
      sCourse: map['sCourse'],
      sClass: map['sClass'],
      sSec: map['sSec'],
      sUser: map['sUser'],
      sTeacher: map['sTeacher'],
      sStudent: map['sStudent'],
      syncKey: map['syncKey'] ?? '',
      syncStatus: map['syncStatus'],
      uniqueId: map['uniqueId'] ?? '',
      key: map['key'] ?? '',
    );
  }


  //   Map<String, dynamic> toMap() {
  //   return {
  //     'id': _id,
  //     'sId': _sId,
  //     'sName': _sName,
  //     'sPhone': _sPhone,
  //     'sEmail': _sEmail,
  //     'sPass': _sPass,
  //     'sAdrs': _sAdrs,
  //     'sEiin': _sEiin,
  //     'sFundsBal': _sFundsBal,
  //     'sAYear': _sAYear,
  //     'sVerification': _sVerification,
  //     'currSessId': _currSessId,
  //     'sItp1': _sItp1,
  //     'sItp2': _sItp2,
  //     'sItEmail': _sItEmail,
  //     'sWeb': _sWeb,
  //     'sFundsBank': _sFundsBank,
  //     'sFundsAN': _sFundsAN,
  //     'sLogo': _sLogo,
  //     'sActivate': _sActivate,
  //     'sEmpl': _sEmpl,
  //     'sCourse': _sCourse,
  //     'sClass': _sClass,
  //     'sSec': _sSec,
  //     'sUser': _sUser,
  //     'sTeacher': _sTeacher,
  //     'sStudent': _sStudent,
  //     'syncKey': _syncKey,
  //     'syncStatus': _syncStatus,
  //     'uniqueId': _uniqueId,
  //     'key': _key,
  //   };
  // }

  // Convert a Map object into a School object
  // School.fromMap(Map<String, dynamic> map)
  //     : _id = map['id'],
  //       _sId = map['sId'],
  //       _sName = map['sName'],
  //       _sPhone = map['sPhone'],
  //       _sEmail = map['sEmail'],
  //       _sPass = map['sPass'],
  //       _sAdrs = map['sAdrs'],
  //       _sEiin = map['sEiin'],
  //       _sFundsBal = map['sFundsBal'],
  //       _sAYear = map['sAYear'],
  //       _sVerification = map['sVerification'],
  //       _currSessId = map['currSessId'],
  //       _sItp1 = map['sItp1'],
  //       _sItp2 = map['sItp2'],
  //       _sItEmail = map['sItEmail'],
  //       _sWeb = map['sWeb'],
  //       _sFundsBank = map['sFundsBank'],
  //       _sFundsAN = map['sFundsAN'],
  //       _sLogo = map['sLogo'],
  //       _sActivate = map['sActivate'],
  //       _sEmpl = map['sEmpl'],
  //       _sCourse = map['sCourse'],
  //       _sClass = map['sClass'],
  //       _sSec = map['sSec'],
  //       _sUser = map['sUser'],
  //       _sTeacher = map['sTeacher'],
  //       _sStudent = map['sStudent'],
  //       _syncKey = map['syncKey'],
  //       _syncStatus = map['syncStatus'],
  //       _uniqueId = map['uniqueId'],
  //       _key = map['key'];

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'sId': _sId,
      'sName': _sName,
      'sPhone': _sPhone,
      'sEmail': _sEmail,
      'sPass': _sPass,
      'sAdrs': _sAdrs,
      'sEiin': _sEiin,
      'sFundsBal': _sFundsBal,
      'sAYear': _sAYear,
      'sVerification': _sVerification,
      'currSessId': _currSessId,
      'sItp1': _sItp1,
      'sItp2': _sItp2,
      'sItEmail': _sItEmail,
      'sWeb': _sWeb,
      'sFundsBank': _sFundsBank,
      'sFundsAN': _sFundsAN,
      'sLogo': _sLogo,
      'sActivate': _sActivate,
      'sEmpl': _sEmpl,
      'sCourse': _sCourse,
      'sClass': _sClass,
      'sSec': _sSec,
      'sUser': _sUser,
      'sTeacher': _sTeacher,
      'sStudent': _sStudent,
      'syncKey': _syncKey,
      'syncStatus': _syncStatus,
      'uniqueId': _uniqueId,
      'key': _key,
    };
  }

  static School fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      sId: json['sId'],
      sName: json['sName'],
      sPhone: json['sPhone'],
      sEmail: json['sEmail'],
      sPass: json['sPass'],
      sAdrs: json['sAdrs'],
      sEiin: json['sEiin'],
      sFundsBal: json['sFundsBal'],
      sAYear: json['sAYear'],
      sVerification: json['sVerification'],
      currSessId: json['currSessId'],
      sItp1: json['sItp1'],
      sItp2: json['sItp2'],
      sItEmail: json['sItEmail'],
      sWeb: json['sWeb'],
      sFundsBank: json['sFundsBank'],
      sFundsAN: json['sFundsAN'],
      sLogo: json['sLogo'],
      sActivate: json['sActivate'],
      sEmpl: json['sEmpl'],
      sCourse: json['sCourse'],
      sClass: json['sClass'],
      sSec: json['sSec'],
      sUser: json['sUser'],
      sTeacher: json['sTeacher'],
      sStudent: json['sStudent'],
      syncKey: json['syncKey'],
      syncStatus: json['syncStatus'],
      uniqueId: json['uniqueId'],
      key: json['key'],
    );
  }

  @override
  String toString() {
    return _sName ?? '';
  }
}
