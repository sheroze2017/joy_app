import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/common/controller/theme_controller.dart';
import 'package:joy_app/controller/theme_controller.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:joy_app/styles/theme.dart';
import 'package:joy_app/view/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ColorController());

    return Sizer(builder: (context, orientation, deviceType) {
      return Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Joy App',
          theme: MyAppThemes.lightTheme,
          darkTheme: MyAppThemes.darkTheme,
          themeMode:
              _themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          // theme: ThemeData(
          //   useMaterial3: true,
          // ),
          // initialRoute: AppPage.getNavbar(),
          //getPages: AppPage.routes,
          home: SplashScreen(),
          initialBinding: YourBinding(),
        ),
      );
    });
  }
}

class YourBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HospitalDetailController());
  }
}
