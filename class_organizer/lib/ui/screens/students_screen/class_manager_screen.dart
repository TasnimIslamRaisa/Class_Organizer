import 'package:flutter/material.dart';

import '../../../utility/profile_app_bar.dart';
import '../../widgets/drawer_widget.dart';

class ClassManagerScreen extends StatelessWidget {
  const ClassManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: 'Class Manager',
        actionIcon: Icons.more_vert,
        onActionPressed: () {  },
        appBarbgColor: const Color(0xFF00B0FF),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
