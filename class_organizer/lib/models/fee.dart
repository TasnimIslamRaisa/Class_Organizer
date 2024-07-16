class Fee {
  int? _id;
  int? _feeType;
  int? _status;
  String? _uniqueId;
  int? _scholarshipStatus;
  int? _payStatus;
  int? _sessionId;
  int? _depId;
  int? _clsId;
  int? _secId;
  int? _subId;
  int? _discountStatus;
  int? _discount;
  String? _payMethod;
  String? _feeId;
  String? _feeDetails;
  String? _fee;
  String? _sId;
  String? _date;
  String? _time;
  String? _trxId;
  String? _disAmount;
  String? _stdId;
  int? _syncStatus;
  String? _syncKey;

  Fee({
    int? id,
    int? feeType,
    int? status,
    String? uniqueId,
    int? scholarshipStatus,
    int? payStatus,
    int? sessionId,
    int? depId,
    int? clsId,
    int? secId,
    int? subId,
    int? discountStatus,
    int? discount,
    String? payMethod,
    String? feeId,
    String? feeDetails,
    String? fee,
    String? sId,
    String? date,
    String? time,
    String? trxId,
    String? disAmount,
    String? stdId,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _feeType = feeType,
        _status = status,
        _uniqueId = uniqueId,
        _scholarshipStatus = scholarshipStatus,
        _payStatus = payStatus,
        _sessionId = sessionId,
        _depId = depId,
        _clsId = clsId,
        _secId = secId,
        _subId = subId,
        _discountStatus = discountStatus,
        _discount = discount,
        _payMethod = payMethod,
        _feeId = feeId,
        _feeDetails = feeDetails,
        _fee = fee,
        _sId = sId,
        _date = date,
        _time = time,
        _trxId = trxId,
        _disAmount = disAmount,
        _stdId = stdId,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  int? get feeType => _feeType;
  int? get status => _status;
  String? get uniqueId => _uniqueId;
  int? get scholarshipStatus => _scholarshipStatus;
  int? get payStatus => _payStatus;
  int? get sessionId => _sessionId;
  int? get depId => _depId;
  int? get clsId => _clsId;
  int? get secId => _secId;
  int? get subId => _subId;
  int? get discountStatus => _discountStatus;
  int? get discount => _discount;
  String? get payMethod => _payMethod;
  String? get feeId => _feeId;
  String? get feeDetails => _feeDetails;
  String? get fee => _fee;
  String? get sId => _sId;
  String? get date => _date;
  String? get time => _time;
  String? get trxId => _trxId;
  String? get disAmount => _disAmount;
  String? get stdId => _stdId;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set feeType(int? feeType) => _feeType = feeType;
  set status(int? status) => _status = status;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set scholarshipStatus(int? scholarshipStatus) =>
      _scholarshipStatus = scholarshipStatus;
  set payStatus(int? payStatus) => _payStatus = payStatus;
  set sessionId(int? sessionId) => _sessionId = sessionId;
  set depId(int? depId) => _depId = depId;
  set clsId(int? clsId) => _clsId = clsId;
  set secId(int? secId) => _secId = secId;
  set subId(int? subId) => _subId = subId;
  set discountStatus(int? discountStatus) =>
      _discountStatus = discountStatus;
  set discount(int? discount) => _discount = discount;
  set payMethod(String? payMethod) => _payMethod = payMethod;
  set feeId(String? feeId) => _feeId = feeId;
  set feeDetails(String? feeDetails) => _feeDetails = feeDetails;
  set fee(String? fee) => _fee = fee;
  set sId(String? sId) => _sId = sId;
  set date(String? date) => _date = date;
  set time(String? time) => _time = time;
  set trxId(String? trxId) => _trxId = trxId;
  set disAmount(String? disAmount) => _disAmount = disAmount;
  set stdId(String? stdId) => _stdId = stdId;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  // Convert Fee object to a map of data
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'fee_type': _feeType,
      'status': _status,
      'uniqueId': _uniqueId,
      'scholarshipStatus': _scholarshipStatus,
      'payStatus': _payStatus,
      'sessionId': _sessionId,
      'depId': _depId,
      'clsId': _clsId,
      'secId': _secId,
      'subId': _subId,
      'discountStatus': _discountStatus,
      'discount': _discount,
      'payMethod': _payMethod,
      'feeId': _feeId,
      'feeDetails': _feeDetails,
      'fee': _fee,
      'sId': _sId,
      'date': _date,
      'time': _time,
      'trxId': _trxId,
      'disAmount': _disAmount,
      'stdId': _stdId,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  // Create a Fee object from a map of data
  static Fee fromMap(Map<String, dynamic> map) {
    return Fee(
      id: map['id'],
      feeType: map['fee_type'],
      status: map['status'],
      uniqueId: map['uniqueId'],
      scholarshipStatus: map['scholarshipStatus'],
      payStatus: map['payStatus'],
      sessionId: map['sessionId'],
      depId: map['depId'],
      clsId: map['clsId'],
      secId: map['secId'],
      subId: map['subId'],
      discountStatus: map['discountStatus'],
      discount: map['discount'],
      payMethod: map['payMethod'],
      feeId: map['feeId'],
      feeDetails: map['feeDetails'],
      fee: map['fee'],
      sId: map['sId'],
      date: map['date'],
      time: map['time'],
      trxId: map['trxId'],
      disAmount: map['disAmount'],
      stdId: map['stdId'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
