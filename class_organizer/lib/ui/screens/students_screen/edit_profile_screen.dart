import 'package:class_organizer/ui/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import '../../../utility/profile_app_bar.dart';
import '../../widgets/drawer_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: 'Edit Profile',
        actionIcon: Icons.more_vert,
        onActionPressed: () {  },
        appBarbgColor: Colors.cyan,
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: BackgroundWidget(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture with Camera Icon
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
        
                  // Name TextField
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // University TextField
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'University',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // Department Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Department',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: const [
                      DropdownMenuItem(value: 'CSE', child: Text('CSE')),
                      DropdownMenuItem(value: 'EEE', child: Text('EEE')),
                      DropdownMenuItem(value: 'BBA', child: Text('BBA')),
                      // Add more departments as needed
                    ],
                    onChanged: (value) {
                      // Handle department selection
                    },
                  ),
                  const SizedBox(height: 16),
        
                  // Semester Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: const [
                      DropdownMenuItem(value: '1st', child: Text('1st')),
                      DropdownMenuItem(value: '2nd', child: Text('2nd')),
                      DropdownMenuItem(value: '3rd', child: Text('3rd')),
                      DropdownMenuItem(value: '4th', child: Text('4th')),
                      DropdownMenuItem(value: '5th', child: Text('5th')),
                      DropdownMenuItem(value: '6th', child: Text('6th')),
                      DropdownMenuItem(value: '7th', child: Text('7th')),
                      DropdownMenuItem(value: '8th', child: Text('8th')),
                      DropdownMenuItem(value: '9th', child: Text('9th')),
                      DropdownMenuItem(value: '10th', child: Text('10th')),
                      DropdownMenuItem(value: '11th', child: Text('11th')),
                      DropdownMenuItem(value: '12th', child: Text('12th')),
                      // Add more semesters as needed
                    ],
                    onChanged: (value) {
                      // Handle semester selection
                    },
                  ),
                  const SizedBox(height: 16),
        
                  // CGPA TextField
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'CGPA',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // Credits TextField
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Credits Completed',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 24),
        
                  // Notes with Dots
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• Ensure all information is correct."),
                        SizedBox(height: 4),
                        Text("• Update your profile picture."),
                        SizedBox(height: 4),
                        Text("• Verify CGPA and credits."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Stack to position Floating Action Buttons
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[500],
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: () {
                // Handle save action
              },
              heroTag: null,
              child: const Icon(Icons.settings), // Prevents hero tag conflicts
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: () {
                // Handle other action
              },
              heroTag: null,
              child: const Icon(Icons.check), // Prevents hero tag conflicts
            ),
          ),
        ],
      ),
    );
  }
}
