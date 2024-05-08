import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/passwordReset/new_pass_screen.dart';
import 'package:joy_app/View/passwordReset/verify_code_screen.dart';
import 'package:joy_app/routes/routes.dart';
import 'package:sizer/sizer.dart';

import 'View/home/editprofile_screen.dart';
import 'View/home/notification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // initialRoute: AppPage.getNavbar(),
        getPages: AppPage.routes,
      );
    });
  }
}
