import 'package:class_organizer/ui/screens/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'class_organizer_app.dart';
import 'db/database_manager.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbManager = DatabaseManager();

 // Open the databaseq
  final db = await dbManager.database;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(ThemeController());
  runApp(const ClassOrganizerApp(),);
}