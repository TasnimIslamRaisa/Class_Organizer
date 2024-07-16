class Mail {
  int? _id;
  String? _sendId;
  String? _uniqueId;
  String? _sendMail;
  String? _recId;
  String? _recMail;
  String? _sendDate;
  String? _sendTime;
  String? _deliverDate;
  String? _deliverTime;
  String? _recDate;
  String? _recTime;
  String? _sub;
  String? _msg;
  String? _file;
  int? _syncStatus;
  String? _syncKey;

  Mail({
    int? id,
    String? sendId,
    String? uniqueId,
    String? sendMail,
    String? recId,
    String? recMail,
    String? sendDate,
    String? sendTime,
    String? deliverDate,
    String? deliverTime,
    String? recDate,
    String? recTime,
    String? sub,
    String? msg,
    String? file,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _sendId = sendId,
        _uniqueId = uniqueId,
        _sendMail = sendMail,
        _recId = recId,
        _recMail = recMail,
        _sendDate = sendDate,
        _sendTime = sendTime,
        _deliverDate = deliverDate,
        _deliverTime = deliverTime,
        _recDate = recDate,
        _recTime = recTime,
        _sub = sub,
        _msg = msg,
        _file = file,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  String? get sendId => _sendId;
  String? get uniqueId => _uniqueId;
  String? get sendMail => _sendMail;
  String? get recId => _recId;
  String? get recMail => _recMail;
  String? get sendDate => _sendDate;
  String? get sendTime => _sendTime;
  String? get deliverDate => _deliverDate;
  String? get deliverTime => _deliverTime;
  String? get recDate => _recDate;
  String? get recTime => _recTime;
  String? get sub => _sub;
  String? get msg => _msg;
  String? get file => _file;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set sendId(String? sendId) => _sendId = sendId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set sendMail(String? sendMail) => _sendMail = sendMail;
  set recId(String? recId) => _recId = recId;
  set recMail(String? recMail) => _recMail = recMail;
  set sendDate(String? sendDate) => _sendDate = sendDate;
  set sendTime(String? sendTime) => _sendTime = sendTime;
  set deliverDate(String? deliverDate) => _deliverDate = deliverDate;
  set deliverTime(String? deliverTime) => _deliverTime = deliverTime;
  set recDate(String? recDate) => _recDate = recDate;
  set recTime(String? recTime) => _recTime = recTime;
  set sub(String? sub) => _sub = sub;
  set msg(String? msg) => _msg = msg;
  set file(String? file) => _file = file;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  // Convert Mail object to a map of data
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sendId': _sendId,
      'uniqueId': _uniqueId,
      'sendMail': _sendMail,
      'recId': _recId,
      'recMail': _recMail,
      'sendDate': _sendDate,
      'sendTime': _sendTime,
      'deliverDate': _deliverDate,
      'deliverTime': _deliverTime,
      'recDate': _recDate,
      'recTime': _recTime,
      'sub': _sub,
      'msg': _msg,
      'file': _file,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  // Create a Mail object from a map of data
  static Mail fromMap(Map<String, dynamic> map) {
    return Mail(
      id: map['id'],
      sendId: map['sendId'],
      uniqueId: map['uniqueId'],
      sendMail: map['sendMail'],
      recId: map['recId'],
      recMail: map['recMail'],
      sendDate: map['sendDate'],
      sendTime: map['sendTime'],
      deliverDate: map['deliverDate'],
      deliverTime: map['deliverTime'],
      recDate: map['recDate'],
      recTime: map['recTime'],
      sub: map['sub'],
      msg: map['msg'],
      file: map['file'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
