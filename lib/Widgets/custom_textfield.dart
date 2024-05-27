import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

class RoundedBorderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String icon;
  final bool maxlines;
  bool isenable;

  RoundedBorderTextField(
      {required this.controller,
      required this.hintText,
      required this.icon,
      this.maxlines = false,
      this.isenable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xffD1D5DB),
          width: 1.0,
        ),
        color: Color(0xffF9FAFB),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                enabled: isenable,
                style:
                    CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
                cursorColor: const Color(0xffD1D5DB),
                maxLines: maxlines == false ? 1 : null,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle:
                      CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
