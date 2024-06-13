import 'package:flutter/material.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    canvasColor: Color(0xffFFFFFF),
    dialogBackgroundColor: Color(0xffFFFFFF),
    scaffoldBackgroundColor: Color(0xffFFFFFF),
    primaryColor: AppColors.blackColor151,
    primaryColorDark: Color(0xff1C2A3A),
    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
      fillColor: Color(0xffF9FAFB),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Color(0xffD1D5DB),
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Color(0xffD1D5DB),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Color(0xffD1D5DB),
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppColors.redColor,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppColors.redColor,
          width: 1.0,
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
      dialogBackgroundColor: Color(0xff0D0D0D),
      primaryColor: AppColors.whiteColor,
      primaryColorDark: AppColors.lightBlueColor3e3,
      scaffoldBackgroundColor: Color(0xff0D0D0D),
      brightness: Brightness.dark,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
        fillColor: Color(0xff121212),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(0xff2F343C),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(0xff2F343C),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(0xff2F343C),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppColors.redColor,
            width: 0.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppColors.redColor,
            width: 0.5,
          ),
        ),
      ),
      canvasColor: Color(0xff0D0D0D));
}
