import 'package:class_organizer/admin/school/schedule/schedule_7_screen.dart';
import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
class ScheduleCards extends StatelessWidget {
  final ScheduleItem scheduleItem;

  const ScheduleCards({
    Key? key, required this.scheduleItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Title and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   scheduleItem.subCode??"",
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Colors.black,
                //   ),
                // ),
                Text(
                  scheduleItem.subCode ?? "",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        scheduleItem.startTime ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Subtitle (e.g., "320_1")
            // Text(
            //   scheduleItem.subName??"",
            //   style: TextStyle(
            //     fontSize: 17,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            Text(
              scheduleItem.subName ?? "",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface, // Adapts to light/dark mode
              ),
            ),

            Divider(
              thickness: 1,
              color: Colors.blue[800],
            ),
            SizedBox(height: 8),

            // Teacher and Room information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Teacher",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    // Text(
                    //   scheduleItem.tName??"",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      scheduleItem.tName ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface, // Adapts to light/dark mode
                      ),
                    ),
                    // Text(
                    //   scheduleItem.tName ?? "",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //     color: Theme.of(context).brightness == Brightness.dark
                    //         ? Colors.white // Use white in dark mode
                    //         : Colors.black, // Use black in light mode
                    //   ),
                    // ),

                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Room",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    // Text(
                    //   scheduleItem.room??"",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      scheduleItem.room ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface, // Theme-aware color
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
