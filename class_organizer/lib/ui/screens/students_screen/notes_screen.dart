import 'package:flutter/material.dart';
import '../../../utility/profile_app_bar.dart';
import '../../widgets/drawer_widget.dart';

class AcademicCalender extends StatelessWidget {
  const AcademicCalender({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data for dates and events
    final List<Map<String, String>> academicEvents = [
      {"date": "01", "month": " Sep", "event": "Start of Classes"},
      {"date": "15", "month": " Sep", "event": "Independence Day"},
      {"date": "22", "month": " Sep", "event": "Faculty Meeting"},
      {"date": "01", "month": " Oct", "event": "Midterm Exams"},
      {"date": "25", "month": " Dec", "event": "Christmas Holiday"},
    ];

    return Scaffold(
      appBar: ProfileAppBar(
        title: 'Academic Calendar',
        actionIcon: Icons.more_vert,
        onActionPressed: () {},
        appBarbgColor: const Color(0xFF80D8FF),
      ),
      drawer: const DrawerWidget(),
      body: ListView.builder(
        itemCount: academicEvents.length,
        itemBuilder: (context, index) {
          final event = academicEvents[index];
          return Stack(
            children: [
              // Vertical divider with continuous line
              Positioned(
                left: MediaQuery.of(context).size.width * 0.32, // Align the line between date and event
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Colors.grey, // Continuous divider color
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Column
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25, // Fixed width for the date
                      child: Column(
                        children: [
                          Text(
                            event['date']!,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            event['month']!,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // Dot on the divider line
                    Padding(
                      padding: const EdgeInsets.only(top: 6), // Align dots vertically
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Event Column
                    Expanded(
                      child: Text(
                        event['event']!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
