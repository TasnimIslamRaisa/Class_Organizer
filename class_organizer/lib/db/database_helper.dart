import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';
import '../models/user.dart';
import '../models/u_data.dart';
import '../models/school.dart';
import '../models/admin.dart';

class DatabaseHelper {
  Future<int> insertUser(User user) async {
    Database db = await DatabaseManager().database;
    return await db.insert('User', user.toMap());
  }

  Future<int> updateUser(User user) async {
    Database db = await DatabaseManager().database;
    return await db.update('User', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await DatabaseManager().database;
    return await db.delete('User', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<User>> getUsers() async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('User');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserById(int id) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('User', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

    Future<User?> getUserByPhone(String id) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('User', where: 'phone = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> checkUserByPhone(String phone, String pass) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('User', where: 'phone = ? OR email = ? AND pass = ?', whereArgs: [phone,phone,pass]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertUData(UData uData) async {
    Database db = await DatabaseManager().database;
    return await db.insert('Udata', uData.toMap());
  }

  Future<int> updateUData(UData uData) async {
    Database db = await DatabaseManager().database;
    return await db.update('Udata', uData.toMap(), where: 'id = ?', whereArgs: [uData.id]);
  }

  Future<int> deleteUData(int id) async {
    Database db = await DatabaseManager().database;
    return await db.delete('Udata', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<UData>> getUData() async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('Udata');
    return List.generate(maps.length, (i) {
      return UData.fromMap(maps[i]);
    });
  }

  Future<UData?> getUDataById(int id) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('Udata', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UData.fromMap(maps.first);
    }
    return null;
  }

    Future<UData?> getUDataByPhone(String phone) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('Udata', where: 'phone = ?', whereArgs: [phone]);
    if (maps.isNotEmpty) {
      return UData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertSchool(School school) async {
    Database db = await DatabaseManager().database;
    return await db.insert('school', school.toMap());
  }

  Future<int> updateSchool(School school) async {
    Database db = await DatabaseManager().database;
    return await db.update('school', school.toMap(), where: 'id = ?', whereArgs: [school.id]);
  }

  Future<int> deleteSchool(int id) async {
    Database db = await DatabaseManager().database;
    return await db.delete('school', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<School>> getSchools() async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('school');
    return List.generate(maps.length, (i) {
      return School.fromMap(maps[i]);
    });
  }

  Future<School?> getSchoolById(int id) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('school', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return School.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertAdmin(Admin admin) async {
    Database db = await DatabaseManager().database;
    return await db.insert('admin', admin.toMap());
  }

  Future<int> updateAdmin(Admin admin) async {
    Database db = await DatabaseManager().database;
    return await db.update('admin', admin.toMap(), where: 'id = ?', whereArgs: [admin.id]);
  }

  Future<int> deleteAdmin(int id) async {
    Database db = await DatabaseManager().database;
    return await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Admin>> getAdmins() async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('admin');
    return List.generate(maps.length, (i) {
      return Admin.fromMap(maps[i]);
    });
  }

  Future<Admin?> getAdminById(int id) async {
    Database db = await DatabaseManager().database;
    List<Map<String, dynamic>> maps = await db.query('admin', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Admin.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUserUDataSchool() async {
    Database db = await DatabaseManager().database;
    String sql = '''
      SELECT user.id AS user_id, user.uname, user.email, user.pass,
             u_data.id AS udata_id, u_data.uid, u_data.sid, u_data.fname, u_data.lname, u_data.phone, u_data.address,
             school.id AS school_id, school.eiin, school.semail, school.sname, school.saddress, school.sphone
      FROM user
      INNER JOIN u_data ON user.id = u_data.uid
      INNER JOIN school ON u_data.sid = school.id
    ''';
    List<Map<String, dynamic>> result = await db.rawQuery(sql);
    return result;
  }
}
