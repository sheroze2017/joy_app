import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/utils/route.dart';
import 'package:joy_app/common/onboarding/onboarding_screen.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserAndRoute();
  }

  checkUserAndRoute() async {
    UserHive? currentUser = await getCurrentUser();
    if (currentUser != null) {
      Timer(Duration(seconds: 5),
          () => handleUserRoleNavigation(currentUser.userRole));
    } else {
      Timer(Duration(seconds: 5), () => Get.offAll(OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 24.93.w,
                height: 30.h,
                decoration: BoxDecoration(
                    color: Color(0xffACA1CD),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(24))),
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                child: Container(
                    height: 30.h,
                    width: 46.93.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                        child: Image.asset(
                          'Assets/images/splash/sp1.png',
                          fit: BoxFit.fill,
                        ))),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                height: 30.h,
                width: 24.93.w,
                decoration: BoxDecoration(
                    color: Color(0xffADC9497),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(24))),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 37.7.h,
                width: 24.93.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    'Assets/images/splash/sp2.png',
                    height: 30.h,
                    width: 24.93.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                child: Container(
                  height: 37.7.h,
                  width: 46.93.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24)),
                  ),
                  child:
                      Image.asset(scale: 1.3, 'Assets/images/splash/main.png'),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                height: 37.7.h,
                width: 24.93.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                  child: Image.asset(
                    'Assets/images/splash/sp3.png',
                    height: 30.h,
                    width: 24.93.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 30.h,
                width: 24.93.w,
                decoration: BoxDecoration(
                    color: Color(0xffD7A99C),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(24))),
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                child: Container(
                    height: 30.h,
                    width: 46.93.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24),
                            topLeft: Radius.circular(24))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          topLeft: Radius.circular(24),
                        ),
                        child: Image.asset(
                          'Assets/images/splash/sp4.png',
                          fit: BoxFit.fill,
                        ))),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                height: 30.h,
                width: 24.93.w,
                decoration: BoxDecoration(
                    color: Color(0xff4D9B91),
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(24))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
