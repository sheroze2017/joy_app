import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

class RoundedBorderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String icon;
  final bool maxlines;
  bool isenable;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  TextInputType textInputType;
  final FormFieldValidator<String>? validator;

  RoundedBorderTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.focusNode,
    this.nextFocusNode,
    this.maxlines = false,
    this.isenable = true,
    this.textInputType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: textInputType,
      focusNode: focusNode,
      enabled: isenable,
      // style: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
      // cursorColor: const Color(0xffD1D5DB),
      maxLines: maxlines == false ? 1 : null,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
        prefixIcon: icon.isEmpty
            ? null
            : Padding(
                padding: EdgeInsets.all(12.0),
                child: SvgPicture.asset(icon),
              ),
        // filled: true,
        // fillColor: Color(0xffF9FAFB),
      ),

      onFieldSubmitted: (value) {
        focusNode!.unfocus();
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
    );
  }
}
