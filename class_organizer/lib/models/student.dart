import 'dart:typed_data';
import 'package:intl/intl.dart';

class Student {
  int? id;
  int? program;
  String? studentId;
  String? uId;
  String? sId;
  String? stdId;
  String? stdName;
  String? stdPhone;
  String? stdEmail;
  String? homePhone;
  String? stdReligion;
  String? address;
  String? dob;
  String? nidBirth;
  String? country;
  String? unionWord;
  String? fatherName;
  String? motherName;
  String? fNid;
  String? mNid;
  String? gName;
  String? gAddress;
  String? gPhone;
  String? gEmail;
  String? stdImg;
  String? major;
  String? sMajor;
  String? stdPass;
  String? gender;
  String? addDate;
  int? aStatus;
  Uint8List? imgData;
  String? syncKey;
  String? key;
  int syncStatus = 0;
  String? uniqueId;
  String? currSessId;

  // Constructor
  Student({
    this.id,
    this.program,
    this.studentId,
    this.uId,
    this.sId,
    this.stdId,
    this.stdName,
    this.stdPhone,
    this.stdEmail,
    this.homePhone,
    this.stdReligion,
    this.address,
    this.dob,
    this.nidBirth,
    this.country,
    this.unionWord,
    this.fatherName,
    this.motherName,
    this.fNid,
    this.mNid,
    this.gName,
    this.gAddress,
    this.gPhone,
    this.gEmail,
    this.stdImg,
    this.major,
    this.sMajor,
    this.stdPass,
    this.gender,
    this.addDate,
    this.aStatus,
    this.imgData,
    this.syncKey,
    this.key,
    this.syncStatus = 0,
    this.uniqueId,
    this.currSessId,
  });

  // Getters and Setters
  int? get getId => id;
  set setId(int? id) => this.id = id;

  int? get getProgram => program;
  set setProgram(int? program) => this.program = program;

  String? get getStudentId => studentId;
  set setStudentId(String? studentId) => this.studentId = studentId;

  String? get getUId => uId;
  set setUId(String? uId) => this.uId = uId;

  String? get getSId => sId;
  set setSId(String? sId) => this.sId = sId;

  String? get getStdId => stdId;
  set setStdId(String? stdId) => this.stdId = stdId;

  String? get getStdName => stdName;
  set setStdName(String? stdName) => this.stdName = stdName;

  String? get getStdPhone => stdPhone;
  set setStdPhone(String? stdPhone) => this.stdPhone = stdPhone;

  String? get getStdEmail => stdEmail;
  set setStdEmail(String? stdEmail) => this.stdEmail = stdEmail;

  String? get getHomePhone => homePhone;
  set setHomePhone(String? homePhone) => this.homePhone = homePhone;

  String? get getStdReligion => stdReligion;
  set setStdReligion(String? stdReligion) => this.stdReligion = stdReligion;

  String? get getAddress => address;
  set setAddress(String? address) => this.address = address;

  String? get getDob => dob;
  set setDob(String? dob) => this.dob = dob;

  String? get getNidBirth => nidBirth;
  set setNidBirth(String? nidBirth) => this.nidBirth = nidBirth;

  String? get getCountry => country;
  set setCountry(String? country) => this.country = country;

  String? get getUnionWord => unionWord;
  set setUnionWord(String? unionWord) => this.unionWord = unionWord;

  String? get getFatherName => fatherName;
  set setFatherName(String? fatherName) => this.fatherName = fatherName;

  String? get getMotherName => motherName;
  set setMotherName(String? motherName) => this.motherName = motherName;

  String? get getFNid => fNid;
  set setFNid(String? fNid) => this.fNid = fNid;

  String? get getMNid => mNid;
  set setMNid(String? mNid) => this.mNid = mNid;

  String? get getGName => gName;
  set setGName(String? gName) => this.gName = gName;

  String? get getGAddress => gAddress;
  set setGAddress(String? gAddress) => this.gAddress = gAddress;

