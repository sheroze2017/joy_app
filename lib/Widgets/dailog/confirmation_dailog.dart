import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';

class ConfirmationDailog extends StatelessWidget {
  const ConfirmationDailog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Linkage',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.getCurrentTheme(context).primaryColor)),
      content:
          Text('Are you sure you want to attach this user to your hospital?'),
      actions: <Widget>[
        RoundedButton(
            text: 'No',
            onPressed: () {
              Get.back();
            },
            backgroundColor: ThemeUtil.isDarkMode(context)
                ? AppColors.blackColor
                : AppColors.whiteColor,
            textColor: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : AppColors.blackColor),
        RoundedButton(
            text: 'Yes',
            onPressed: () {
              Get.back();
              // exit(0);
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
