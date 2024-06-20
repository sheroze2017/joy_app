import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextStyles {
  static TextStyle darkTextStyle({Color? color}) {
    return TextStyle(
        fontSize: (20 / 3.9).w,
        fontWeight: FontWeight.w600,
        color: color,
        fontFamily: 'Inter');
  }

  static TextStyle darkHeadingTextStyle({Color? color, double size = 16}) {
    return TextStyle(
        fontSize: (size / 3.9).w,
        fontWeight: FontWeight.w700,
        color: color ?? Color(0xff1F2A37),
        fontFamily: 'Inter');
  }

  static TextStyle lightTextStyle({Color? color, double size = 14}) {
    return TextStyle(
        fontSize: (size / 3.9).w,
        fontWeight: FontWeight.w400,
        color: color ?? Color(0xff6B7280),
        fontFamily: 'Inter');
  }

  static TextStyle w600TextStyle(
      {Color? color, double size = 16, double? letterspacing = 0.5}) {
    return TextStyle(
        fontSize: (size / 3.9).w,
        letterSpacing: letterspacing,
        fontWeight: FontWeight.w600,
        color: color ?? Color(0xff6B7280),
        fontFamily: 'Inter');
  }

  // static const TextStyle lightSmallTextStyle = TextStyle(
  //   fontSize: 12,
  //   fontWeight: FontWeight.w500,
  //   color: Color(0xff6B7280),
  // );

  static TextStyle lightSmallTextStyle({Color? color, double size = 12}) {
    return TextStyle(
        fontSize: (size / 3.9).w,
        fontWeight: FontWeight.w500,
        color: color ?? Color(0xff6B7280),
        fontFamily: 'Inter');
  }
}
