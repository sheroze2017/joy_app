import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';

class ExitAppDialog extends StatelessWidget {
  const ExitAppDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Exit App',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.getCurrentTheme(context).primaryColor)),
      content: Text('Are you sure you want to exit the app?'),
      actions: <Widget>[
        RoundedButton(
            text: 'No',
            onPressed: () {
              Get.back();
            },
            backgroundColor: AppColors.whiteColor,
            textColor: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : AppColors.blackColor),
        RoundedButton(
            text: 'Yes',
            onPressed: () {
              exit(0);
            },
            backgroundColor: ThemeUtil.isDarkMode(context)
                ? Color(0xffC5D3E3)
                : Color(0xff1C2A3A),
            textColor: ThemeUtil.isDarkMode(context)
                ? Color(0xff121212)
                : AppColors.whiteColor),
      ],
    );
  }
}
