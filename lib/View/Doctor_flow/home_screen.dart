import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/doctor_flow/all_appointment.dart';
import 'package:joy_app/view/doctor_flow/manage_appointment.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../home/my_profile.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          showBottom: true,
          title: '',
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SvgPicture.asset('Assets/icons/joy-icon-small.svg'),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff191919)
                    : Color(0xffF3F4F6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SvgPicture.asset('Assets/icons/search-normal.svg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ThemeUtil.isDarkMode(context)
                      ? Color(0xff191919)
                      : Color(0xffF3F4F6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: SvgPicture.asset('Assets/icons/sms.svg'),
                  ),
                ),
              ),
            )
          ],
          showIcon: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.borderColor,
                      style: CustomTextStyles.lightTextStyle(
                          color: AppColors.borderColor),
                      decoration: InputDecoration(
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        fillColor: Colors.transparent,
                        hintText: "What's on your mind, Hashem?",
                        hintStyle: CustomTextStyles.lightTextStyle(
                            color: AppColors.borderColor),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(54),
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff121212)
                          : AppColors.whiteColorf9f,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset('Assets/icons/camera.svg'),
                          SizedBox(width: 2.w),
                          Text(
                            "Photo",
                            style: CustomTextStyles.lightTextStyle(
                              color: AppColors.borderColor,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(AllAppointments());
                      },
                      child: HeaderMenu(
                        bgColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.purpleBlueColor
                            : AppColors.lightBlueColore5e,
                        imgbgColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.darkishBlueColorb46
                            : AppColors.lightBlueColord0d,
                        imagepath: 'Assets/icons/calendar.svg',
                        title: 'Appointments',
                        subTitle: 'Manage Appointments',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(ManageAppointment(
                          showPatientHistoryFromScreen: true,
                        ));
                      },
                      child: HeaderMenu(
                        bgColor: AppColors.lightGreenColor,
                        imgbgColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.darkGreenColor
                            : AppColors.lightGreenColorFC7,
                        iconColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : AppColors.darkGreenColor,
                        imagepath: 'Assets/icons/menu-board.svg',
                        title: 'Patient History',
                        subTitle: 'Manage Patient’s History',
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Upcoming Appointments',
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.lightBlueColor3e3
                            : null),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.to(AllAppointments());
                    },
                    child: Text(
                      'See All',
                      style: CustomTextStyles.lightSmallTextStyle(size: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              MeetingCallScheduler(
                bgColor: ThemeUtil.isDarkMode(context)
                    ? AppColors.purpleBlueColor
                    : AppColors.lightishBlueColor5ff,
                isHospital: true,
                nextMeeting: true,
                imgPath: 'Assets/images/onboard3.png',
                name: 'Julie',
                time: 'May 22, 2023 - 10.00 AM',
                location: 'Imam Hospital',
                category: 'Dental',
                buttonColor: Color(0xff0443A9),
              ),
              SizedBox(
                height: 0.75.h,
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Heading(
                      title: 'Reviews',
                    ),
                    SizedBox(height: 2.h),
                    UserRatingWidget(
                      docName: 'Emily Anderson',
                      reviewText: '',
                      rating: '5',
                    ),
                    SizedBox(height: 1.h),
                    UserRatingWidget(
                      docName: 'Emily Anderson',
                      reviewText: '',
                      rating: '5',
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

class MeetingCallScheduler extends StatelessWidget {
  final String imgPath;
  final String name;
  final String category;
  final String location;
  final String time;
  final Color buttonColor;
  final Color bgColor;
  final String? pharmacyButtonText;
  bool nextMeeting;
  bool isActive;
  bool isPharmacy;
  bool? isDeliverd;
  bool? isHospital;

  MeetingCallScheduler(
      {super.key,
      required this.imgPath,
      required this.name,
      required this.category,
      required this.location,
      required this.time,
      this.nextMeeting = false,
      this.isActive = true,
      this.isHospital = false,
      required this.buttonColor,
      required this.bgColor,
      this.isPharmacy = false,
      this.pharmacyButtonText = '',
      this.isDeliverd = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: bgColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isPharmacy
                ? Text(
                    time,
                    style: CustomTextStyles.darkHeadingTextStyle(size: 14),
                  )
                : Container(),
            !isPharmacy
                ? Divider(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    thickness: 0.3,
                  )
                : Container(),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    imgPath,
                    width: 27.9.w,
                    height: 27.9.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            category,
                            style: CustomTextStyles.w600TextStyle(
                                size: 14, color: Color(0xff4B5563)),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('Assets/icons/location.svg'),
                              SizedBox(
                                width: 0.5.w,
                              ),
                              Expanded(
                                child: Text(location,
                                    style: CustomTextStyles.lightTextStyle(
                                        color: Color(0xff4B5563), size: 14)),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          isDeliverd == true
                              ? Text(
                                  'Delivered',
                                  style: CustomTextStyles.w600TextStyle(
                                      size: 14,
                                      color: ThemeUtil.isDarkMode(context)
                                          ? AppColors.lightGreenColoreb1
                                          : AppColors.darkGreenColor),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isActive
                ? Divider(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    thickness: 0.3,
                  )
                : Container(),
            isActive
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                            text: isPharmacy
                                ? pharmacyButtonText.toString()
                                : nextMeeting
                                    ? "Start"
                                    : "Starts In 15 Mins",
                            onPressed: () {
                              //      showPaymentBottomSheet(context, true);
                            },
                            backgroundColor: isPharmacy
                                ? buttonColor
                                : nextMeeting
                                    ? ThemeUtil.isDarkMode(context)
                                        ? buttonColor
                                        : AppColors.darkBlueColor
                                    : ThemeUtil.isDarkMode(context)
                                        ? Color(0xff00143D)
                                        : Color(0xffE5E7EB),
                            textColor: (ThemeUtil.isDarkMode(context) &&
                                    (isHospital != null && isHospital == true))
                                ? AppColors.whiteColor
                                : ThemeUtil.isDarkMode(context)
                                    ? AppColors.blackColor
                                    : nextMeeting
                                        ? AppColors.whiteColor
                                        : AppColors.darkBlueColor),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class HeaderMenu extends StatelessWidget {
  final String imagepath;
  final String title;
  final String subTitle;
  final Color bgColor;
  final Color imgbgColor;
  Color? iconColor;

  HeaderMenu(
      {super.key,
      required this.imagepath,
      required this.title,
      required this.bgColor,
      required this.imgbgColor,
      required this.subTitle,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(22.31)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 10.2.w,
                height: 10.2.w,
                decoration: BoxDecoration(
                    color: imgbgColor, borderRadius: BorderRadius.circular(50)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    imagepath,
                    color: iconColor,
                  ),
                ))),
            SizedBox(
              height: 2.h,
            ),
            Text(
              title,
              style: CustomTextStyles.w600TextStyle(
                  size: 18.87, color: AppColors.blackColor),
            ),
            Text(
              subTitle,
              style: CustomTextStyles.lightTextStyle(
                  size: 11, color: AppColors.blackColor393),
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
