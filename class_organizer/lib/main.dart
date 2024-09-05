import 'package:class_organizer/style/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'class_organizer_app.dart';
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final dbManager = DatabaseManager();

  // // Open the database
  // final db = await dbManager.database;
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child:const ClassOrganizerApp(),
  ),
  );
}