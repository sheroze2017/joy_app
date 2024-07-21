import 'package:get/get.dart';
import 'package:joy_app/modules/auth/view/login_screen.dart';
import 'package:joy_app/modules/auth/view/signup_screen.dart';
import 'package:joy_app/view/home/navbar.dart';
import 'package:joy_app/view/home/notification_screen.dart';

class AppPage {
  static List<GetPage> routes = [
    GetPage(name: navbar, page: () => NavBarScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignupScreen()),
    GetPage(name: notification, page: () => NotificationScreen()),
  ];

  static get getNavbar => navbar;
  static get getHome => home;
  static get getLogin => login;
  static get getSignup => signup;
  static get getNotification => notification;

  static String navbar = '/';
  static String home = '/home';
  static String notification = '/notification';
  static String login = '/login';
  static String signup = '/signup';
}
