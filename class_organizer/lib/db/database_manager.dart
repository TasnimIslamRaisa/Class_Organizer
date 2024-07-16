import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_table.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;

  static Database? _database;

  DatabaseManager._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'class_organizer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseTable.ROOMS);
    await db.execute(DatabaseTable.CAMPUS);
    await db.execute(DatabaseTable.ADMIN);
    await db.execute(DatabaseTable.USER);
    await db.execute(DatabaseTable.UDATA);
    await db.execute(DatabaseTable.USERS);
    await db.execute(DatabaseTable.A_YEAR);
    await db.execute(DatabaseTable.SECTIONS);
    await db.execute(DatabaseTable.SCHOOL);
    await db.execute(DatabaseTable.MAJOR);
    await db.execute(DatabaseTable.STUDENTS);
    await db.execute(DatabaseTable.SUBJECT);
    await db.execute(DatabaseTable.SUB_ON_SEC);
    await db.execute(DatabaseTable.SUB_ASSIGNED);
    await db.execute(DatabaseTable.SEC_ASSIGNED);
    await db.execute(DatabaseTable.TEACHER);
    await db.execute(DatabaseTable.ATTENDANCE_SHEET);
    await db.execute(DatabaseTable.PAYMENT);
    await db.execute(DatabaseTable.FEE_TYPE);
    await db.execute(DatabaseTable.MAIL);
    await db.execute(DatabaseTable.FEE);
    await db.execute(DatabaseTable.CLASSES);
    await db.execute(DatabaseTable.ALL_SUBJECTS);
    await db.execute(DatabaseTable.CLASS_SCHEDULE);
    await db.execute(DatabaseTable.SCHEDULE);
    await db.execute(DatabaseTable.TASK);
    await db.execute(DatabaseTable.NOTE);
    await db.execute(DatabaseTable.CALENDAR);
    await db.execute(DatabaseTable.ROUTINE);

    print("Database Created Successfully! Welcome to EdUBox!");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrade logic here
    if (oldVersion < 2) {
      // For example, adding a new column to an existing table in version 2
      // await db.execute('''
      //   ALTER TABLE user ADD COLUMN last_login TEXT
      // ''');
    }
    if (oldVersion < 3) {
      // Further upgrades for version 3
      // await db.execute('''
      //   ALTER TABLE u_data ADD COLUMN dob TEXT
      // ''');
    }
    // Add more conditions as needed for future upgrades
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
    _database = null;
  }

  Future<void> openDb() async {
    await database;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> getDb() async {
    return await database;
  }
}
