import 'package:class_organizer/utility/assets_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsPath.bgSvgPath,
          height: double.maxFinite,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
        child,
      ],
    );
  }
}
