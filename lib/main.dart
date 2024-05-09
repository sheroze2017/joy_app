import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/Signup/login_screen.dart';
import 'package:joy_app/View/passwordReset/new_pass_screen.dart';
import 'package:joy_app/View/passwordReset/verify_code_screen.dart';
import 'package:joy_app/controller/theme_controller.dart';
import 'package:joy_app/routes/routes.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

import 'View/home/editprofile_screen.dart';
import 'View/home/notification_screen.dart';
import 'View/onboarding/onboarding_screen.dart';
import 'View/profile/my_profile.dart';

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
        // theme: CustomTheme.lightTheme,
        // darkTheme: CustomTheme.darkTheme,
        // themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // initialRoute: AppPage.getNavbar(),
        //getPages: AppPage.routes,
        home: MyProfileScreen(),
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
