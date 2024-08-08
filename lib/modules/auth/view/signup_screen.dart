import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/auth/bloc/auth_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/modules/doctor/view/profile_form.dart';
import 'package:joy_app/modules/auth/view/login_screen.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/modules/hospital/view/profile_form.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:sizer/sizer.dart';

import '../../user/user_pharmacy/all_pharmacy/view/profile_form.dart';
import '../../blood_bank/view/profile_form.dart';
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
  final authController = Get.find<AuthController>();

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
                    style: CustomTextStyles.lightTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffAAAAAA)
                            : null),
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
                    validator: validatePasswordStrength,
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
                                  0xffF9FAFB), // Change background color based on selection
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
                                  0xffF9FAFB), // Change background color based on selection
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
                          child: Obx(() => RoundedButton(
                              showLoader: authController.registerLoader.value,
                              text: "Create Account",
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) {
                                } else if (selectedButton.isEmpty) {
                                  showErrorMessage(
                                      context, 'Select Account Category');
                                } else if (await authController.isValidMail(
                                    _emailController.text, context)) {
                                  if (selectedButton == 'User') {
                                    Get.to(
                                        FormScreen(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          name: _nameController.text,
                                        ),
                                        transition: Transition.native);
                                  } else if (selectedButton == 'Professional') {
                                    selectedFieldValue == 1
                                        ? Get.to(
                                            DoctorFormScreen(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              name: _nameController.text,
                                            ),
                                            transition: Transition.native)
                                        : selectedFieldValue == 2
                                            ? Get.to(
                                                PharmacyFormScreen(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                  name: _nameController.text,
                                                ),
                                                transition: Transition.native)
                                            : selectedFieldValue == 3
                                                ? Get.to(
                                                    BloodBankFormScreen(
                                                      email:
                                                          _emailController.text,
                                                      password:
                                                          _passwordController
                                                              .text,
                                                      name:
                                                          _nameController.text,
                                                    ),
                                                    transition:
                                                        Transition.native)
                                                : selectedFieldValue == 4
                                                    ? Get.to(
                                                        HospitalFormScreen(
                                                          email:
                                                              _emailController
                                                                  .text,
                                                          password:
                                                              _passwordController
                                                                  .text,
                                                          name: _nameController
                                                              .text,
                                                        ),
                                                        transition:
                                                            Transition.native)
                                                    : print(selectedFieldValue);
                                  }
                                } else {}
                              },
                              backgroundColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0xffC5D3E3)
                                  : Color(0xff1C2A3A),
                              textColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0XFF0D0D0D)
                                  : Color(0xFFFFFFFF)))),
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
                      InkWell(
                        onTap: () async {
                          if (selectedButton.isEmpty) {
                            showErrorMessage(
                                context, 'Please select profile type');
                          } else if (selectedButton == 'Professional' &&
                              selectedFieldValue == null) {
                            showErrorMessage(
                                context, 'Please select professional category');
                          } else {
                            UserCredential user =
                                await authController.registerWithGoogle();
                            if (await authController.isValidMail(
                                user.user!.email.toString(), context)) {
                              if (selectedButton == 'User') {
                                Get.to(
                                    FormScreen(
                                      isSocial: true,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      name: _nameController.text,
                                    ),
                                    transition: Transition.native);
                              } else if (selectedButton == 'Professional') {
                                navigateToFormScreen(
                                  context: context,
                                  selectedFieldValue:
                                      selectedFieldValue!.toInt(),
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                );
                              }
                            } else {}
                          }
                        },
                        child: RoundedContainer(
                          imagePath: 'Assets/images/google.png',
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedButton.isEmpty) {
                            showErrorMessage(
                                context, 'Please select profile type');
                          } else if (selectedButton == 'Professional' &&
                              selectedFieldValue == null) {
                            showErrorMessage(
                                context, 'Please select professional category');
                          } else {
                            UserCredential user =
                                await authController.registerWithFacebook();
                            if (await authController.isValidMail(
                                user.user!.email.toString(), context)) {
                              if (selectedButton == 'User') {
                                Get.to(
                                    FormScreen(
                                      isSocial: true,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      name: _nameController.text,
                                    ),
                                    transition: Transition.native);
                              } else if (selectedButton == 'Professional') {
                                navigateToFormScreen(
                                  context: context,
                                  selectedFieldValue:
                                      selectedFieldValue!.toInt(),
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                );
                              }
                            } else {}
                          }
                        },
                        child: RoundedContainer(
                          imagePath: 'Assets/images/facebook.png',
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedButton.isEmpty) {
                            showErrorMessage(
                                context, 'Please select profile type');
                          } else if (selectedButton == 'Professional' &&
                              selectedFieldValue == null) {
                            showErrorMessage(
                                context, 'Please select professional category');
                          } else {
                            UserCredential user =
                                await authController.registerWithApple();
                            if (await authController.isValidMail(
                                user.user!.email.toString(), context)) {
                              if (selectedButton == 'User') {
                                Get.to(
                                    FormScreen(
                                      isSocial: true,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      name: _nameController.text,
                                    ),
                                    transition: Transition.native);
                              } else if (selectedButton == 'Professional') {
                                navigateToFormScreen(
                                  context: context,
                                  selectedFieldValue:
                                      selectedFieldValue!.toInt(),
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                );
                              }
                            } else {}
                          }
                        },
                        child: RoundedContainer(
                          imagePath: 'Assets/images/apple.png',
                          isApple: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account ? ',
                          style: CustomTextStyles.lightTextStyle(
                              color: ThemeUtil.isDarkMode(context)
                                  ? Color(0xffAAAAAA)
                                  : null),
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
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),
        ),
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ],
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).scaffoldBackgroundColor,
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
                Get.back();
              },

              backgroundColor: selectedField == 1
                  ? ThemeUtil.isDarkMode(context)
                      ? AppColors.lightBlueColor3e3
                      : Color(0xff1C2A3A)
                  : ThemeUtil.isDarkMode(context)
                      ? Color(0xff121212)
                      : Color(
                          0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 1
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Color(0xff9CA3AF),
            ),
            RoundedButtonSmall(
              text: "Continue as Pharmacy",
              onPressed: () {
                _selectButton(2);
                widget.callback(selectedField!);
                Get.back();
              },
              backgroundColor: selectedField == 2
                  ? ThemeUtil.isDarkMode(context)
                      ? AppColors.lightBlueColor3e3
                      : Color(0xff1C2A3A)
                  : ThemeUtil.isDarkMode(context)
                      ? Color(0xff121212)
                      : Color(0xffF9FAFB),
              textColor: selectedField == 2
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Color(0xff9CA3AF),
            ),
            RoundedButtonSmall(
              text: "Continue as Blood bank",
              onPressed: () {
                _selectButton(3);
                widget.callback(selectedField!);
                Get.back();
              },
              backgroundColor: selectedField == 3
                  ? ThemeUtil.isDarkMode(context)
                      ? AppColors.lightBlueColor3e3
                      : Color(0xff1C2A3A)
                  : ThemeUtil.isDarkMode(context)
                      ? Color(0xff121212)
                      : Color(
                          0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 3
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Color(0xff9CA3AF),
            ),
            RoundedButtonSmall(
              text: "Continue as Hospital",
              onPressed: () {
                _selectButton(4);
                widget.callback(selectedField!);
                Get.back();
              },
              backgroundColor: selectedField == 4
                  ? ThemeUtil.isDarkMode(context)
                      ? AppColors.lightBlueColor3e3
                      : Color(0xff1C2A3A)
                  : ThemeUtil.isDarkMode(context)
                      ? Color(0xff121212)
                      : Color(
                          0xffF9FAFB), // Change background color based on selection
              textColor: selectedField == 4
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Color(0xff9CA3AF),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void navigateToFormScreen({
  required BuildContext context,
  required int selectedFieldValue,
  required String email,
  required String password,
  required String name,
}) {
  Widget? destinationScreen;

  switch (selectedFieldValue) {
    case 1:
      destinationScreen = DoctorFormScreen(
        isSocial: true,
        email: email,
        password: password,
        name: name,
      );
      break;
    case 2:
      destinationScreen = PharmacyFormScreen(
        isSocial: true,
        email: email,
        password: password,
        name: name,
      );
      break;
    case 3:
      destinationScreen = BloodBankFormScreen(
        isSocial: true,
        email: email,
        password: password,
        name: name,
      );
      break;
    case 4:
      destinationScreen = HospitalFormScreen(
        isSocial: true,
        email: email,
        password: password,
        name: name,
      );
      break;
    default:
      print('Invalid selectedFieldValue: $selectedFieldValue');
      return;
  }

  if (destinationScreen != null) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => destinationScreen!),
    );
  }
}
