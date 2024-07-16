import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/u_data.dart';

class UDataProvider with ChangeNotifier {
  List<UData> _uDataList = [];

  List<UData> get uDataList => _uDataList;

  Future<void> fetchUData() async {
    _uDataList = await DatabaseHelper().getUData();
    notifyListeners();
  }

  Future<void> addUData(UData uData) async {
    await DatabaseHelper().insertUData(uData);
    fetchUData();
  }

  Future<void> updateUData(UData uData) async {
    await DatabaseHelper().updateUData(uData);
    fetchUData();
  }

  Future<void> deleteUData(int id) async {
    await DatabaseHelper().deleteUData(id);
    fetchUData();
  }

  Future<UData?> getUDataById(int id) async {
    return await DatabaseHelper().getUDataById(id);
  }
}
