class Payment {
  int? _id;
  int? _paymentId;
  int? _sessionId;
  String? _sessionTextId;
  int? _fId;
  String? _uniqueId;
  int? _payMethodType;
  int? _feeType;
  String? _sId;
  String? _stdId;
  String? _feeId;
  String? _date;
  String? _time;
  String? _trxId;
  String? _payAmount;
  String? _payMethod;
  String? _register;
  String? _phone;
  String? _onlinePhone;
  String? _onlineTrxId;
  String? _bankA;
  String? _bankName;
  String? _depositer;
  int? _syncStatus;
  String? _syncKey;

  Payment({
    int? id,
    int? paymentId,
    int? sessionId,
    String? sessionTextId,
    int? fId,
    String? uniqueId,
    int? payMethodType,
    int? feeType,
    String? sId,
    String? stdId,
    String? feeId,
    String? date,
    String? time,
    String? trxId,
    String? payAmount,
    String? payMethod,
    String? register,
    String? phone,
    String? onlinePhone,
    String? onlineTrxId,
    String? bankA,
    String? bankName,
    String? depositer,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _paymentId = paymentId,
        _sessionId = sessionId,
        _sessionTextId = sessionTextId,
        _fId = fId,
        _uniqueId = uniqueId,
        _payMethodType = payMethodType,
        _feeType = feeType,
        _sId = sId,
        _stdId = stdId,
        _feeId = feeId,
        _date = date,
        _time = time,
        _trxId = trxId,
        _payAmount = payAmount,
        _payMethod = payMethod,
        _register = register,
        _phone = phone,
        _onlinePhone = onlinePhone,
        _onlineTrxId = onlineTrxId,
        _bankA = bankA,
        _bankName = bankName,
        _depositer = depositer,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  int? get paymentId => _paymentId;
  int? get sessionId => _sessionId;
  String? get sessionTextId => _sessionTextId;
  int? get fId => _fId;
  String? get uniqueId => _uniqueId;
  int? get payMethodType => _payMethodType;
  int? get feeType => _feeType;
  String? get sId => _sId;
  String? get stdId => _stdId;
  String? get feeId => _feeId;
  String? get date => _date;
  String? get time => _time;
  String? get trxId => _trxId;
  String? get payAmount => _payAmount;
  String? get payMethod => _payMethod;
  String? get register => _register;
  String? get phone => _phone;
  String? get onlinePhone => _onlinePhone;
  String? get onlineTrxId => _onlineTrxId;
  String? get bankA => _bankA;
  String? get bankName => _bankName;
  String? get depositer => _depositer;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set paymentId(int? paymentId) => _paymentId = paymentId;
  set sessionId(int? sessionId) => _sessionId = sessionId;
  set sessionTextId(String? sessionTextId) => _sessionTextId = sessionTextId;
  set fId(int? fId) => _fId = fId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set payMethodType(int? payMethodType) => _payMethodType = payMethodType;
  set feeType(int? feeType) => _feeType = feeType;
  set sId(String? sId) => _sId = sId;
  set stdId(String? stdId) => _stdId = stdId;
  set feeId(String? feeId) => _feeId = feeId;
  set date(String? date) => _date = date;
  set time(String? time) => _time = time;
  set trxId(String? trxId) => _trxId = trxId;
  set payAmount(String? payAmount) => _payAmount = payAmount;
  set payMethod(String? payMethod) => _payMethod = payMethod;
  set register(String? register) => _register = register;
  set phone(String? phone) => _phone = phone;
  set onlinePhone(String? onlinePhone) => _onlinePhone = onlinePhone;
  set onlineTrxId(String? onlineTrxId) => _onlineTrxId = onlineTrxId;
  set bankA(String? bankA) => _bankA = bankA;
  set bankName(String? bankName) => _bankName = bankName;
  set depositer(String? depositer) => _depositer = depositer;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'paymentId': _paymentId,
      'sessionId': _sessionId,
      'sessionTextId': _sessionTextId,
      'fId': _fId,
      'uniqueId': _uniqueId,
      'payMethodType': _payMethodType,
      'feeType': _feeType,
      'sId': _sId,
      'stdId': _stdId,
      'feeId': _feeId,
      'date': _date,
      'time': _time,
      'trxId': _trxId,
      'payAmount': _payAmount,
      'payMethod': _payMethod,
      'register': _register,
      'phone': _phone,
      'onlinePhone': _onlinePhone,
      'onlineTrxId': _onlineTrxId,
      'bankA': _bankA,
      'bankName': _bankName,
      'depositer': _depositer,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  static Payment fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      paymentId: map['paymentId'],
      sessionId: map['sessionId'],
      sessionTextId: map['sessionTextId'],
      fId: map['fId'],
      uniqueId: map['uniqueId'],
      payMethodType: map['payMethodType'],
      feeType: map['feeType'],
      sId: map['sId'],
      stdId: map['stdId'],
      feeId: map['feeId'],
      date: map['date'],
      time: map['time'],
      trxId: map['trxId'],
      payAmount: map['payAmount'],
      payMethod: map['payMethod'],
      register: map['register'],
      phone: map['phone'],
      onlinePhone: map['onlinePhone'],
      onlineTrxId: map['onlineTrxId'],
      bankA: map['bankA'],
      bankName: map['bankName'],
      depositer: map['depositer'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
