import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/view/Signup/login_screen.dart';
import 'package:joy_app/view/doctor_booking/manage_booking.dart';
import 'package:joy_app/view/doctor_flow/manage_appointment.dart';
import 'package:joy_app/view/home/editprofile_screen.dart';
import 'package:joy_app/view/home/notification_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<ProfileScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

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
        color: Color(0xffFFFFFF),
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
                style: CustomTextStyles.darkHeadingTextStyle(),
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
                  Get.to(EditProfile());
                },
                child: Row(
                  children: [
                    SvgPicture.asset('Assets/images/user-edit.svg'),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Edit Profile',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 18),
                      ),
                    ),
                    SvgPicture.asset('Assets/images/arrow-right.svg'),
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
                  Get.to(NotificationScreen());
                },
                child: Row(
                  children: [
                    SvgPicture.asset('Assets/images/notification.svg'),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Notifications',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 18),
                      ),
                    ),
                    SvgPicture.asset('Assets/images/arrow-right.svg'),
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
                    SvgPicture.asset('Assets/images/appointment.svg'),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Appointments',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 18),
                      ),
                    ),
                    SvgPicture.asset('Assets/images/arrow-right.svg'),
                  ],
                ),
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
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(54)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Logout',
                                style: CustomTextStyles.darkTextStyle(),
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
                                      backgroundColor: Color(0xffE5E7EB),
                                      textColor: Color(0xff1C2A3A),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Expanded(
                                    child: RoundedButton(
                                        text: "Yes, Logout",
                                        onPressed: () {
                                          Get.offAll(LoginScreen());
                                        },
                                        backgroundColor: Color(0xff1C2A3A),
                                        textColor: Color(0xffFFFFFF)),
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
                    SvgPicture.asset('Assets/images/logout.svg'),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: Text(
                        'Log Out',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 18),
                      ),
                    ),
                    SvgPicture.asset('Assets/images/arrow-right.svg'),
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
