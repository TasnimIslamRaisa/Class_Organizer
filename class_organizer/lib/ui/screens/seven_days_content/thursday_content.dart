import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../models/class_model.dart';
import '../../../utility/confirmationDialog.dart';
import '../../widgets/slidable_widget.dart';
import '../controller/class_routine_controller.dart';

class ThursdayContent extends StatelessWidget {
  final List<ScheduleItem> classes;
  final void Function(ScheduleItem) onDeleteClass;

  const ThursdayContent({super.key, required this.classes, required this.onDeleteClass,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classItem = classes[index];
            return SlidableClassItem(
              classItem: classItem,
              onDeleteClass: onDeleteClass,
            );
          },
        ),
      ),
    );
  }
}
