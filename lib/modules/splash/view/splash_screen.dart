import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/bloc/auth_bloc.dart';
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
    try {
      print('');
      print('🚀 [SplashScreen] ========== SPLASH SCREEN - CHECKING USER ==========');
      print('🚀 [SplashScreen] App started, checking for logged in user...');
      
      UserHive? currentUser = await getCurrentUser();
      if (currentUser != null) {
        print('✅ [SplashScreen] User found:');
        print('   - User ID: ${currentUser.userId}');
        print('   - Name: ${currentUser.firstName}');
        print('   - Email: ${currentUser.email}');
        print('   - Role: ${currentUser.userRole}');
        print('   - Current Device Token: ${currentUser.deviceToken}');
        print('');
        print('');
        print('🔄 [SplashScreen] ========== FETCHING UPDATED USER PROFILE ==========');
        print('🔄 [SplashScreen] Fetching updated user object from backend...');
        print('🔄 [SplashScreen] User ID: ${currentUser.userId}');
        print('🔄 [SplashScreen] ===================================================');
        print('');
        
        final authController = Get.find<AuthController>();
        
        // Fetch and update user profile from backend
        await authController.fetchAndUpdateUserProfile(
            currentUser.userId.toString());
        
        // Get updated user after profile fetch
        currentUser = await getCurrentUser();
        
        print('');
        print('🔄 [SplashScreen] ========== CALLING updateDeviceTokenForUser() ==========');
        print('🔄 [SplashScreen] Updating device token on backend...');
        print('🔄 [SplashScreen] User ID: ${currentUser?.userId}');
        print('🔄 [SplashScreen] ======================================================');
        print('');
        
        if (currentUser != null) {
          await authController.updateDeviceTokenForUser(
              currentUser.userId.toString());
        }
        
        print('');
        print('✅ [SplashScreen] ========== updateDeviceTokenForUser() RETURNED ==========');
        print('✅ [SplashScreen] Device token update process completed');
        print('✅ [SplashScreen] Check logs above for success/failure details');
        print('✅ [SplashScreen] ========================================================');
        print('');
        print('🚀 [SplashScreen] Navigating to user dashboard in 5 seconds...');
        print('🚀 [SplashScreen] =================================================');
        print('');
        
        // Get updated user role after profile fetch
        final updatedUser = await getCurrentUser();
        final userRole = updatedUser?.userRole ?? currentUser?.userRole ?? 'USER';
        
        Timer(Duration(seconds: 5),
            () => handleUserRoleNavigation(userRole));
      } else {
        print('ℹ️ [SplashScreen] No user found, redirecting to onboarding');
        print('🚀 [SplashScreen] =================================================');
        print('');
        Timer(Duration(seconds: 5), () => Get.offAll(OnboardingScreen()));
      }
    } catch (e) {
      print('');
      print('❌ [SplashScreen] ========== ERROR IN SPLASH SCREEN ==========');
      print('❌ [SplashScreen] Error checking user: $e');
      print('❌ [SplashScreen] Error type: ${e.runtimeType}');
      // If there's a Hive corruption error, clear data and go to onboarding
      if (e.toString().contains('is not a subtype') || 
          e.toString().contains('type cast') ||
          e.toString().contains('subtype')) {
        print('⚠️ [SplashScreen] Hive data corruption detected, clearing and redirecting to onboarding');
        clearUserInformation();
      }
      print('❌ [SplashScreen] ===========================================');
      print('');
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
