import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData actionIcon;
  final VoidCallback onActionPressed;
  final Color appBarbgColor;

  const ProfileAppBar({
    Key? key,
    required this.title,
    required this.actionIcon,
    required this.onActionPressed, required this.appBarbgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(title),
      backgroundColor: appBarbgColor,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(actionIcon),
          onPressed: onActionPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
