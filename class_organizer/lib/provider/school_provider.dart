import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/school.dart';

class SchoolProvider with ChangeNotifier {
  List<School> _schools = [];

  List<School> get schools => _schools;

  Future<void> fetchSchools() async {
    _schools = await DatabaseHelper().getSchools();
    notifyListeners();
  }

  Future<void> addSchool(School school) async {
    await DatabaseHelper().insertSchool(school);
    fetchSchools();
  }

  Future<void> updateSchool(School school) async {
    await DatabaseHelper().updateSchool(school);
    fetchSchools();
  }

  Future<void> deleteSchool(int id) async {
    await DatabaseHelper().deleteSchool(id);
    fetchSchools();
  }

  Future<School?> getSchoolById(int id) async {
    return await DatabaseHelper().getSchoolById(id);
  }
}
