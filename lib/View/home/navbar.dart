import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/Signup/login_screen.dart';
import 'package:joy_app/View/Signup/signup_screen.dart';
import 'package:joy_app/View/home/home_screen.dart';
import 'package:joy_app/View/home/notification_screen.dart';
import 'package:joy_app/View/home/profile_screen.dart';
import 'package:joy_app/controller/navbar_controller.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarScreen> {
  final navbarController = Get.put(NavBarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (context) {
      return Scaffold(
        body: IndexedStack(
          index: navbarController.tabIndex,
          children: [
            LoginScreen(),
            SignupScreen(),
            NotificationScreen(),
            HomeScreen(),
            ProfileScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navbarController.tabIndex,
          onTap: navbarController.changeTabIndex,
          items: [
            _bottomBarItem(Icons.home),
            _bottomBarItem(Icons.home),
            _bottomBarItem(Icons.home),
            _bottomBarItem(Icons.home),
            _bottomBarItem(Icons.home)
          ],
        ),
      );
    });
  }

  _bottomBarItem(IconData icon) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: Colors.black,
        ),
        label: '');
  }
}
