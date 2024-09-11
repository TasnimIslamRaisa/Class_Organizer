
import 'package:flutter/material.dart';

class TuesdayContent extends StatelessWidget {
  const TuesdayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("NO Class On Tuesday",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}