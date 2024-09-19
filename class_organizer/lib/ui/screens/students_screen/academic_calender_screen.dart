import 'package:flutter/material.dart';
import '../../../utility/profile_app_bar.dart';
import '../../widgets/drawer_widget.dart';

class AcademicCalender extends StatelessWidget {
  const AcademicCalender({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data for dates and events
    final List<Map<String, String>> academicEvents = [
      {
        "date": "01",
        "month": "Sep",
        "event": "Start of Classes",
        "day": "Saturday"
      },
      {
        "date": "15",
        "month": "Sep",
        "event": "Independence Day",
        "day": "Sunday"
      },
      {
        "date": "22",
        "month": "Sep",
        "event": "Faculty Meeting",
        "day": "Friday"
      },
      {"date": "01", "month": "Oct", "event": "Midterm Exams", "day": "Monday"},
      {
        "date": "25",
        "month": "Dec",
        "event": "Christmas Holiday",
        "day": "Wednesday"
      },
      {
        "date": "05",
        "month": "Jan",
        "event": "End of Semester",
        "day": "Friday"
      },
      {
        "date": "10",
        "month": "Feb",
        "event": "New Semester Begins",
        "day": "Monday"
      },
      {
        "date": "21",
        "month": "Feb",
        "event": "International Mother Language Day",
        "day": "Wednesday"
      },
      {
        "date": "07",
        "month": "Mar",
        "event": "Spring Break",
        "day": "Thursday"
      },
      {"date": "14", "month": "Mar", "event": "Sports Day", "day": "Saturday"},
    ];

    return Scaffold(
      appBar: ProfileAppBar(
        title: 'Academic Calendar',
        actionIcon: Icons.more_vert,
        onActionPressed: () {},
        appBarbgColor: const Color(0xFF80D8FF),
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Stack(
            children: [
              // Vertical divider with continuous line
              Positioned(
                left: MediaQuery.of(context).size.width *
                    0.32, // Align the line between date and event
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Colors.grey.shade400, // Continuous divider color
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Column
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.25, // Fixed width for the date
                      child: Center(
                        child: Text(
                          "Dates",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    // Dot on the divider line
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 6, left: 8), // Align dots vertically
                      child: Container(
                        width: 10,
                        height: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Event Column
                    Expanded(
                      child: Text(
                        "Events",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //const Divider(), // A divider for better visual separation
          Expanded(
            child: ListView.builder(
              itemCount: academicEvents.length,
              itemBuilder: (context, index) {
                final event = academicEvents[index];
                return Stack(
                  children: [
                    // Vertical divider with continuous line
                    Positioned(
                      left: MediaQuery.of(context).size.width *
                          0.32, // Align the line between date and event
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 1,
                        color: Colors.grey, // Continuous divider color
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Column
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.25, // Fixed width for the date
                            child: Column(
                              children: [
                                Text(
                                  event['date']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  event['month']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Dot on the divider line
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 6, left: 8), // Align dots vertically
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Event Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['day']!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                                Text(
                                  event['event']!,
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
