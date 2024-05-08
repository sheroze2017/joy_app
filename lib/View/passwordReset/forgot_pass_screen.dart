import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SvgPicture.asset(
                    'Assets/images/Logo.svg',
                  ),
                ),
                Text(
                  "Forget Password?",
                  style: CustomTextStyles.darkTextStyle(),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Enter your Email, we will send you a verification code.",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 4.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Your Email',
                  icon: 'Assets/images/sms.svg',
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: "Send Code",
                          onPressed: () {},
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xffFFFFFF)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
