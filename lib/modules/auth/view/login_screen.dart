import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/auth/bloc/auth_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/view/password_reset/forgot_pass_screen.dart';
import 'package:joy_app/modules/auth/view/signup_screen.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';

import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../../common/theme/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authController = Get.put(AuthController());
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final dio = Dio();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        child: Form(
          key: _formKey,
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
                    style: CustomTextStyles.lightTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffAAAAAA)
                            : null),
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
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
                      controller: _emailController,
                      hintText: 'Your Email',
                      icon: 'Assets/images/sms.svg',
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: 2.h),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else {
                        return null;
                      }
                    },
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
                        child: Obx(() => RoundedButton(
                            showLoader: authController.loginLoader.value,
                            text: "Sign In",
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                              } else {
                                await authController.login(
                                    _emailController.text,
                                    _passwordController.text,
                                    context,
                                    "SOCIAL");
                              }
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC5D3E3)
                                : Color(0xff1C2A3A),
                            textColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xff121212)
                                : Color(0xffFFFFFF))),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          authController.signInWithGoogle(context);
                        },
                        child: RoundedContainer(
                          imagePath: 'Assets/images/google.png',
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          authController.signInWithFacebook(context);
                        },
                        child: RoundedContainer(
                          imagePath: 'Assets/images/facebook.png',
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          authController.signInWithApple(context);
                        },
                        child: RoundedContainer(
                          imagePath: 'Assets/images/apple.png',
                          isApple: true,
                        ),
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
                              Get.to(ForgotPassScreen(),
                                  transition: Transition.native);
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
                          style: CustomTextStyles.lightTextStyle(
                              color: ThemeUtil.isDarkMode(context)
                                  ? Color(0xffAAAAAA)
                                  : null),
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
                              Get.to(SignupScreen(),
                                  transition: Transition.native);
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

class RoundedContainer extends StatelessWidget {
  final String imagePath;
  bool isApple;
  RoundedContainer({Key? key, required this.imagePath, this.isApple = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color:
              ThemeUtil.isDarkMode(context) ? Color(0xff0D0D0D) : Colors.white,
          borderRadius: BorderRadius.circular(6.11),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              height: 2.h,
              imagePath,
              fit: BoxFit.scaleDown,
              color: isApple ? Theme.of(context).primaryColor : null,
            ),
          ),
        ),
      ),
    );
  }
}
