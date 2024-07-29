import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:sizer/sizer.dart';
import 'verify_code_screen.dart';


class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: '',
          icon: Icons.arrow_back,
          onPressed: () {
            Get.back();
          }),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            //  color: Color(0xffFFFFFF),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 10.h,
                  // ),
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
                    style: CustomTextStyles.lightTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffAAAAAA)
                            : null),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (isValidEmail(value) == false) {
                        return 'Invaild Email';
                      } else {
                        return null;
                      }
                    },
                    controller: _passwordController,
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
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                              } else {
                                Get.to(VerifyCodeScreen(),
                                    transition: Transition.native);
                              }
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC5D3E3)
                                : Color(0xff1C2A3A),
                            textColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xff121212)
                                : Color(0xffFFFFFF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
