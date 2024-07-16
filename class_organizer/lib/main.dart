import 'package:flutter/material.dart';

import 'class_organizer_app.dart';
import 'db/database_manager.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final dbManager = DatabaseManager();

  // // Open the database
  // final db = await dbManager.database;
  runApp(const ClassOrganizerApp());
}
