import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/class_model.dart';

class ClassController extends GetxController {
  var classes = <String, List<Class>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  Future<void> loadClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? classListJson = prefs.getString('classList');
    if (classListJson != null) {
      Map<String, dynamic> classListMap = json.decode(classListJson);
      classListMap.forEach((key, value) {
        classes[key] = (value as List).map((classMap) => Class.fromMap(classMap)).toList();
      });
    }
  }

  Future<void> saveClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final String classListJson = json.encode(classes.map((key, value) => MapEntry(key, value.map((classItem) => classItem.toMap()).toList())));
    await prefs.setString('classList', classListJson);
  }

  void addClass(Class newClass) {
    if (classes[newClass.day] == null) {
      classes[newClass.day] = [];
    }
    classes[newClass.day]?.add(newClass);
    saveClasses();

    // Debugging: Print the updated class list for the day
    print('Class added to ${newClass.day}: ${classes[newClass.day]}');
    update(); // Notify UI
  }

  void removeClass(Class classToRemove) {
    classes[classToRemove.day]?.remove(classToRemove);

    // Debugging: Print the updated class list after removal
    print('Class removed from ${classToRemove.day}: ${classes[classToRemove.day]}');

    if (classes[classToRemove.day]?.isEmpty ?? true) {
      classes.remove(classToRemove.day); // Remove the day entry if no classes remain
    }

    saveClasses(); // Save after removal
    update(); // Notify UI immediately
  }
}
