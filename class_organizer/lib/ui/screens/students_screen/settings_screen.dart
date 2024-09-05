import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../style/themes/theme_provider.dart';
import '../../../utility/profile_app_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar:  ProfileAppBar(
        title: 'S E T T I N G S',
        actionIcon: Icons.more_vert,
        onActionPressed: () {  },
        appBarbgColor: const Color(0xFF00B0FF),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //dark mode
            const Text("Dark Mode",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            //switch
            CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context,listen: false).isDarkMode,
                onChanged: (value){
                  Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
                }),

          ],
        ),
      ),
    );
  }
}
