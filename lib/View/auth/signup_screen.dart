import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/auth/utils/auth_utils.dart';
import 'package:joy_app/view/doctor_flow/profile_form.dart';
import 'package:joy_app/view/pharmacy_flow/home_screen.dart';
import 'package:joy_app/view/auth/login_screen.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/hospital_flow/profile_form.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:sizer/sizer.dart';

import '../pharmacy_flow/profile_form.dart';
import '../bloodbank_flow/home_screen.dart';
import '../bloodbank_flow/profile_form.dart';
import 'profileform_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String selectedButton = "";
  int? selectedFieldValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            // color: Color(0xffFFFFFF),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
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
                    validator: validateName,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _nameController,
                    hintText: 'Your Name',
                    icon: 'Assets/images/user.svg',
                  ),
                  SizedBox(height: 2.h),
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
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _emailController,
                    hintText: 'Your Email',
                    icon: 'Assets/images/sms.svg',
                  ),
                  SizedBox(height: 2.h),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode3,
                    controller: _passwordController,
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
                          onPressed: () {
                            setState(() {
                              selectedButton = "User";
                            });
                          },
                          backgroundColor: selectedButton == "User"
                              ? ThemeUtil.isDarkMode(context)
                                  ? Color(0xffC5D3E3)
                                  : Color(0xff1C2A3A)
                              : Color(
                                  0xff121212), // Change background color based on selection
                          textColor: selectedButton == "User"
                              ? ThemeUtil.isDarkMode(context)
                                  ? Color(0XFF0D0D0D)
                                  : Colors.white
                              : Color(
                                  0xff9CA3AF), // Change text color based on selection
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: RoundedButton(
                          text: "Professional",
                          onPressed: () {
                            setState(() {
                              selectedButton = "Professional";
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    callback: (int selectedValue) {
                                  selectedFieldValue = selectedValue;
                                });
                              },
                            );
                          },
                          backgroundColor: selectedButton == "Professional"
                              ? ThemeUtil.isDarkMode(context)
                                  ? Color(0xffC5D3E3)
                                  : Color(0xff1C2A3A)
                              : Color(
                                  0xff121212), // Change background color based on selection
                          textColor: selectedButton == "Professional"
                              ? ThemeUtil.isDarkMode(context)
                                  ? Color(0XFF0D0D0D)
                                  : Colors.white
                              : Color(
                                  0xff9CA3AF), // Change text color based on selection
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                            text: "Create Account",
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                              } else if (selectedButton.isEmpty) {
                                showErrorMessage(
                                    context, 'Select Account Category');
                              } else {
                                if (selectedButton == 'User') {
                                  Get.to(FormScreen());
                                } else if (selectedButton == 'Professional') {
                                  selectedFieldValue == 1
                                      ? Get.to(DoctorFormScreen())
                                      : selectedFieldValue == 2
                                          ? Get.to(PharmacyFormScreen())
                                          : selectedFieldValue == 3
                                              ? Get.to(BloodBankFormScreen())
                                              : selectedFieldValue == 4
                                                  ? Get.to(HospitalFormScreen())
                                                  : print(selectedFieldValue);
                                }
                              }
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC5D3E3)
                                : Color(0xff1C2A3A),
                            textColor: ThemeUtil.isDarkMode(context)
                                ? Color(0XFF0D0D0D)
                                : Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Or sign up with',
                          style: CustomTextStyles.lightSmallTextStyle(),
                        ),
                      ),
                      Expanded(child: Divider())
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
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
                        isApple: true,
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offAll(LoginScreen());
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef void DialogCallback(int selectedValue);

class CustomDialog extends StatefulWidget {
  final DialogCallback callback;

  CustomDialog({required this.callback});
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  int? selectedField;

  void _selectButton(int buttonNumber) {
    setState(() {
      selectedField = buttonNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            RoundedButtonSmall(
              text: "Continue as Doctor",
              onPressed: () {
                _selectButton(1);
                widget.callback(selectedField!);
              },

              backgroundColor: selectedField == 1
                  ? Color(0xff1C2A3A)
                  : Color(
                      0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 1 ? Colors.white : Color(0xff9CA3AF),
            ),
            RoundedButtonSmall(
              text: "Continue as Pharmacy",
              onPressed: () {
                _selectButton(2);
                widget.callback(selectedField!);
              },
              backgroundColor: selectedField == 2
                  ? Color(0xff1C2A3A)
                  : Color(
                      0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 2 ? Colors.white : Color(0xff9CA3AF),
            ),
            RoundedButtonSmall(
              text: "Continue as Blood bank",
              onPressed: () {
                _selectButton(3);
                widget.callback(selectedField!);
              },
              backgroundColor: selectedField == 3
                  ? Color(0xff1C2A3A)
                  : Color(
                      0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 3 ? Colors.white : Color(0xff9CA3AF),
            ),
            RoundedButtonSmall(
              text: "Continue as Hospital",
              onPressed: () {
                _selectButton(4);
                widget.callback(selectedField!);
              },
              backgroundColor: selectedField == 4
                  ? Color(0xff1C2A3A)
                  : Color(
                      0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 4 ? Colors.white : Color(0xff9CA3AF),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
