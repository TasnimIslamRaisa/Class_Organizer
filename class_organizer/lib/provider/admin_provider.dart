import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/admin.dart';

class AdminProvider with ChangeNotifier {
  List<Admin> _admins = [];

  List<Admin> get admins => _admins;

  Future<void> fetchAdmins() async {
    _admins = await DatabaseHelper().getAdmins();
    notifyListeners();
  }

  Future<void> addAdmin(Admin admin) async {
    await DatabaseHelper().insertAdmin(admin);
    fetchAdmins();
  }

  Future<void> updateAdmin(Admin admin) async {
    await DatabaseHelper().updateAdmin(admin);
    fetchAdmins();
  }

  Future<void> deleteAdmin(int id) async {
    await DatabaseHelper().deleteAdmin(id);
    fetchAdmins();
  }

  Future<Admin?> getAdminById(int id) async {
    return await DatabaseHelper().getAdminById(id);
  }
}
