import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

class LoadingWidget extends StatelessWidget {
  final bool isImage;

  const LoadingWidget({super.key, this.isImage = false});

  @override
  Widget build(BuildContext context) {
    final Color color = context.theme.colorScheme.primary;
    return Center(
        child: Column(
      children: [
        Image(
          image: AssetImage('Assets/images/app-icon.png'),
        ),
        Text(
          "Loading...",
          style: CustomTextStyles.lightTextStyle(),
        ),
      ],
    ));
  }
}
