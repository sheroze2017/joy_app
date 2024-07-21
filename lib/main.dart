import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/common/notification/api/firebase_api.dart';
import 'package:joy_app/common/theme/controller/theme_controller.dart';
import 'package:joy_app/common/theme/theme_controller.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/modules/auth/bloc/auth_bloc.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_hive_model.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:joy_app/styles/theme.dart';
import 'package:joy_app/view/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyD9VoJD6i_LQ6dFH3JQsZO_z4RlPYki4rk',
    appId: '1:850638861206:android:98362d7a24d2c2dc2de3b7',
    messagingSenderId: '850638861206',
    projectId: 'joyapp-34878',
  ));
  await FirebaseApi().initNotification();

  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveAdapter());
  Hive.registerAdapter(DoctorDetailModelAdapter());
  Hive.registerAdapter(DataModelAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  Hive.registerAdapter(GiveByModelAdapter());
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
    Get.put(MediaPostController());
    Get.put(AuthController());
    Get.put(LocationController());
    Get.put(ChatController());
  }
}
