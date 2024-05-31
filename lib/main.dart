import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/view/home/navbar.dart';
import 'package:joy_app/view/splash_screen.dart';
import 'package:joy_app/controller/theme_controller.dart';
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
          // theme: CustomTheme.lightTheme,
          // darkTheme: CustomTheme.darkTheme,
          // themeMode: ThemeMode.system,
          theme: ThemeData(
            useMaterial3: true,
          ),
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
