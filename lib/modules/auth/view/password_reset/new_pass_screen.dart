import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../../../Widgets/appbar.dart';
import '../../utils/auth_utils.dart';

class NewPassScreen extends StatelessWidget {
  NewPassScreen({super.key});

  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

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
            // color: Color(0xffFFFFFF),
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
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffAAAAAA)
                              : null),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return 'Please enter password';
                      } else {
                        return null;
                      }
                    },
                    controller: _oldPass,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'New Password',
                    icon: 'Assets/images/lock.svg',
                  ),
                  SizedBox(height: 2.h),
                  RoundedBorderTextField(
                    validator: (value) =>
                        validatePasswordMatch(_oldPass.text, value),
                    controller: _newPass,
                    focusNode: _focusNode2,
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
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                              } else {
                                Get.to(NavBarScreen(isUser: true),
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
