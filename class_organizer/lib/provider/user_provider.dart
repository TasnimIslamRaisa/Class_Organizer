import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    _users = await DatabaseHelper().getUsers();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await DatabaseHelper().insertUser(user);
    fetchUsers();
  }

  Future<void> updateUser(User user) async {
    await DatabaseHelper().updateUser(user);
    fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await DatabaseHelper().deleteUser(id);
    fetchUsers();
  }

  Future<User?> getUserById(int id) async {
    return await DatabaseHelper().getUserById(id);
  }
}
