import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/all_donor_screen.dart';
import 'package:joy_app/modules/blood_bank/view/blood_appeal_screen.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import 'lib/modules/blood_bank/bloc/blood_bank_bloc.dart';
import 'lib/modules/social_media/friend_request/view/new_friend.dart';

class BloodBankHomeScreen extends StatelessWidget {
  BloodBankHomeScreen({super.key});
  BloodBankController _bloodBankController = Get.put(BloodBankController());
  ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
            title: 'Donate Blood',
            leading: Text(''),
            actions: [],
            showIcon: true),
        body: Obx(
          () => _bloodBankController.bloodBankHomeLoader.value
              ? Center(child: CircularProgressIndicator())
              : _bloodBankController.bloodBankDetail == null
                  ? Center(
                      child: Text('Error Fetching DATA'),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: RoundedSearchTextField(
                                  hintText: 'Search',
                                  controller: TextEditingController()),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              height: 45.w,
                              child: _HorizontalDoctorCategories(
                                isBloodBank: true,
                                bloodRequest:
                                    _bloodBankController.allBloodRequest,
                                plasmaRequest:
                                    _bloodBankController.allPlasmaRequest,
                                allDonors: _bloodBankController.allDonors,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              _bloodBankController.bloodBankDetail!.data!.name
                                  .toString(),
                              style: CustomTextStyles.darkHeadingTextStyle(
                                  size: 20,
                                  color: ThemeUtil.isDarkMode(context)
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xff383D44)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: LocationWidget(
                                isBloodbank: true,
                                location: _bloodBankController
                                    .bloodBankDetail!.data!.location,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RoundedSVGContainer(
                                    bgColor: AppColors.lightishBlueColorebf,
                                    iconColor: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC5D3E3)
                                        : Color(0xff1C2A3A),
                                    svgAsset: 'Assets/icons/profile-2user.svg',
                                    numberText: '50+',
                                    descriptionText: 'Patients',
                                  ),
                                  RoundedSVGContainer(
                                    bgColor: AppColors.lightishBlueColorebf,
                                    iconColor: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC5D3E3)
                                        : Color(0xff1C2A3A),
                                    svgAsset: 'Assets/icons/medal.svg',
                                    numberText: '10+',
                                    descriptionText: 'experience',
                                  ),
                                  RoundedSVGContainer(
                                    bgColor: AppColors.lightishBlueColorebf,
                                    iconColor: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC5D3E3)
                                        : Color(0xff1C2A3A),
                                    svgAsset: 'Assets/icons/star.svg',
                                    numberText: '5',
                                    descriptionText: 'rating',
                                  ),
                                  RoundedSVGContainer(
                                    bgColor: AppColors.silverColor4f6,
                                    iconColor: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC5D3E3)
                                        : Color(0xff1C2A3A),
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
                                      size: 20,
                                      color: ThemeUtil.isDarkMode(context)
                                          ? Color(0xffC8D3E0)
                                          : Color(0xff383D44)),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    'Edit',
                                    style: CustomTextStyles.lightSmallTextStyle(
                                        size: 14),
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
                                style:
                                    CustomTextStyles.lightTextStyle(size: 14),
                                moreStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                lessStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                                      size: 20,
                                      color: ThemeUtil.isDarkMode(context)
                                          ? Color(0xffC8D3E0)
                                          : Color(0xff383D44)),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    'Edit',
                                    style: CustomTextStyles.lightSmallTextStyle(
                                        size: 14),
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
        ));
  }
}

class _HorizontalDoctorCategories extends StatelessWidget {
  bool isBloodBank;
  List<BloodRequest>? plasmaRequest;
  List<BloodRequest>? bloodRequest;
  List<BloodDonor>? allDonors;

  _HorizontalDoctorCategories(
      {this.isBloodBank = false,
      this.bloodRequest,
      this.plasmaRequest,
      this.allDonors});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: isBloodBank ? bloodBankCategory.length : 5,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (isBloodBank) {
              index == 0
                  ? Get.to(
                      BloodDonationAppeal(
                        isBloodDontate: true,
                      ),
                      transition: Transition.native)
                  : index == 1
                      ? Get.to(
                          BloodDonationAppeal(
                            isPlasmaDonate: true,
                          ),
                          transition: Transition.native)
                      : Get.to(AllDonorScreen(), transition: Transition.native);
            }
          },
          child: DoctorCategory(
            isAppeal: (isBloodBank && index == 2) ? true : false,
            catrgory: isBloodBank
                ? index == 0
                    ? 'Donate Blood'
                    : index == 1
                        ? 'Donate Plasma'
                        : index == 2
                            ? 'Request Blood'
                            : bloodBankCategory[index]
                : 'Dental',
            DoctorCount: isBloodBank
                ? index == 0
                    ? bloodRequest!.length.toString()
                    : index == 1
                        ? plasmaRequest!.length.toString()
                        : index == 2
                            ? allDonors!.length.toString()
                            : bloodBankCategory[index]
                : '',
            bgColor: isBloodBank
                ? bgColors[index % 2 == 0 ? 0 : 1]
                : ThemeUtil.isDarkMode(context)
                    ? bgColorsDoctorsDark[index % 2 == 0 ? 0 : 1]
                    : bgColorsDoctors[index % 2 == 0 ? 0 : 1],
            fgColor: isBloodBank
                ? fgColors[index % 2 == 0 ? 0 : 1]
                : fgColorsDoctors[index % 2 == 0 ? 0 : 1],
            imagePath: isBloodBank
                ? bloodBankCatImage[index % 2 == 0 ? 0 : 1]
                : 'Assets/icons/dental.svg',
            isBloodBank: isBloodBank,
          ),
        );
      },
    );
  }
}
