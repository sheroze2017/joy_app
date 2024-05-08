import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle darkTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle darkHeadingTextStyle({Color? color, double? size = 16}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color ?? Color(0xff1F2A37),
    );
  }

  static TextStyle lightTextStyle({Color? color, double size = 14}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? Color(0xff6B7280),
    );
  }

  static TextStyle w600TextStyle({Color? color, double size = 16}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? Color(0xff6B7280),
    );
  }

  static const TextStyle lightSmallTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xff6B7280),
  );
}
