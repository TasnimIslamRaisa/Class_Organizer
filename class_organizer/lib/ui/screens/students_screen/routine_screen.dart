import 'package:class_organizer/utility/profile_app_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/drawer_widget.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileAppBar(
          title: 'Routine',
          actionIcon: Icons.more_vert,
          onActionPressed: () {  },
          appBarbgColor: Color(0xFF40C4FF),
        ),
      drawer: const DrawerWidget(),
      );
  }
}
