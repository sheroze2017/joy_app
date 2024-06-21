import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/view/login_screen.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/utils/constant/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final _pageController = PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            padEnds: false,
            controller: _pageController,
            children: [
              OnBoardPage(
                image: CustomConstant.onboardImage1,
                title: CustomConstant.onboardTitle1,
                desc: CustomConstant.onboardDesc1,
              ),
              OnBoardPage(
                image: CustomConstant.onboardImage2,
                title: CustomConstant.onboardTitle2,
                desc: CustomConstant.onboardDesc2,
              ),
              OnBoardPage(
                image: CustomConstant.onboardImage3,
                title: CustomConstant.onboardTitle3,
                desc: CustomConstant.onboardDesc3,
              )
            ],
          ),
          Positioned(
              right: 24,
              left: 24,
              bottom: 80,
              child: Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? AppColors.lightBlueColor3e3
                          : Color(0xff1C2A3A),
                      text: 'Next',
                      onPressed: () {
                        if (_pageController.page == 2) {
                          Get.offAll(LoginScreen(),
                              transition: Transition.native);
                        }
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      textColor: ThemeUtil.isDarkMode(context)
                          ? Color(0xff0D0D0D)
                          : Color(0xffE5E7EB),
                    ),
                  ),
                ],
              )),
          Positioned(
            bottom: 50,
            right: 0,
            left: 0,
            child: Center(
              child: SmoothPageIndicator(
                onDotClicked: (index) {
                  _pageController.jumpToPage(index);
                },
                controller: _pageController,
                count: 3,
                axisDirection: Axis.horizontal,
                effect: ExpandingDotsEffect(
                    dotWidth: 1.5.h,
                    dotHeight: 1.2.h,
                    dotColor: Colors.grey,
                    activeDotColor: ThemeUtil.isDarkMode(context)
                        ? AppColors.lightBlueColor3e3
                        : Color(0xff26232F)),
              ),
            ),
          ),
          Positioned(
              right: 0,
              left: 0,
              bottom: 15,
              child: InkWell(
                onTap: () {
                  Get.to(LoginScreen());
                },
                child: Center(
                    child:
                        Text('Skip', style: CustomTextStyles.lightTextStyle())),
              )),
        ],
      ),
    );
  }
}

class OnBoardPage extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const OnBoardPage(
      {super.key,
      required this.image,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        Container(
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  title,
                  style: CustomTextStyles.darkHeadingTextStyle(
                      size: 18, color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  desc,
                  style: CustomTextStyles.lightTextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffAAAAAA)
                          : null),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
