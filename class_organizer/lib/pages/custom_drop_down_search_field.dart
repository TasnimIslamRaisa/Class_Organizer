// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/services.dart' show rootBundle;

// import '../models/school.dart';

// class CustomDropDownSearchField extends StatefulWidget {
//   final String label;
//   final String hint;
//   final List<School> dataList;
//   final void Function(School?)? onChanged;

//   const CustomDropDownSearchField({
//     Key? key,
//     required this.label,
//     required this.hint,
//     required this.dataList,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   _CustomDropDownSearchFieldState createState() => _CustomDropDownSearchFieldState();
// }

// class _CustomDropDownSearchFieldState extends State<CustomDropDownSearchField> {
//   School? selectedItem;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.label, style: TextStyle(fontSize: 18)),
//         DropdownSearch<School>(
//           mode: Mode.DIALOG, // Can be DIALOG, BOTTOM_SHEET, or MENU
//           items: widget.dataList,
//           itemAsString: (School school) => school.sName ?? '', // Customize how items are displayed
//           dropdownSearchDecoration: InputDecoration(
//             labelText: widget.hint,
//             hintText: widget.hint,
//           ),
//           dropdownBuilder: _customDropDown,
//           popupItemBuilder: _customPopupItemBuilder,
//           onChanged: widget.onChanged ?? (School? item) {
//             setState(() {
//               selectedItem = item;
//             });
//           },
//           showSearchBox: true,
//           searchFieldProps: TextFieldProps(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Search School',
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         if (selectedItem != null)
//           Text(
//             "Selected: ${selectedItem!.sName} (sId: ${selectedItem!.sId})",
//             style: TextStyle(fontSize: 16),
//           ),
//       ],
//     );
//   }

//   // Custom dropdown display for the selected item
//   Widget _customDropDown(BuildContext context, School? item) {
//     if (item == null) {
//       return Text("No School Selected", style: TextStyle(color: Colors.grey));
//     }
//     return ListTile(
//       leading: Icon(Icons.school, color: Colors.blue),
//       title: Text(item.sName ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text("sId: ${item.sId}"),
//     );
//   }

//   // Custom popup item builder for dropdown items
//   Widget _customPopupItemBuilder(BuildContext context, School item, bool isSelected) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
//         borderRadius: BorderRadius.circular(5),
//         color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
//       ),
//       child: ListTile(
//         leading: Icon(Icons.school),
//         title: Text(item.sName ?? ''),
//         subtitle: Text("sId: ${item.sId}"),
//       ),
//     );
//   }
// }
