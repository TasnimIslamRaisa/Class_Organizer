import 'package:flutter/material.dart';

import '../ui/screens/auth/SignInScreen.dart';
import '../ui/screens/students_screen/edit_profile_screen.dart';
import '../ui/screens/students_screen/settings_screen.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData actionIcon;
  final VoidCallback onActionPressed;
  final Color appBarbgColor;
  final PreferredSizeWidget? bottom; // Optional bottom

  const ProfileAppBar({
    Key? key,
    required this.title,
    required this.actionIcon,
    required this.onActionPressed, required this.appBarbgColor, this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(title),
      backgroundColor: appBarbgColor,
      foregroundColor: Colors.white,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
                break;
              case 'settings':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()));
                break;
              case 'logout':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Settings'),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
          icon: const Icon(Icons.more_vert), // Options icon
        ),
      ],
      bottom: bottom,
    );
  }
  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}