
import 'package:flutter/material.dart';

import '../../style/app_color.dart';
import '../screens/students_screen/edit_profile_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(

            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Center(
                child: Icon(Icons.person_pin_circle_sharp,
                  size: 85,)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('U S E R N A M E'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('P H O N E'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('E M A I L'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('B L A C K B O X'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('P R O F I L E'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text('B L O O D B A N K'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('N O T E S & T A S K S'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page_outlined),
            title: const Text('R O U T I N E S'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bus_alert_rounded),
            title: const Text('B U S - S C H E D U L E S'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('ACADEMIC - C A L E N D E R'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add_outlined),
            title: const Text('N O T I C E & E V E N T S'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.laptop_chromebook_rounded),
            title: const Text('C L U B-M A N A G E M E N T'),
            onTap: () {
              // Navigate to settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('L O G O U T'),
            onTap: () {
              // Navigate to contacts
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}