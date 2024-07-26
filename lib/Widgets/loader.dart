import 'package:flutter/material.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class LoadingWidget extends StatefulWidget {
  final bool isImage;

  const LoadingWidget({super.key, this.isImage = false});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animationController,
            child: Image(
              height: 5.h,
              image: AssetImage('Assets/images/app-icon.png'),
            ),
          ),
        ],
      ),
    );
  }
}

class ErorWidget extends StatelessWidget {
  const ErorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('Assets/images/app-icon.png'),
          height: 3.h,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          "Error loading image",
          style: CustomTextStyles.lightTextStyle(size: 8.sp),
        ),
      ],
    ));
  }
}
