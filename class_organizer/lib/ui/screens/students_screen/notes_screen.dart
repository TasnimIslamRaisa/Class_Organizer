import 'package:class_organizer/utility/profile_app_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/drawer_widget.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: 'Notes',
        actionIcon: Icons.more_vert,
        onActionPressed: () {  },
        appBarbgColor: Color(0xFF80D8FF),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
