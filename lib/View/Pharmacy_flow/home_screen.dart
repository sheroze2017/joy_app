import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:joy_app/view/doctor_flow/home_screen.dart';
import 'package:joy_app/view/pharmacy_flow/order_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../styles/colors.dart';
import 'product_screen.dart';

class PharmacyHomeScreen extends StatelessWidget {
  const PharmacyHomeScreen({super.key});

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
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.borderColor,
                      style: CustomTextStyles.lightTextStyle(
                          color: AppColors.borderColor),
                      decoration: InputDecoration(
                        hintText: "What's on your mind, Hashem?",
                        hintStyle: CustomTextStyles.lightTextStyle(
                            color: AppColors.borderColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(54),
                      color: AppColors.whiteColorf9f,
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
                        Get.to(MyOrderScreen());
                      },
                      child: HeaderMenu(
                        bgColor: AppColors.lightBlueColore5e,
                        imgbgColor: AppColors.lightBlueColord0d,
                        imagepath: 'Assets/icons/menu-board.svg',
                        title: 'Orders',
                        subTitle: 'Manage Orders',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(ProductScreen());
                      },
                      child: HeaderMenu(
                        bgColor: AppColors.lightGreenColor,
                        imgbgColor: AppColors.lightGreenColorFC7,
                        imagepath: 'Assets/icons/calendar.svg',
                        title: 'Stocks',
                        subTitle: 'Manage Stocks',
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
                    'Ongoing Orders',
                    style: CustomTextStyles.darkHeadingTextStyle(),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      //      Get.to(AllAppointments());
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
                isPharmacy: true,
                pharmacyButtonText: 'Marked as Deliverd',
                buttonColor: AppColors.darkGreenColor,
                bgColor: AppColors.lightGreenColor,
                nextMeeting: true,
                imgPath: 'Assets/images/tablet.jpg',
                name: 'Panadol',
                time: 'May 22, 2023 - 10.00 AM',
                location: 'Elite Ortho Clinic USA',
                category: '10 Tablets',
              ),
              SizedBox(
                height: 0.75.h,
              ),
              MeetingCallScheduler(
                isPharmacy: true,
                pharmacyButtonText: 'Marked as Deliverd',
                buttonColor: AppColors.darkGreenColor,
                bgColor: AppColors.lightGreenColor,
                imgPath: 'Assets/images/tablet.jpg',
                nextMeeting: true,
                name: 'Panadol',
                time: 'May 22, 2023 - 10.00 AM',
                location: 'Elite Ortho Clinic USA',
                category: '10 Tablets',
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
