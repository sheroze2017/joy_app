import 'package:flutter/material.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  bool? isSmall = false;
  bool showLoader;
  bool isReview;

  RoundedButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.isSmall,
    this.showLoader = false,
    this.isReview = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isReview ? 50 : 20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: showLoader
            ? CircularProgressIndicator(
                color: AppColors.whiteColor,
              )
            : Text(
                text,
                style: CustomTextStyles.lightSmallTextStyle(
                    color: textColor, size: 16),
              ),
      ),
    );
  }
}

class RoundedButtonSmall extends StatelessWidget {
  final String text;
  final bool isBorder;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  bool? isSmall = false;
  bool isBold;
  bool showLoader;

  RoundedButtonSmall(
      {required this.text,
      required this.onPressed,
      required this.backgroundColor,
      required this.textColor,
      this.isSmall,
      this.showLoader = false,
      this.isBold = false,
      this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: showLoader
              ? Container(
                  height: 2.h,
                  width: 2.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                      fontSize: isBold ? (14 / 3.9).w : (12.18 / 3.9).w),
                ),
        ),
      ),
    );
  }
}
