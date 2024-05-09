import 'package:flutter/material.dart';
import 'package:joy_app/utils/constant/constant.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          children: [
            Column(
              children: [
                Image(
                    height: 70.h,
                    width: 100.w,
                    image: AssetImage(CustomConstant.onboardImage1)),
              ],
            )
          ],
        )
      ],
    );
  }
}
