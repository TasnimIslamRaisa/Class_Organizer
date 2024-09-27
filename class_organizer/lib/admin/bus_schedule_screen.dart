import 'package:flutter/material.dart';

import '../utility/profile_app_bar_admin.dart';

class ShuttleScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar :ProfileAppBarAdmin(
        title:  'Bus Schedule',
        actionIcon: Icons.more_vert,
        onActionPressed: (){},
        appBarbgColor: const Color(0xFF01579B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Route')),
              DataColumn(label: Text('Shuttle No')),
              DataColumn(label: Text('Remarks')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('09:00 AM')),
                DataCell(Text('Abrabad To EDU campus via Probortak')),
                DataCell(Text('EDU Shuttle-04')),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Regular service'),
                    Text('Elias', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
              ]),
              DataRow(cells: [
                DataCell(Text('09:25 AM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-04')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('10:45 AM', style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-02')),
                DataCell(Text('Amir-Ali', style: TextStyle(fontWeight: FontWeight.bold))),
              ]),
              DataRow(cells: [
                DataCell(Text('11:30 AM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-04')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('12:00 PM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-02')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('12:30 PM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-04')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('01:00 PM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-02')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('02:00 PM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-04')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('03:00 PM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-02')),
                DataCell(Text('')),
              ]),
              DataRow(cells: [
                DataCell(Text('05:00 PM')),
                DataCell(Text('Probortak To EDU Campus')),
                DataCell(Text('EDU Shuttle-02')),
                DataCell(Text('Evening', style: TextStyle(fontWeight: FontWeight.bold))),
              ]),
            ],
          ),
        ),
      ),
    )   ;
  }
}