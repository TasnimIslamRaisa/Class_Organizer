import 'package:class_organizer/models/schedule_item.dart';
import 'package:class_organizer/utility/card/schedule_card.dart';
import 'package:flutter/material.dart';

import '../../style/app_color.dart';
class FlashcardRoutine extends StatefulWidget {
  final ScheduleItem flashcard;

  const FlashcardRoutine({Key? key, required this.flashcard}) : super(key: key);

  @override
  _FlashcardRoutineState createState() => _FlashcardRoutineState();
}

class _FlashcardRoutineState extends State<FlashcardRoutine>
    with SingleTickerProviderStateMixin {
  bool isFront = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.1416;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: _controller.value < 0.5
                ? ScheduleCards(scheduleItem: widget.flashcard,
            )
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(3.1416),
              child: _backCard(widget.flashcard),
            ),
          );
        },
      ),
    );
  }

  Widget _backCard(ScheduleItem scheduleItem) {
    final bool isLightMode = true; // Set this dynamically based on your app theme

    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLightMode ? Colors.blueGrey[50] : Colors.blueGrey[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        scheduleItem.subCode ?? "",
                        // Use the appropriate property from ScheduleItem
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        scheduleItem.day??"",  // Use the appropriate property from ScheduleItem
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        child: Icon(
                          scheduleItem.subCode == ''  // Icon condition based on scheduleItem property
                              ? Icons.thumb_up
                              : Icons.laptop_chromebook_sharp,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${scheduleItem.startTime} - ${scheduleItem.endTime}",

                        // Use appropriate description or text field from ScheduleItem
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
