import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/Doctor_flow/all_appointment.dart';
import 'package:joy_app/View/Doctor_flow/manage_appointment.dart';
import 'package:joy_app/View/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../profile/my_profile.dart';

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
            SvgPicture.asset('Assets/icons/searchbg.svg'),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 8),
              child: SvgPicture.asset('Assets/icons/messagebg.svg'),
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
                  Text(
                    "What's on your mind, Hashem?",
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.borderColor),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(54),
                        color: AppColors.whiteColorf9f),
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
                                color: AppColors.borderColor, size: 12),
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
                        bgColor: AppColors.lightBlueColore5e,
                        imgbgColor: AppColors.lightBlueColord0d,
                        imagepath: 'Assets/icons/menu-board.svg',
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
                        imgbgColor: AppColors.lightGreenColorFC7,
                        imagepath: 'Assets/icons/calendar.svg',
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
                    style: CustomTextStyles.darkHeadingTextStyle(),
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
                nextMeeting: true,
                imgPath: 'Assets/images/onboard3.png',
                name: '',
                time: '',
                location: '',
                category: '',
              ),
              SizedBox(
                height: 0.75.h,
              ),
              MeetingCallScheduler(
                imgPath: 'Assets/images/oldPerson.png',
                name: '',
                time: '',
                location: '',
                category: '',
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
  bool nextMeeting;
  bool isActive;

  MeetingCallScheduler(
      {super.key,
      required this.imgPath,
      required this.name,
      required this.category,
      required this.location,
      required this.time,
      this.nextMeeting = false,
      this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.lightishBlueColor5ff),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'May 22, 2023 - 10.00 AM',
              style: CustomTextStyles.darkHeadingTextStyle(size: 14),
            ),
            Divider(
              color: Color(0xffE5E7EB),
            ),
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
                  width: 2.w,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'James Robinson',
                          style: CustomTextStyles.darkHeadingTextStyle(),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'Cancer Patient',
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
                            Text('USA',
                                style: CustomTextStyles.lightTextStyle(
                                    color: Color(0xff4B5563), size: 14))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isActive
                ? Divider(
                    color: Color(0xffE5E7EB),
                  )
                : Container(),
            isActive
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                            text: nextMeeting ? "Start" : "Starts In 15 Mins",
                            onPressed: () {
                              //      showPaymentBottomSheet(context, true);
                            },
                            backgroundColor: nextMeeting
                                ? AppColors.darkBlueColor
                                : Color(0xffE5E7EB),
                            textColor: nextMeeting
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

  const HeaderMenu(
      {super.key,
      required this.imagepath,
      required this.title,
      required this.bgColor,
      required this.imgbgColor,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(22.31)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
                  child: SvgPicture.asset(imagepath),
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
                  size: 12, color: AppColors.blackColor393),
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
