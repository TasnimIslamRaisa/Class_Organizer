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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accessing subName from ScheduleItem
            Text(
              widget.schedule.subName ?? 'Unknown Subject',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  // Accessing startTime and endTime from ScheduleItem
                  '${widget.schedule.startTime ?? 'N/A'} - ${widget.schedule.endTime ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                // Accessing tName from ScheduleItem
                Text(
                  widget.schedule.tName ?? 'Unknown Teacher',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.room, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                // Accessing room from ScheduleItem
                Text(
                  widget.schedule.room ?? 'Unknown Room',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Add your detail view logic here
                },
                child: const Text('DETAILS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
