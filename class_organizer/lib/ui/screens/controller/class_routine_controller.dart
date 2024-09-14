import 'package:get/get.dart';
import '../../../models/class_model.dart';

class ClassController extends GetxController {
  var classes = <String, List<Class>>{}.obs;

  void addClass(Class newClass) {
    if (classes[newClass.day] == null) {
      classes[newClass.day] = [];
    }
    classes[newClass.day]?.add(newClass);

    // Debugging: Print the updated class list for the day
    print('Class added to ${newClass.day}: ${classes[newClass.day]}');
    update(); // Notify UI
  }

  void removeClass(Class classToRemove) {
    classes[classToRemove.day]?.remove(classToRemove);

    // Debugging: Print the updated class list after removal
    print('Class removed from ${classToRemove.day}: ${classes[classToRemove.day]}');

    if (classes[classToRemove.day]?.isEmpty ?? true) {
      classes[classToRemove.day] = [];
    }

    update(); // Notify UI immediately
  }
}
