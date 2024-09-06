import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utility/profile_app_bar.dart';
import '../controller/theme_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeController
    final ThemeController themeController = Get.find<ThemeController>();
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
              ),
            ),
            // Dark Mode Switch using GetX
            Obx(() => CupertinoSwitch(
              value: themeController.isDarkMode,  // Get the dark mode status
              onChanged: (value) {
                themeController.toggleTheme();  // Toggle theme on switch change
              },
            )),
          ],
        ),
      ),
    );
  }
}
