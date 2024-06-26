import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/controller/theme_controller.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/view/login_screen.dart';
import 'package:joy_app/view/doctor_booking/doctor_detail_screen.dart';
import 'package:joy_app/view/doctor_booking/manage_booking.dart';
import 'package:joy_app/view/doctor_flow/manage_appointment.dart';
import 'package:joy_app/view/home/editprofile_screen.dart';
import 'package:joy_app/view/home/notification_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  bool isDoctor;
  ProfileScreen({this.isDoctor = false});
  @override
  State<ProfileScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<ProfileScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();
  final ThemeController _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Profile',
        leading: Icon(Icons.arrow_back),
        actions: [],
        showIcon: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   'Profile',
              //   style: CustomTextStyles.darkTextStyle(),
              // ),
              Stack(
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset('Assets/images/profile-circle.svg'),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 90,
                    child: SvgPicture.asset('Assets/images/message-edit.svg'),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Sheroze Rehman',
                style: CustomTextStyles.darkHeadingTextStyle(
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : null),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text('+123 856479683', style: CustomTextStyles.lightTextStyle()),
              SizedBox(
                height: 2.h,
              ),
              InkWell(
                onTap: () {
                  widget.isDoctor == true
                      ? Get.to(DoctorDetailScreen(
                          docName: 'Dr David Patel',
                          location: 'USA Cantucky',
                          Category: 'Cardiologist',
                          isDoctor: widget.isDoctor,
                        ))
                      : Get.to(EditProfile());
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'Assets/images/user-edit.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Edit Profile',
                        style: CustomTextStyles.lightTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : Color(0xff6B7280),
                            size: 18),
                      ),
                    ),
                    SvgPicture.asset(
                      'Assets/images/arrow-right.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Color(0xffE5E7EB),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(NotificationScreen(showBackIcon: true));
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'Assets/images/notification.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Notifications',
                        style: CustomTextStyles.lightTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : Color(0xff6B7280),
                            size: 18),
                      ),
                    ),
                    SvgPicture.asset(
                      'Assets/images/arrow-right.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Color(0xffE5E7EB),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(ManageAllAppointmentUser());
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'Assets/images/appointment.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Appointments',
                        style: CustomTextStyles.lightTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : Color(0xff6B7280),
                            size: 18),
                      ),
                    ),
                    SvgPicture.asset(
                      'Assets/images/arrow-right.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Color(0xffE5E7EB),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.sunny),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: Text(
                      'Switch Theme',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : Color(0xff6B7280),
                          size: 18),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.dark_mode),
                    onPressed: () {
                      _themeController.toggleTheme();
                    },
                  ),
                  Switch(
                    value: _themeController.isDarkMode,
                    onChanged: (value) {
                      _themeController.toggleTheme();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.light_mode),
                    onPressed: () {
                      _themeController.toggleTheme();
                    },
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Color(0xffE5E7EB),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(54)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Logout',
                                style: CustomTextStyles.darkTextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Divider(
                                  color: Color(0xffE5E7EB),
                                ),
                              ),
                              Text(
                                'Are you sure you want to log out?',
                                style: CustomTextStyles.w600TextStyle(),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: RoundedButton(
                                      text: "Cancel",
                                      onPressed: () {
                                        Get.back();
                                      },
                                      backgroundColor:
                                          ThemeUtil.isDarkMode(context)
                                              ? Color(0xff1F2228)
                                              : Color(0xffE5E7EB),
                                      textColor: ThemeUtil.isDarkMode(context)
                                          ? AppColors.lightBlueColor3e3
                                          : Color(0xff1C2A3A),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Expanded(
                                    child: RoundedButton(
                                        text: "Yes, Logout",
                                        onPressed: () {
                                          clearUserInformation();
                                          Get.offAll(LoginScreen());
                                        },
                                        backgroundColor:
                                            ThemeUtil.isDarkMode(context)
                                                ? AppColors.lightBlueColor3e3
                                                : Color(0xff1C2A3A),
                                        textColor: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'Assets/images/logout.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Log Out',
                        style: CustomTextStyles.lightTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : Color(0xff6B7280),
                            size: 18),
                      ),
                    ),
                    SvgPicture.asset(
                      'Assets/images/arrow-right.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
