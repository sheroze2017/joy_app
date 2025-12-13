import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class RoundedBorderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  bool showLoader;
  bool isLocation;
  IconData? icondata;
  final VoidCallback? onTap;
  final String icon;
  final bool maxlines;
  bool isenable;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  TextInputType textInputType;
  final FormFieldValidator<String>? validator;
  bool showLabel;

  RoundedBorderTextField({
    this.isLocation = false,
    this.showLabel = false,
    this.showLoader = false,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.icondata,
    this.onTap,
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
      style: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
      cursorColor: const Color(0xffD1D5DB),
      maxLines: maxlines == false ? 1 : null,
      controller: controller,
      decoration: InputDecoration(
        label: showLabel ? Text(hintText) : null,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        suffix: showLoader
            ? Container(
                height: 2.h,
                width: 2.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.green,
                ),
              )
            : isLocation
                ? InkWell(
                    onTap: onTap,
                    child: Container(
                      height: 2.h,
                      width: 2.h,
                      child: Icon(icondata),
                    ),
                  )
                : null,
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
