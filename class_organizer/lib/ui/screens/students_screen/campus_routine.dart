import 'package:class_organizer/utility/profile_app_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/drawer_widget.dart';

class CampusRoutine extends StatelessWidget {
  const CampusRoutine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileAppBar(
          title: 'Campus Schedules',
          actionIcon: Icons.more_vert,
          onActionPressed: () {  },
          appBarbgColor: Color(0xFF40C4FF),
        ),
      drawer: const DrawerWidget(),
      );
  }
}
