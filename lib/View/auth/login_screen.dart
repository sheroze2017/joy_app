import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/view/auth/signup_screen.dart';
import 'package:joy_app/view/auth/passwordReset/forgot_pass_screen.dart';
import 'package:joy_app/view/home/navbar.dart';
import 'package:joy_app/view/social_media/chats.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../controller/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void changeFocus(
      FocusNode currentFocus, nextFocus, TextEditingController controller) {
    if (currentFocus.hasFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final themeController = Get.put(ColorController());
    final HomeController _controller = Get.put(HomeController());

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  "Hi, Welcome Back! ",
                  style: CustomTextStyles.darkTextStyle(),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Hope you’re doing fine.",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _emailController,
                    hintText: 'Your Email',
                    icon: 'Assets/images/sms.svg',
                    textInputType: TextInputType.emailAddress),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  focusNode: _focusNode2,
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
                          text: "Sign In",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            print(_emailController.text);
                            print(_passwordController.text);
                            if (_emailController.text.toLowerCase().trim() ==
                                    'pharmacy@gmail.com' &&
                                _passwordController.text.toLowerCase().trim() ==
                                    'admin123') {
                              print(_emailController.text);
                              print(_passwordController.text);
                              Get.to(NavBarScreen(
                                isPharmacy: true,
                              ));
                            } else if (_emailController.text
                                        .toLowerCase()
                                        .trim() ==
                                    'bloodbank@gmail.com' &&
                                _passwordController.text.toLowerCase().trim() ==
                                    'admin123') {
                              Get.to(NavBarScreen(
                                isBloodBank: true,
                              ));
                            } else if (_emailController.text
                                        .toLowerCase()
                                        .trim() ==
                                    'doctor@gmail.com' &&
                                _passwordController.text.toLowerCase().trim() ==
                                    'admin123') {
                              Get.to(NavBarScreen(
                                isDoctor: true,
                              ));
                            } else if (_emailController.text
                                        .toLowerCase()
                                        .trim() ==
                                    'user@gmail.com' &&
                                _passwordController.text.toLowerCase().trim() ==
                                    'admin123') {
                              Get.to(NavBarScreen(isUser: true));
                            } else if (_emailController.text
                                        .toLowerCase()
                                        .trim() ==
                                    'hospital@gmail.com' &&
                                _passwordController.text.toLowerCase().trim() ==
                                    'admin123') {
                              Get.to(NavBarScreen(
                                isHospital: true,
                              ));
                            } else {
                              Get.snackbar('Error', 'Invalid Credentials');
                            }
                          },
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xffFFFFFF)),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Divider()),
                    Center(
                      child: Text(
                        '  Or sign in with  ',
                        style: CustomTextStyles.lightSmallTextStyle(),
                      ),
                    ),
                    Expanded(child: Divider())
                  ],
                ),
                SizedBox(height: 3.h),
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
                SizedBox(height: 3.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Forgot Password?',
                        style: const TextStyle(
                          color: Color(0xff1C64F2),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(ForgotPassScreen());
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don’t have an account yet? ',
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(
                          color: Color(0xff1C64F2),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(SignupScreen());
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
