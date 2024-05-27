import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/onboarding/onboarding_screen.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the onboarding screen after 5 seconds
    Timer(Duration(seconds: 5), () => Get.offAll(OnboardingScreen()));
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
                height: 30.h,
                width: 23.46.w,
                decoration: BoxDecoration(
                    color: Color(0xffACA1CD),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(24))),
              ),
              Container(
                  height: 30.h,
                  width: 46.93.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24))),
                  child: Image.asset(
                      fit: BoxFit.cover,
                      width: 46.93.w,
                      'Assets/images/splash/sp1.png')),
              Container(
                height: 30.h,
                width: 23.46.w,
                decoration: BoxDecoration(
                    color: Color(0xffADC9497),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(24))),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 37.7.h,
                  width: 23.46.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Image.asset(
                    'Assets/images/splash/sp2.png',
                    height: 30.h,
                    width: 23.46.w,
                    fit: BoxFit.cover,
                  )),
              Container(
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
                child: Image.asset(scale: 1.3, 'Assets/images/splash/main.png'),
              ),
              Container(
                height: 37.7.h,
                width: 23.46.w,
                decoration: BoxDecoration(
                    color: Color(0xffACA1CD),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        topLeft: Radius.circular(24))),
                child: Image.asset('Assets/images/splash/sp3.png'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30.h,
                width: 23.46.w,
                decoration: BoxDecoration(
                    color: Color(0xffD7A99C),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(24))),
              ),
              Container(
                  height: 30.h,
                  width: 46.93.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Image.asset('Assets/images/splash/sp4.png')),
              Container(
                height: 30.h,
                width: 23.46.w,
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
