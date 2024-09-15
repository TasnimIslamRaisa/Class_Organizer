import 'package:class_organizer/onboarding/get_start.dart';
import 'package:flutter/material.dart';

import '../preference/logout.dart';
import '../ui/screens/auth/SignInScreen.dart';
import '../ui/screens/students_screen/edit_profile_screen.dart';
import '../ui/screens/students_screen/settings_screen.dart';

class ProfileAppBarAdmin extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData actionIcon;
  final VoidCallback onActionPressed;
  final Color appBarbgColor;
  final PreferredSizeWidget? bottom; // Optional bottom

  const ProfileAppBarAdmin({
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
          onSelected: (value) async {
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
              case 'restart':

              await Logout().logoutUser();
              await Logout().clearUser(key: "user_logged_in");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetStart(),
                  ),
                );
                break;  
              case 'logout':

              await Logout().logoutUser();
              await Logout().clearUser(key: "user_logged_in");

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
              value: 'restart',
              child: Text('Restart'),
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