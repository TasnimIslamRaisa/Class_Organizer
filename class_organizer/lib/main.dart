import 'package:class_organizer/ui/screens/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'class_organizer_app.dart';
import 'db/database_manager.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbManager = DatabaseManager();

  // // Open the database
  final db = await dbManager.database;
  Get.put(ThemeController());
  runApp(const ClassOrganizerApp(),);
}