  String? get getGPhone => gPhone;
  set setGPhone(String? gPhone) => this.gPhone = gPhone;

  String? get getGEmail => gEmail;
  set setGEmail(String? gEmail) => this.gEmail = gEmail;

  String? get getStdImg => stdImg;
  set setStdImg(String? stdImg) => this.stdImg = stdImg;

  String? get getMajor => major;
  set setMajor(String? major) => this.major = major;

  String? get getSMajor => sMajor;
  set setSMajor(String? sMajor) => this.sMajor = sMajor;

  String? get getStdPass => stdPass;
  set setStdPass(String? stdPass) => this.stdPass = stdPass;

  String? get getGender => gender;
  set setGender(String? gender) => this.gender = gender;

  String? get getAddDate => addDate;
  set setAddDate(String? addDate) => this.addDate = addDate;

  int? get getAStatus => aStatus;
  set setAStatus(int? aStatus) => this.aStatus = aStatus;

  Uint8List? get getImgData => imgData;
  set setImgData(Uint8List? imgData) => this.imgData = imgData;

  String? get getSyncKey => syncKey;
  set setSyncKey(String? syncKey) => this.syncKey = syncKey;

  int get getSyncStatus => syncStatus;
  set setSyncStatus(int syncStatus) => this.syncStatus = syncStatus;

  String? get getUniqueId => uniqueId;
  set setUniqueId(String? uniqueId) => this.uniqueId = uniqueId;

  String? get getCurrSessId => currSessId;
  set setCurrSessId(String? currSessId) => this.currSessId = currSessId;

  // Map to Object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'program': program,
      'studentId': studentId,
      'uId': uId,
      'sId': sId,
      'stdId': stdId,
      'stdName': stdName,
      'stdPhone': stdPhone,
      'stdEmail': stdEmail,
      'homePhone': homePhone,
      'stdReligion': stdReligion,
      'address': address,
      'dob': dob,
      'nidBirth': nidBirth,
      'country': country,
      'unionWord': unionWord,
      'fatherName': fatherName,
      'motherName': motherName,
      'fNid': fNid,
      'mNid': mNid,
      'gName': gName,
      'gAddress': gAddress,
      'gPhone': gPhone,
      'gEmail': gEmail,
      'stdImg': stdImg,
      'major': major,
      'sMajor': sMajor,
      'stdPass': stdPass,
      'gender': gender,
      'addDate': addDate,
      'aStatus': aStatus,
      'imgData': imgData,
      'syncKey': syncKey,
      'syncStatus': syncStatus,
      'uniqueId': uniqueId,
      'currSessId': currSessId,
    };
  }

  // Object from Map
  static Student fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      program: map['program'],
      studentId: map['studentId'],
      uId: map['uId'],
      sId: map['sId'],
      stdId: map['stdId'],
      stdName: map['stdName'],
      stdPhone: map['stdPhone'],
      stdEmail: map['stdEmail'],
      homePhone: map['homePhone'],
      stdReligion: map['stdReligion'],
      address: map['address'],
      dob: map['dob'],
      nidBirth: map['nidBirth'],
      country: map['country'],
      unionWord: map['unionWord'],
      fatherName: map['fatherName'],
      motherName: map['motherName'],
      fNid: map['fNid'],
      mNid: map['mNid'],
      gName: map['gName'],
      gAddress: map['gAddress'],
      gPhone: map['gPhone'],
      gEmail: map['gEmail'],
      stdImg: map['stdImg'],
      major: map['major'],
      sMajor: map['sMajor'],
      stdPass: map['stdPass'],
      gender: map['gender'],
      addDate: map['addDate'],
      aStatus: map['aStatus'],
      imgData: map['imgData'],
      syncKey: map['syncKey'],
      syncStatus: map['syncStatus'],
      uniqueId: map['uniqueId'],
      currSessId: map['currSessId'],
    );
  }

  // Generate Admission Date
  String generateAdmissionDate() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  @override
  String toString() {
    return stdName ?? '';
  }
}
