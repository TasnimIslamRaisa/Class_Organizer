import 'package:flutter/material.dart';

class FridayContent extends StatelessWidget {
  const FridayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("NO Class On Friday",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}