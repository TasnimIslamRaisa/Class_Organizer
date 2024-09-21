// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Routine and Schedule'),
//     ),
//     body: isLoading
//         ? Center(child: CircularProgressIndicator())
//         : Column(
//       children: [
//         // Top Routine Card
//         Card(
//           color: Colors.redAccent,
//           margin: EdgeInsets.all(8),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Save this Routine on Schedule List!',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Routine Name: ${routine?.tempName ?? ''}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 Text(
//                   'Routine Details: ${routine?.tempDetails ?? ''}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Add save all functionality here
//                       },
//                       child: Text('SAVE ALL'),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Add save individual routine functionality here
//                       },
//                       child: Text('SAVE'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // Search Bar
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             decoration: InputDecoration(
//               labelText: 'Search...',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.search),
//             ),
//             onChanged: (value) {
//               // Add search functionality based on the schedules list here
//               // You can filter scheduleItems based on the search query
//             },
//           ),
//         ),
//         // Schedule Items List
//         Expanded(
//           child: schedules.isEmpty
//               ? Center(child: Text('No schedules available!'))
//               : ListView.builder(
//             itemCount: schedules.length,
//             itemBuilder: (context, index) {
//               final schedule = schedules[index];
//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(
//                     schedule.sub_name,
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Teacher: ${schedule.t_name}'),
//                       Text('Room: ${schedule.room}'),
//                       Text('Time: ${schedule.start_time} - ${schedule.end_time}'),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.details),
//                     onPressed: () {
//                       // Add functionality to view detailed schedule information
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
