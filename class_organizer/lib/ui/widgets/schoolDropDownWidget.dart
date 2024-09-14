import 'package:flutter/material.dart';
import '../../models/school.dart';

class SchoolDropdown extends StatefulWidget {
  final List<School> schools;
  final School? selectedSchool;
  final void Function(School?) onChanged;

  SchoolDropdown({
    required this.schools,
    this.selectedSchool,
    required this.onChanged,
  });

  @override
  _SchoolDropdownState createState() => _SchoolDropdownState();
}

class _SchoolDropdownState extends State<SchoolDropdown> {
  late List<School> _filteredSchools;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredSchools = widget.schools;
    _searchController = TextEditingController();
    _searchController.addListener(_filterSchools);
  }

  void _filterSchools() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSchools = widget.schools
          .where((school) => school.sName?.toLowerCase().contains(query) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<School>(
        value: widget.selectedSchool,
        items: [
          DropdownMenuItem<School>(
            enabled: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search School/College',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                autofocus: true,
              ),
            ),
          ),
          ..._filteredSchools.map((School school) {
            return DropdownMenuItem<School>(
              value: school,
              child: Text(school.sName ?? ''),
            );
          }).toList(),
        ],
        onChanged: widget.onChanged,
        hint: Text('Select School/College'),
        icon: Icon(Icons.arrow_drop_down),
        isExpanded: true,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
