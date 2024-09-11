import 'package:class_organizer/onboarding/get_start.dart';
import 'package:class_organizer/ui/screens/auth/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'screen/intro_four.dart';
import 'screen/intro_one.dart';
import 'screen/intro_three.dart';
import 'screen/intro_two.dart';

class OnScreen extends StatefulWidget {
  OnScreen({super.key});

  @override
  Widget build(BuildContext context) {

        // TODO: implement build
    throw UnimplementedError();

  }
  
  @override
  State<StatefulWidget> createState() {
    return OnScreenState();
  }
}

class OnScreenState extends State<OnScreen> {

  String buttonText = "Skip";
  int currentPage = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index){
                currentPage = index;
                if(index==3){
                  buttonText = "Finish";
                }else{
                  buttonText = "Skip";
                }
                setState(() {
                  
                });
              },
              children: const [
                IntroOne(),
                IntroTwo(),
                IntroThree(),
                IntroFour(),
              ],
            ),
            Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  GetStart()));
                    },
                    child: Text(buttonText)),
                  SmoothPageIndicator(
                    controller: pageController, 
                    count: 4),
                  currentPage == 3 ? const SizedBox(width: 10,) : GestureDetector(
                    onTap: () {
                      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                    },
                    child: const Text("Next")),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
