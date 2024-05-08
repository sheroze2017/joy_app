import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class NewPassScreen extends StatelessWidget {
  const NewPassScreen({super.key});

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
                  "Create new password",
                  style: CustomTextStyles.darkTextStyle(),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Your new password must be different form previously used password",
                    style: CustomTextStyles.lightTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'New Password',
                  icon: 'Assets/images/lock.svg',
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Confirm Password',
                  icon: 'Assets/images/lock.svg',
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: "Reset Password",
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

class RoundedContainer extends StatelessWidget {
  final String imagePath;

  const RoundedContainer({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.11),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
