import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieScreen extends StatefulWidget {
  const LottieScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LottieScreenState();
  }
}

class LottieScreenState extends State<LottieScreen> with SingleTickerProviderStateMixin{

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Durations.extralong4);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> title = [
    "ClassOrganizer",
    "TutionTracker",
    "EventManagement",
    "ClubManagement"
  ];

  List<String> desc = ["Class scheduler", "", "", ""];

  var anims = ["hello", "edubox", "education", "edumain"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        var ticker = _controller.forward();
        ticker.whenComplete((){
          _controller.reset();
        });
      },
      child: const Icon(Icons.skip_next),),    
      body: Stack(
        children: [
          Center(
            child: PageView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.asset(
                          'animation/${anims[index]}.json',
                          height: 300,
                          reverse: true,
                          repeat: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(title[index],textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(desc[index],textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),)),
                    ],
                  );
                }),
          ),
          Center(
            child: Lottie.asset(
              'animation/9.json',
              controller: _controller,
              width: MediaQuery.sizeOf(context).height,
              height: MediaQuery.sizeOf(context).width,
              reverse: true,
              repeat: false,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ));
  }
}
