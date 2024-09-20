import 'package:class_organizer/utility/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../../models/class_model.dart';
import '../../../utility/profile_app_bar.dart';
import '../../widgets/drawer_widget.dart';
import '../controller/class_routine_controller.dart';
import '../seven_days_content/monday_content.dart';
import '../seven_days_content/tuesday_content.dart';
import '../seven_days_content/wednesday_content.dart';
import '../seven_days_content/thursday_content.dart';
import '../seven_days_content/friday_content.dart';
import '../seven_days_content/saturday_content.dart';
import '../seven_days_content/sunday_content.dart';
import 'add_class_screen.dart';

class ClassManagerScreen extends StatelessWidget {
  final ClassController classController = Get.put(ClassController());

  void _deleteClass(Class classToDelete) {
    classController.removeClass(classToDelete);
    // Notify listeners
  }
  void _addClass(Class newClass) {
    classController.addClass(newClass);  // Immediately add class
  }

  ClassManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Number of days in the week
      child: Scaffold(
        appBar: ProfileAppBar(
          title: 'Class Schedule',
          actionIcon: Icons.more_vert,
          onActionPressed: () {  },
          appBarbgColor: Colors.blue,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            dividerColor: Colors.blue,
            tabs: [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
              Tab(text: 'Sun'),
            ],
          ),
        ),
        drawer: const DrawerWidget(),
        body: Obx(() {
          final classes = classController.classes;  // This is where the observable variable is accessed
          print('Current classes: $classes');
          return TabBarView(
            children: [
              MondayContent(classes: classes['Monday'] ?? [], onDeleteClass:_deleteClass,),
              TuesdayContent(classes: classes['Tuesday'] ?? [], onDeleteClass: _deleteClass,),
              WednesdayContent(classes: classes['Wednesday'] ?? [], onDeleteClass: _deleteClass,),
              ThursdayContent(classes: classes['Thursday'] ?? [], onDeleteClass: _deleteClass,),
              FridayContent(classes: classes['Friday'] ?? [],onDeleteClass: _deleteClass),
              SaturdayContent(classes: classes['Saturday'] ?? [], onDeleteClass:_deleteClass,),
              SundayContent(classes: classes['Sunday'] ?? [], onDeleteClass:_deleteClass,),
            ],
          );
        }),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add Class',
              onTap: () {
                _showAddClassBottomSheet(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.edit),
              label: 'Edit Class',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (contex) => ScannerScreen()),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _showAddClassBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddClassBottomSheet(
          onAddClass: (Class newClass) {
            _addClass(newClass);  // Add class when the bottom sheet is closed
            Navigator.pop(context);  // Close bottom sheet
          },
        );
      },
    );
  }
}
