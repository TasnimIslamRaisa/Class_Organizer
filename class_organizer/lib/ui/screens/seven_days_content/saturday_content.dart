import 'package:flutter/material.dart';

class SaturdayContent extends StatelessWidget {
  const SaturdayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("NO Class On Saturday",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}