import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/theme/controller/theme_controller.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/view/profileform_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/view/login_screen.dart';
import 'package:joy_app/modules/blood_bank/view/profile_form.dart';
import 'package:joy_app/modules/doctor/view/doctor_detail_screen.dart';
import 'package:joy_app/modules/user/user_doctor/view/manage_booking.dart';
import 'package:joy_app/modules/doctor/view/all_appointment.dart';
import 'package:joy_app/modules/home/notification_screen.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/modules/hospital/view/profile_form.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/profile_form.dart';
import 'package:sizer/sizer.dart';

import '../../../common/profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  bool isDoctor;
  bool isPharmacy;
  bool isUser;
  bool isBloodbank;
  bool isHospital;
  ProfileScreen(
      {this.isDoctor = false,
      this.isPharmacy = false,
      this.isUser = false,
      this.isHospital = false,
      this.isBloodbank = false});
  @override
  State<ProfileScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<ProfileScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();
  final ThemeController _themeController = Get.find<ThemeController>();
  ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Profile',
        leading: Icon(Icons.arrow_back),
        actions: [],
        showIcon: false,
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
                    child: Container(
                      width: 43.w,
                      height: 43.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Add this line
                        border: Border.all(
                            color: Colors.grey, width: 1), // Optional
                      ),
                      child: Center(
                        child: ClipOval(
                          // Add this widget
                          child: Image.network(
                            fit: BoxFit.cover,
                            _profileController.image.toString().contains('http')
                                ? _profileController.image.toString()
                                : CustomConstant.nullUserImage,
                            width: 41.w,
                            height: 41.w,
                          ),
                        ),
                      ),
                    ),
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
                '${_profileController.firstName.value} ${_profileController.lastName.value}',
                style: CustomTextStyles.darkHeadingTextStyle(
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : null),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(_profileController.phone.value,
                  style: CustomTextStyles.lightTextStyle()),
              SizedBox(
                height: 2.h,
              ),
              InkWell(
                onTap: () {
                  widget.isDoctor == true
                      ? Get.to(
                          DoctorDetailScreen(
                            docName: 'Dr David Patel',
                            location: 'USA Cantucky',
                            Category: 'Cardiologist',
                            isDoctor: widget.isDoctor,
                          ),
                          transition: Transition.native)
                      : widget.isUser
                          ? Get.to(
                              FormScreen(
                                  isEdit: true,
                                  email: 'email',
                                  password: 'password',
                                  name: 'name'),
                              transition: Transition.native)
                          : widget.isBloodbank
                              ? Get.to(
                                  BloodBankFormScreen(
                                      isEdit: true,
                                      email: 'email',
                                      password: 'password',
                                      name: 'name'),
                                  transition: Transition.native)
                              : widget.isHospital
                                  ? Get.to(
                                      HospitalFormScreen(
                                          isEdit: true,
                                          email: 'email',
                                          password: 'password',
                                          name: 'name'),
                                      transition: Transition.native)
                                  : widget.isPharmacy
                                      ? Get.to(
                                          PharmacyFormScreen(
                                              isEdit: true,
                                              email: 'email',
                                              password: 'password',
                                              name: 'name'),
                                          transition: Transition.native)
                                      : null;
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
                  Get.to(NotificationScreen(showBackIcon: true),
                      transition: Transition.native);
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
              (widget.isDoctor || widget.isUser)
                  ? InkWell(
                      onTap: () {
                        widget.isDoctor
                            ? Get.to(AllAppointments(),
                                transition: Transition.native)
                            : Get.to(ManageAllAppointmentUser(),
                                transition: Transition.native);
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
                    )
                  : Container(),
              (widget.isDoctor || widget.isUser)
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Divider(
                        color: Color(0xffE5E7EB),
                      ),
                    )
                  : Container(),
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
                    icon: Icon(_themeController.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    onPressed: () {
                      _themeController.toggleTheme();
                    },
                  )
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
