import 'package:class_organizer/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../models/class_model.dart';
import '../../../utility/confirmationDialog.dart';

class SlidableClassItem extends StatelessWidget {
  final ScheduleItem classItem;
  final void Function(ScheduleItem) onDeleteClass;

  const SlidableClassItem({
    Key? key,
    required this.classItem,
    required this.onDeleteClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Slidable(
      key: classItem.subCode != null ? Key(classItem.subCode!) : null,
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialog(context, classItem, onDeleteClass,'delete');
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              showConfirmationDialog(context, classItem, onDeleteClass,'edit');
            },
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Card(
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
                  Text(
                    classItem.subName ?? 'Unknown Subject',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                  //         '${classItem.startTime ?? 'N/A'} - ${classItem.endTime ?? 'N/A'}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${classItem.subCode ?? 'Unknown'} . ${classItem.section ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
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
                          '${classItem.startTime ?? 'N/A'} - ${classItem.endTime ?? 'N/A'}',
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
              // Subtitle (subCode and section)

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
                      Text(
                        classItem.tName ?? 'Unknown Teacher',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                      Text(
                        classItem.room ?? 'Unknown Room',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
      ),

      // child: Padding(
      //   padding: const EdgeInsets.only(bottom: 12.0),
      //   child: Container(
      //     padding: const EdgeInsets.all(12),
      //     decoration: BoxDecoration(
      //       // Colors.blueGrey[50]   Colors.blueGrey[600]
      //       color:isLightMode ? Colors.blueGrey[50] : Colors.blueGrey[600],
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(right: 16),
      //           child: Icon(
      //             Icons.book,
      //             color: Colors.blueAccent,
      //             size: 40,
      //           ),
      //         ),
      //         Expanded(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 classItem.subName??"",
      //                 style: const TextStyle(
      //                   fontSize: 16,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               const SizedBox(height: 4),
      //               Text(
      //                 classItem.subCode??"",
      //                 style: const TextStyle(
      //                   fontSize: 14,
      //                   color: Colors.black54,
      //                 ),
      //               ),
      //               const SizedBox(height: 8),
      //               Row(
      //                 children: [
      //                   Text(
      //                     'Teacher Initial: ${classItem.tName}',
      //                     style: const TextStyle(fontSize: 14),
      //                   ),
      //                   const SizedBox(width: 10),
      //                   Text(
      //                     'Section: ${classItem.section}',
      //                     style: const TextStyle(fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //               const SizedBox(height: 8),
      //               Row(
      //                 children: [
      //                   const Icon(
      //                     Icons.access_time,
      //                     size: 16,
      //                     color: Colors.grey,
      //                   ),
      //                   const SizedBox(width: 4),
      //                   Text(
      //                     '${classItem.startTime} - ${classItem.endTime}',
      //                     style: const TextStyle(fontSize: 14),
      //                   ),
      //                   const SizedBox(width: 10),
      //                   const Icon(
      //                     Icons.class_,
      //                     size: 16,
      //                     color: Colors.grey,
      //                   ),
      //                   const SizedBox(width: 4),
      //                   Text(
      //                     classItem.room??"",
      //                     style: const TextStyle(fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
