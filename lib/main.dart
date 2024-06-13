import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/controller/theme_controller.dart';
import 'package:joy_app/styles/theme.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/auth/login_screen.dart';
import 'package:joy_app/view/home/navbar.dart';
import 'package:joy_app/view/splash_screen.dart';
import 'package:joy_app/view/user_flow/bloodbank_user/request_blood.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ColorController());

    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Joy App',
          theme: MyAppThemes.lightTheme,
          darkTheme: MyAppThemes.darkTheme,
          themeMode: ThemeMode.system,
          // theme: ThemeData(
          //   useMaterial3: true,
          // ),
          // initialRoute: AppPage.getNavbar(),
          //getPages: AppPage.routes,
          home: SplashScreen()
          //initialBinding: YourBinding(),
          );
    });
  }
}

class YourBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ColorController());
  }
}
