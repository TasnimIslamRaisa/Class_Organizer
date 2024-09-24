import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatefulWidget {
  final ScheduleItem schedule; // Change from Schedule to ScheduleItem

  const ScheduleCard({required this.schedule, Key? key}) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Title and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   widget.schedule.subName ?? 'Unknown Subject',
                //   style: const TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
                Text(
                  widget.schedule.subName ?? 'Unknown Subject',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface, // Adapts to light/dark mode
                  ),
                ),

                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: Colors.redAccent,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Row(
                //     children: [
                //       const Icon(
                //         Icons.access_time,
                //         size: 16,
                //         color: Colors.white,
                //       ),
                //       const SizedBox(width: 4),
                //       Text(
                //         '${widget.schedule.startTime ?? 'N/A'} - ${widget.schedule.endTime ?? 'N/A'}',
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 8),

            // Subtitle (subCode and section)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   '${widget.schedule.subCode ?? 'Unknown'} . ${widget.schedule.section ?? ''}',
                //   style: const TextStyle(
                //     fontSize: 18,
                //     color: Colors.black,
                //   ),
                // ),
                Text(
                  '${widget.schedule.subCode ?? 'Unknown'} . ${widget.schedule.section ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface, // Adapts to light/dark mode
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.schedule.startTime ?? 'N/A'} - ${widget.schedule.endTime ?? 'N/A'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(
              thickness: 1,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 8),

            // Teacher and Room information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Teacher",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    // Text(
                    //   widget.schedule.tName ?? 'Unknown Teacher',
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      widget.schedule.tName ?? 'Unknown Teacher',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface, // Adapts to light/dark mode
                      ),
                    ),

                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Room",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    // Text(
                    //   widget.schedule.room ?? 'Unknown Room',
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      widget.schedule.room ?? 'Unknown Room',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface, // Adapts to light/dark mode
                      ),
                    ),

                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Bottom section: Details and icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Add your detail view logic here
                  },
                  child: const Text(
                    "DETAILS",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Add notification logic here
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Add more options logic here
                      },
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
