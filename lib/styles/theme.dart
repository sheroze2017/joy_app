import 'package:flutter/material.dart';
import 'package:joy_app/styles/colors.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.whiteColor,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.blackColor,
    brightness: Brightness.dark,
  );
}
