import 'package:flutter/material.dart';
import '../../../models/class_model.dart';
import '../../widgets/slidable_widget.dart';

class MondayContent extends StatelessWidget {
  final List<Class> classes;
  final void Function(Class) onDeleteClass;

  const MondayContent({super.key, required this.classes, required this.onDeleteClass});

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
