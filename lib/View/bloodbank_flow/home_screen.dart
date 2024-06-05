import 'package:flutter/material.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../social_media/new_friend.dart';

class BloodBankHomeScreen extends StatelessWidget {
  const BloodBankHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Donate Blood',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
          ),
          actions: [],
          showIcon: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: RoundedSearchTextField(
                    hintText: 'Search', controller: TextEditingController()),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 45.w,
                child: HorizontalDoctorCategories(isBloodBank: true),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Allied Blood Bank',
                style: CustomTextStyles.darkHeadingTextStyle(
                    size: 20, color: Color(0xff383D44)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: LocationWidget(
                  isBloodbank: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Divider(
                  color: Color(0xffE5E7EB),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedSVGContainer(
                      bgColor: AppColors.lightishBlueColorebf,
                      iconColor: Color(0xff1C2A3A),
                      svgAsset: 'Assets/icons/profile-2user.svg',
                      numberText: '50+',
                      descriptionText: 'Patients',
                    ),
                    RoundedSVGContainer(
                      bgColor: AppColors.lightishBlueColorebf,
                      iconColor: Color(0xff1C2A3A),
                      svgAsset: 'Assets/icons/medal.svg',
                      numberText: '10+',
                      descriptionText: 'experience',
                    ),
                    RoundedSVGContainer(
                      bgColor: AppColors.lightishBlueColorebf,
                      iconColor: Color(0xff1C2A3A),
                      svgAsset: 'Assets/icons/star.svg',
                      numberText: '5',
                      descriptionText: 'rating',
                    ),
                    RoundedSVGContainer(
                      bgColor: AppColors.silverColor4f6,
                      iconColor: Color(0xff1C2A3A),
                      svgAsset: 'Assets/icons/messages.svg',
                      numberText: '1872',
                      descriptionText: 'reviews',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Text(
                    'About Blood Bank',
                    style: CustomTextStyles.darkHeadingTextStyle(
                        size: 20, color: Color(0xff383D44)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Edit',
                      style: CustomTextStyles.lightSmallTextStyle(size: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ReadMoreText(
                  "Allied Blood Bank is renowned blood bank working from last 12 years. It have all the modern machinery and all lab tests are available. It is view more",
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  colorClickableText: AppColors.blackColor,
                  trimCollapsedText: ' view more',
                  trimExpandedText: ' view less',
                  style: CustomTextStyles.lightTextStyle(size: 14),
                  moreStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  lessStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Text(
                    'Blood Bank Timings',
                    style: CustomTextStyles.darkHeadingTextStyle(
                        size: 20, color: Color(0xff383D44)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Edit',
                      style: CustomTextStyles.lightSmallTextStyle(size: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Monday - Sunday, 24 Hours',
                style: CustomTextStyles.lightTextStyle(size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
