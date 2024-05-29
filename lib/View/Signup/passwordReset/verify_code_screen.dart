import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/Signup/passwordReset/new_pass_screen.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class VerifyCodeScreen extends StatefulWidget {
  VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final pinController = TextEditingController();

  final focusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: '',
          icon: Icons.arrow_back,
          onPressed: () {
            Get.back();
          }),
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
                  "Verify Code",
                  style: CustomTextStyles.darkTextStyle(),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Enter the Code",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                Text(
                  "we just sent you on your registered Email",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 4.h),
                Pinput(
                  length: 5,
                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                  controller: pinController,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: "Verify",
                          onPressed: () {
                            Get.to(NewPassScreen());
                          },
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xffFFFFFF)),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Didn’t get the Code? ',
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                      TextSpan(
                        text: 'Resend ',
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
