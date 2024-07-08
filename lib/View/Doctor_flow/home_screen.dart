import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
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
  DoctorHomeScreen({super.key});

  DoctorController _doctorController = Get.put(DoctorController());
  ProfileController _profileController = Get.put(ProfileController());

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
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => CreatePostModal(),
                        );
                      },
                      child: TextField(
                        enabled: false,
                        maxLines: null,
                        cursorColor: AppColors.borderColor,
                        style: CustomTextStyles.lightTextStyle(
                            color: AppColors.borderColor),
                        decoration: InputDecoration(
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          fillColor: Colors.transparent,
                          hintText: "What's on your mind?",
                          hintStyle: CustomTextStyles.lightTextStyle(
                              color: AppColors.borderColor),
                        ),
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
              Obx(() => _doctorController.doctorAppointment.isEmpty ||
                      _doctorController.doctorAppointment
                          .where((element) => element.status == 'Pending')
                          .isEmpty
                  ? Center(
                      child: SubHeading(
                        title: 'No pending appointments',
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _doctorController.doctorAppointment.length,
                      itemBuilder: (context, index) {
                        if (_doctorController.doctorAppointment[index].status ==
                            'Pending') {
                          final data =
                              _doctorController.doctorAppointment[index];
                          return Column(
                            children: [
                              MeetingCallScheduler(
                                bgColor: ThemeUtil.isDarkMode(context)
                                    ? AppColors.purpleBlueColor
                                    : AppColors.lightishBlueColor5ff,
                                isHospital: true,
                                nextMeeting: true,
                                imgPath: '',
                                name: data.userDetails!.name.toString(),
                                time: '${data.date}  ${data.time}',
                                location: data.location.toString(),
                                category: 'Dental',
                                buttonColor: Color(0xff0443A9),
                                onPressed: () {
                                  Get.to(ManageAppointment(
                                      phoneNo: data.userDetails!.phone,
                                      appointmentId:
                                          data.appointmentId.toString(),
                                      doctorId: data.doctorUserId.toString()));
                                },
                              ),
                            ],
                          );
                        } else
                          return Container();
                      })),
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
                    Obx(() => _doctorController.doctorDetail == null ||
                            _doctorController
                                    .doctorDetail?.data?.reviews?.length ==
                                0
                        ? Center(
                            child: SubHeading(
                              title: 'No reviews yet',
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _doctorController.doctorDetail == null
                                ? 0
                                : _doctorController
                                    .doctorDetail!.data?.reviews!.length,
                            itemBuilder: ((context, index) {
                              final data = _doctorController
                                  .doctorDetail!.data?.reviews![index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: UserRatingWidget(
                                  image: data!.giveBy!.image!,
                                  docName: data!.giveBy!.name!,
                                  reviewText: data!.review!,
                                  rating: data.rating!,
                                ),
                              );
                            })))
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
  VoidCallback? onPressed;
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
      this.onPressed,
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
        padding: EdgeInsets.all(10),
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
                  child: Image.network(
                    imgPath.contains('http')
                        ? imgPath
                        : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
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
                    color: Theme.of(context).dividerColor,
                    thickness: 0.2,
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
                            // onPressed: () {
                            //   //      showPaymentBottomSheet(context, true);
                            // },
                            onPressed: onPressed ?? () {},
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
