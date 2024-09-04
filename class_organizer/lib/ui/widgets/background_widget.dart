import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset(
        //   'assets/images/blueBG',
        //   //AssetsPath.bgSvgPath,
        //   height: double.maxFinite,
        //   width: double.maxFinite,
        //   fit: BoxFit.cover,
        // ),
        Opacity(
          opacity: 0.4,
          child: Image.asset(
            "assets/images/blueBG.jpg",
            fit: BoxFit.cover,
            height: double.maxFinite,
            width: double.maxFinite,
          ),
        ),
        child,
      ],
    );
  }
}
