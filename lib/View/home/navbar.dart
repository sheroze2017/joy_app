import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/user_flow/Doctor_flow/home_screen.dart';
import 'package:joy_app/View/user_flow/Doctor_flow/manage_appointment.dart';
import 'package:joy_app/View/Pharmacy_flow/product_screen.dart';
import 'package:joy_app/View/Signup/signup_screen.dart';
import 'package:joy_app/View/home/home_screen.dart';
import 'package:joy_app/View/home/notification_screen.dart';
import 'package:joy_app/View/home/profile_screen.dart';
import 'package:joy_app/View/social_media/add_friend.dart';
import 'package:joy_app/controller/navbar_controller.dart';
import 'package:joy_app/styles/colors.dart';

import '../Pharmacy_flow/home_screen.dart';

class NavBarScreen extends StatefulWidget {
  final bool? isDoctor;
  final bool? isPharmacy;
  final bool? isBloodBank;
  const NavBarScreen(
      {super.key,
      this.isDoctor = false,
      this.isPharmacy = false,
      this.isBloodBank = false});
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
                  ProfileScreen()
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
                : IndexedStack(
                    index: navbarController.tabIndex,
                    children: [
                      HomeScreen(),
                      AddFriend(),
                      SignupScreen(),
                      NotificationScreen(),
                      ProfileScreen()
                    ],
                  ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: navbarController.tabIndex,
          onTap: navbarController.changeTabIndex,
          items: widget.isDoctor == true
              ? [
                  _bottomBarItem(
                      'Assets/icons/home.svg', 'Assets/icons/Profile.svg'),
                  _bottomBarItem('Assets/icons/calendar.svg',
                      'Assets/icons/calenderbground.svg'),
                  _bottomBarItem('Assets/icons/notification.svg',
                      'Assets/icons/notificationdark.svg'),
                  _bottomBarItem(
                      'Assets/icons/frame.svg', 'Assets/icons/profiledark.svg'),
                ]
              : widget.isPharmacy == true
                  ? [
                      _bottomBarItem(
                          'Assets/icons/home.svg', 'Assets/icons/Profile.svg'),
                      _bottomBarItem('Assets/icons/cartsilver.svg',
                          'Assets/icons/cartbground.svg'),
                      _bottomBarItem('Assets/icons/notification.svg',
                          'Assets/icons/notificationdark.svg'),
                      _bottomBarItem('Assets/icons/frame.svg',
                          'Assets/icons/profiledark.svg'),
                    ]
                  : [
                      _bottomBarItem(
                          'Assets/icons/home.svg', 'Assets/icons/Profile.svg'),
                      _bottomBarItem('Assets/icons/health-care.svg', ''),
                      _bottomBarItem('Assets/icons/profile-2light.svg',
                          'Assets/icons/person2dark.svg'),
                      _bottomBarItem('Assets/icons/notification.svg',
                          'Assets/icons/notificationdark.svg'),
                      _bottomBarItem('Assets/icons/frame.svg',
                          'Assets/icons/profiledark.svg'),
                    ],
        ),
      );
    });
  }

  _bottomBarItem(String asset, String activeSting) {
    return BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          activeSting,
        ),
        icon: SvgPicture.asset(
          asset,
          color: AppColors.borderColor,
        ),
        label: '');
  }
}
