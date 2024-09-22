import 'package:flutter/material.dart';

class FlashcardRoutineSystem extends StatefulWidget {
  @override
  _FlashcardRoutineSystemState createState() => _FlashcardRoutineSystemState();
}

class _FlashcardRoutineSystemState extends State<FlashcardRoutineSystem> {
  PageController _pageController1 = PageController();
  PageController _pageController2 = PageController();
  int _currentIndex1 = 0;
  int _currentIndex2 = 0;

  final List<FlashcardData> flashcards1 = [
    FlashcardData(
      title: 'Compiler Lab',
      time: '01:00 PM - 03:00 PM',
      subtitle: '320_1',
      teacher: 'Arifa Mem',
      room: '313',
      tips: ['Revise Compiler Theory', 'Practice Lab Exercises', 'Solve Previous Year Questions'],
    ),
    FlashcardData(
      title: 'Data Structures',
      time: '10:00 AM - 12:00 PM',
      subtitle: '215_2',
      teacher: 'Sabbir Sir',
      room: '102',
      tips: ['Learn Linked List', 'Understand Recursion', 'Practice Sorting Algorithms'],
    ),
  ];

  final List<FlashcardData> flashcards2 = [
    FlashcardData(
      title: 'Operating Systems',
      time: '09:00 AM - 11:00 AM',
      subtitle: '120_1',
      teacher: 'Mahmud Sir',
      room: '220',
      tips: ['Study Process Management', 'Learn Deadlock Concepts', 'Revise Virtual Memory'],
    ),
    FlashcardData(
      title: 'Algorithms',
      time: '02:00 PM - 04:00 PM',
      subtitle: '330_2',
      teacher: 'Nahid Sir',
      room: '315',
      tips: ['Practice Graph Algorithms', 'Revise Dynamic Programming', 'Solve Recurrence Relations'],
    ),
  ];

  void _onSwipe1(int index) {
    setState(() {
      _currentIndex1 = index;
    });
  }

  void _onSwipe2(int index) {
    setState(() {
      _currentIndex2 = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine Flashcards'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: PageView.builder(
              controller: _pageController1,
              onPageChanged: _onSwipe1,
              itemCount: flashcards1.length,
              itemBuilder: (context, index) {
                return FlashcardRoutine(
                  flashcard: flashcards1[index],
                );
              },
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey,
          ),
          Expanded(
            flex: 1,
            child: PageView.builder(
              controller: _pageController2,
              onPageChanged: _onSwipe2,
              itemCount: flashcards2.length,
              itemBuilder: (context, index) {
                return FlashcardRoutine(
                  flashcard: flashcards2[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlashcardRoutine extends StatefulWidget {
  final FlashcardData flashcard;

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
                ? RoutineCard(
              title: widget.flashcard.title,
              time: widget.flashcard.time,
              subtitle: widget.flashcard.subtitle,
              teacher: widget.flashcard.teacher,
              room: widget.flashcard.room,
            )
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(3.1416),
              child: _backCard(widget.flashcard.tips),
            ),
          );
        },
      ),
    );
  }

  Widget _backCard(List<String> tips) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exam Preparation Tips",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                tip,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )),
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

class RoutineCard extends StatelessWidget {
  final String title;
  final String time;
  final String subtitle;
  final String teacher;
  final String room;

  const RoutineCard({
    Key? key,
    required this.title,
    required this.time,
    required this.subtitle,
    required this.teacher,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Title and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Subtitle (e.g., "320_1")
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.redAccent,
            ),
            SizedBox(height: 8),

            // Teacher and Room information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Teacher",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      teacher,
                      style: TextStyle(
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
                    Text(
                      "Room",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      room,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardData {
  final String title;
  final String time;
  final String subtitle;
  final String teacher;
  final String room;
  final List<String> tips;

  FlashcardData({
    required this.title,
    required this.time,
    required this.subtitle,
    required this.teacher,
    required this.room,
    required this.tips,
  });
}
