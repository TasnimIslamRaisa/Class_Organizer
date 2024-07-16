class FeeType {
  int? _id;
  int? _typeId;
  int? _sessionId;
  String? _sessionTextId;
  String? _uniqueId;
  int? _depId;
  int? _subId;
  int? _secId;
  int? _clsId;
  int? _status;
  int? _discount;
  String? _typeName;
  String? _sId;
  String? _amount;
  int? _syncStatus;
  String? _syncKey;

  FeeType({
    int? id,
    int? typeId,
    int? sessionId,
    String? sessionTextId,
    String? uniqueId,
    int? depId,
    int? subId,
    int? secId,
    int? clsId,
    int? status,
    int? discount,
    String? typeName,
    String? sId,
    String? amount,
    int? syncStatus,
    String? syncKey,
  })  : _id = id,
        _typeId = typeId,
        _sessionId = sessionId,
        _sessionTextId = sessionTextId,
        _uniqueId = uniqueId,
        _depId = depId,
        _subId = subId,
        _secId = secId,
        _clsId = clsId,
        _status = status,
        _discount = discount,
        _typeName = typeName,
        _sId = sId,
        _amount = amount,
        _syncStatus = syncStatus,
        _syncKey = syncKey;

  // Getters
  int? get id => _id;
  int? get typeId => _typeId;
  int? get sessionId => _sessionId;
  String? get sessionTextId => _sessionTextId;
  String? get uniqueId => _uniqueId;
  int? get depId => _depId;
  int? get subId => _subId;
  int? get secId => _secId;
  int? get clsId => _clsId;
  int? get status => _status;
  int? get discount => _discount;
  String? get typeName => _typeName;
  String? get sId => _sId;
  String? get amount => _amount;
  int? get syncStatus => _syncStatus;
  String? get syncKey => _syncKey;

  // Setters
  set id(int? id) => _id = id;
  set typeId(int? typeId) => _typeId = typeId;
  set sessionId(int? sessionId) => _sessionId = sessionId;
  set sessionTextId(String? sessionTextId) => _sessionTextId = sessionTextId;
  set uniqueId(String? uniqueId) => _uniqueId = uniqueId;
  set depId(int? depId) => _depId = depId;
  set subId(int? subId) => _subId = subId;
  set secId(int? secId) => _secId = secId;
  set clsId(int? clsId) => _clsId = clsId;
  set status(int? status) => _status = status;
  set discount(int? discount) => _discount = discount;
  set typeName(String? typeName) => _typeName = typeName;
  set sId(String? sId) => _sId = sId;
  set amount(String? amount) => _amount = amount;
  set syncStatus(int? syncStatus) => _syncStatus = syncStatus;
  set syncKey(String? syncKey) => _syncKey = syncKey;

  // Convert FeeType object to a map of data
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'typeId': _typeId,
      'sessionId': _sessionId,
      'sessionTextId': _sessionTextId,
      'uniqueId': _uniqueId,
      'depId': _depId,
      'subId': _subId,
      'secId': _secId,
      'clsId': _clsId,
      'status': _status,
      'discount': _discount,
      'typeName': _typeName,
      'sId': _sId,
      'amount': _amount,
      'syncStatus': _syncStatus,
      'syncKey': _syncKey,
    };
  }

  // Create a FeeType object from a map of data
  static FeeType fromMap(Map<String, dynamic> map) {
    return FeeType(
      id: map['id'],
      typeId: map['typeId'],
      sessionId: map['sessionId'],
      sessionTextId: map['sessionTextId'],
      uniqueId: map['uniqueId'],
      depId: map['depId'],
      subId: map['subId'],
      secId: map['secId'],
      clsId: map['clsId'],
      status: map['status'],
      discount: map['discount'],
      typeName: map['typeName'],
      sId: map['sId'],
      amount: map['amount'],
      syncStatus: map['syncStatus'],
      syncKey: map['syncKey'],
    );
  }
}
