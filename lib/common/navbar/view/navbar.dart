import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/blood_appeal_screen.dart';
import 'package:joy_app/modules/blood_bank/view/home_screen.dart';
import 'package:joy_app/modules/doctor/view/all_appointment.dart';
import 'package:joy_app/modules/doctor/view/home_screen.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/product_screen.dart';
import 'package:joy_app/modules/user/user_home/view/blog_screen.dart';
import 'package:joy_app/modules/user/user_home/view/home_screen.dart';
import 'package:joy_app/modules/notification/notification_screen.dart';
import 'package:joy_app/modules/doctor/view/profile_screen.dart';
import 'package:joy_app/modules/hospital/view/home_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/view/add_friend.dart';
import 'package:joy_app/common/navbar/controller/navbar_controller.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/widgets/dailog/app_exit_dailog.dart';
import 'package:sizer/sizer.dart';

import '../../../modules/user/user_pharmacy/all_pharmacy/view/home_screen.dart';

class NavBarScreen extends StatefulWidget {
  final bool? isDoctor;
  final bool? isPharmacy;
  final bool? isBloodBank;
  final bool? isHospital;
  final bool? isUser;
  String? hospitalDetailId;
  NavBarScreen(
      {super.key,
      this.isDoctor = false,
      this.isPharmacy = false,
      this.isBloodBank = false,
      this.isHospital = false,
      this.isUser = false,
      this.hospitalDetailId});
  @override
  State<NavBarScreen> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarScreen> {
  final navbarController = Get.put(NavBarController());
  ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ExitAppDialog();
            },
          );
        },
        child: GetBuilder(
            init: NavBarController(), // Initialize your controller here
            builder: (context) {
              return Scaffold(
                body: widget.isDoctor == true
                    ? IndexedStack(
                        index: navbarController.tabIndex,
                        children: [
                          DoctorHomeScreen(),
                          AllAppointments(),
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
                              ProductScreen(
                                isAdmin: true,
                                userId: '3',
                              ),
                              NotificationScreen(),
                              ProfileScreen(isPharmacy: true)
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
                                  ProfileScreen(
                                    isBloodbank: true,
                                  )
                                ],
                              )
                            : widget.isHospital == true
                                ? IndexedStack(
                                    index: navbarController.tabIndex,
                                    children: [
                                      HospitalHomeScreen(
                                        isHospital: true,
                                        //      hospitalId: widget.hospitalDetailId,
                                      ),
                                      NotificationScreen(),
                                      ProfileScreen(
                                        isHospital: true,
                                      )
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
                                          MyProfileScreen(
                                            myProfile: false,
                                          )
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
                          _bottomBarItem('Assets/icons/home.svg',
                              'Assets/icons/homebold.svg'),
                          _bottomBarItem('Assets/icons/calendar.svg',
                              'Assets/icons/calendardark.svg'),
                          _bottomBarItem('Assets/icons/notification.svg',
                              'Assets/icons/notificationbold.svg'),
                          _bottomBarItem('Assets/icons/frame.svg',
                              'Assets/icons/profilebold.svg'),
                        ]
                      : widget.isPharmacy == true
                          ? [
                              _bottomBarItem('Assets/icons/home.svg',
                                  'Assets/icons/homebold.svg'),
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
                                  _bottomBarItem(
                                      'Assets/icons/notification.svg',
                                      'Assets/icons/notificationbold.svg'),
                                  _bottomBarItem('Assets/icons/frame.svg',
                                      'Assets/icons/profilebold.svg'),
                                ]
                              : widget.isHospital == true
                                  ? [
                                      _bottomBarItem(
                                          'Assets/icons/health-care.svg',
                                          'Assets/icons/healthbold.svg'),
                                      _bottomBarItem(
                                          'Assets/icons/notification.svg',
                                          'Assets/icons/notificationbold.svg'),
                                      _bottomBarItem('Assets/icons/frame.svg',
                                          'Assets/icons/profilebold.svg'),
                                    ]
                                  : widget.isUser == true
                                      ? [
                                          _bottomBarItem(
                                              'Assets/icons/home.svg',
                                              'Assets/icons/homebold.svg'),
                                          _bottomBarItem(
                                              'Assets/icons/profile-2light.svg',
                                              'Assets/icons/profile-2user.svg'),
                                          _bottomBarItem(
                                              'Assets/icons/health-care.svg',
                                              'Assets/icons/healthbold.svg'),
                                          _bottomBarItem(
                                              'Assets/icons/notification.svg',
                                              'Assets/icons/notificationbold.svg'),
                                          _bottomBarItem(
                                              'Assets/icons/frame.svg',
                                              'Assets/icons/profilebold.svg'),
                                        ]
                                      : [],
                ),
              );
            }));
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
