import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/View/Signup/login_screen.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                  "Create Account",
                  style: CustomTextStyles.darkTextStyle(),
                ),
                SizedBox(height: 2.h),
                Text(
                  "We are here to give you joy!",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Your Name',
                  icon: 'Assets/images/user.svg',
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Your Email',
                  icon: 'Assets/images/sms.svg',
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Your Password',
                  icon: 'Assets/images/lock.svg',
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: "User",
                          onPressed: () {},
                          backgroundColor: Color(0xffF9FAFB),
                          textColor: Color(0xff9CA3AF)),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Expanded(
                      child: RoundedButton(
                          text: "Professional",
                          onPressed: () {},
                          backgroundColor: Color(0xffF9FAFB),
                          textColor: Color(0xff9CA3AF)),
                    )
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: "Create Account",
                          onPressed: () {},
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xFFFFFFFF)),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Divider()),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Or sign up with',
                        style: CustomTextStyles.lightSmallTextStyle(),
                      ),
                    )),
                    Expanded(child: Divider())
                  ],
                ),
                SizedBox(height: 2.h),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedContainer(
                      imagePath: 'Assets/images/google.png',
                    ),
                    RoundedContainer(
                      imagePath: 'Assets/images/gmail.png',
                    ),
                    RoundedContainer(
                      imagePath: 'Assets/images/apple.png',
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account ? ',
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(
                          color: Color(0xff1C64F2),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
