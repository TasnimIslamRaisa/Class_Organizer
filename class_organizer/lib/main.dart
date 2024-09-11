import 'package:class_organizer/ui/screens/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import 'class_organizer_app.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final dbManager = DatabaseManager();

  // // Open the database
  // final db = await dbManager.database;
  Get.put(ThemeController());
  runApp(const ClassOrganizerApp(),);
}