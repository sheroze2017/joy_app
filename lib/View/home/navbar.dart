import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/bloodbank_flow/blood_appeal_screen.dart';
import 'package:joy_app/view/bloodbank_flow/home_screen.dart';
import 'package:joy_app/view/bloodbank_flow/profile_form.dart';
import 'package:joy_app/view/doctor_flow/home_screen.dart';
import 'package:joy_app/view/doctor_flow/manage_appointment.dart';
import 'package:joy_app/view/pharmacy_flow/product_screen.dart';
import 'package:joy_app/view/auth/signup_screen.dart';
import 'package:joy_app/view/home/blog_screen.dart';
import 'package:joy_app/view/home/home_screen.dart';
import 'package:joy_app/view/home/notification_screen.dart';
import 'package:joy_app/view/home/profile_screen.dart';
import 'package:joy_app/view/hospital_flow/dashboard.dart';
import 'package:joy_app/view/hospital_flow/home_screen.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:joy_app/view/social_media/add_friend.dart';
import 'package:joy_app/controller/navbar_controller.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:sizer/sizer.dart';

import '../pharmacy_flow/home_screen.dart';

class NavBarScreen extends StatefulWidget {
  final bool? isDoctor;
  final bool? isPharmacy;
  final bool? isBloodBank;
  final bool? isHospital;
  final bool? isUser;
  const NavBarScreen(
      {super.key,
      this.isDoctor = false,
      this.isPharmacy = false,
      this.isBloodBank = false,
      this.isHospital = false,
      this.isUser = false});
  @override
  State<NavBarScreen> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarScreen> {
  final navbarController = Get.put(NavBarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (context) {
      return Scaffold(
        body: widget.isDoctor == true
            ? IndexedStack(
                index: navbarController.tabIndex,
                children: [
                  DoctorHomeScreen(),
                  ManageAppointment(),
                  NotificationScreen(),
                  ProfileScreen(
                    isDoctor: true,
                  )
                ],
              )
            : widget.isPharmacy == true
                ? IndexedStack(
                    index: navbarController.tabIndex,
                    children: [
                      PharmacyHomeScreen(),
                      ProductScreen(),
                      NotificationScreen(),
                      ProfileScreen()
                    ],
                  )
                : widget.isBloodBank == true
                    ? IndexedStack(
                        index: navbarController.tabIndex,
                        children: [
                          BloodBankHomeScreen(),
                          BloodDonationAppeal(
                            isBloodDontate: true,
                          ),
                          NotificationScreen(),
                          ProfileScreen()
                        ],
                      )
                    : widget.isHospital == true
                        ? IndexedStack(
                            index: navbarController.tabIndex,
                            children: [
                              HospitalDashBoard(),
                              HospitalHomeScreen(
                                isHospital: true,
                              ),
                              NotificationScreen(),
                              ProfileScreen()
                            ],
                          )
                        : widget.isUser == true
                            ? IndexedStack(
                                index: navbarController.tabIndex,
                                children: [
                                  UserBlogScreen(),
                                  AddFriend(),
                                  HomeScreen(),
                                  NotificationScreen(),
                                  MyProfileScreen()
                                ],
                              )
                            : IndexedStack(
                                index: navbarController.tabIndex,
                                children: [],
                              ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: navbarController.tabIndex,
          onTap: navbarController.changeTabIndex,
          items: widget.isDoctor == true
              ? [
                  _bottomBarItem(
                      'Assets/icons/home.svg', 'Assets/icons/homebold.svg'),
                  _bottomBarItem('Assets/icons/calendar.svg',
                      'Assets/icons/calendardark.svg'),
                  _bottomBarItem('Assets/icons/notification.svg',
                      'Assets/icons/notificationbold.svg'),
                  _bottomBarItem(
                      'Assets/icons/frame.svg', 'Assets/icons/profilebold.svg'),
                ]
              : widget.isPharmacy == true
                  ? [
                      _bottomBarItem(
                          'Assets/icons/home.svg', 'Assets/icons/homebold.svg'),
                      _bottomBarItem('Assets/icons/cartsilver.svg',
                          'Assets/icons/cartdark.svg'),
                      _bottomBarItem('Assets/icons/notification.svg',
                          'Assets/icons/notificationbold.svg'),
                      _bottomBarItem('Assets/icons/frame.svg',
                          'Assets/icons/profilebold.svg'),
                    ]
                  : widget.isBloodBank == true
                      ? [
                          _bottomBarItem('Assets/icons/home.svg',
                              'Assets/icons/homebold.svg'),
                          _bottomBarItem('Assets/icons/health-care.svg',
                              'Assets/icons/healthbold.svg'),
                          _bottomBarItem('Assets/icons/notification.svg',
                              'Assets/icons/notificationbold.svg'),
                          _bottomBarItem('Assets/icons/frame.svg',
                              'Assets/icons/profilebold.svg'),
                        ]
                      : widget.isHospital == true
                          ? [
                              _bottomBarItem('Assets/icons/home.svg',
                                  'Assets/icons/homebold.svg'),
                              _bottomBarItem('Assets/icons/health-care.svg',
                                  'Assets/icons/healthbold.svg'),
                              _bottomBarItem('Assets/icons/notification.svg',
                                  'Assets/icons/notificationbold.svg'),
                              _bottomBarItem('Assets/icons/frame.svg',
                                  'Assets/icons/profilebold.svg'),
                            ]
                          : widget.isUser == true
                              ? [
                                  _bottomBarItem('Assets/icons/home.svg',
                                      'Assets/icons/homebold.svg'),
                                  _bottomBarItem(
                                      'Assets/icons/profile-2light.svg',
                                      'Assets/icons/profile-2user.svg'),
                                  _bottomBarItem('Assets/icons/health-care.svg',
                                      'Assets/icons/healthbold.svg'),
                                  _bottomBarItem(
                                      'Assets/icons/notification.svg',
                                      'Assets/icons/notificationbold.svg'),
                                  _bottomBarItem('Assets/icons/frame.svg',
                                      'Assets/icons/profilebold.svg'),
                                ]
                              : [],
        ),
      );
    });
  }

  _bottomBarItem(String asset, String activeSting) {
    return BottomNavigationBarItem(
        activeIcon: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.blackColor171
                  : AppColors.silverColor4f6),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              activeSting,
              color: ThemeUtil.isDarkMode(context) ? Color(0xffCDD1D6) : null,
              height: 3.h,
            ),
          ),
        ),
        icon: SvgPicture.asset(
          asset,
          color: AppColors.borderColor,
        ),
        label: '');
  }
}
