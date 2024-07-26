import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/profile_form.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/loader.dart';
import 'package:sizer/sizer.dart';

import '../../modules/doctor/bloc/doctor_bloc.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String docName;
  final String location;
  final String Category;
  bool isDoctor;

  DoctorDetailScreen(
      {super.key,
      required this.docName,
      required this.location,
      required this.Category,
      this.isDoctor = false});

  DoctorController _doctorController = Get.find<DoctorController>();
  @override
  Widget build(BuildContext context) {
    final data = _doctorController.doctorDetail!.data;

    return Scaffold(
      appBar: HomeAppBar(
          bgColor: ThemeUtil.isDarkMode(context)
              ? Color(0xff1B1B1B)
              : AppColors.lightishBlueColorebf,
          title: isDoctor ? 'Your Profile' : 'Doctor Details',
          leading: Icon(Icons.arrow_back),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'Assets/icons/favourite.svg',
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : null,
                  )),
            )
          ],
          showIcon: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        ThemeUtil.isDarkMode(context)
                            ? BoxShadow()
                            : BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                      ],
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff1B1B1B)
                          : AppColors.lightishBlueColorebf,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedNetworkImage(
                                  imageUrl: data!.image.toString(),
                                  width: 27.9.w,
                                  height: 27.9.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: LoadingWidget(),
                                  )),
                                  errorWidget: (context, url, error) => Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ErorWidget(),
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name.toString(),
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffC8D3E0)
                                                      : null),
                                        ),
                                        Divider(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff1F2228)
                                              : Color(0XFFE5E7EB),
                                        ),
                                        Text(
                                          data.qualifications.toString(),
                                          style: CustomTextStyles.w600TextStyle(
                                              size: 14,
                                              color: Color(0xff4B5563)),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'Assets/icons/location.svg'),
                                            SizedBox(
                                              width: 0.5.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  data.location.toString(),
                                                  style: CustomTextStyles
                                                      .lightTextStyle(
                                                          color:
                                                              Color(0xff4B5563),
                                                          size: 14)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedSVGContainer(
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/profile-2user.svg',
                                  numberText: data.reviews!.length.toString(),
                                  isDoctor: true,
                                  descriptionText: 'Patients',
                                ),
                                RoundedSVGContainer(
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/medal.svg',
                                  numberText: '10+',
                                  isDoctor: true,
                                  descriptionText: 'experience',
                                ),
                                RoundedSVGContainer(
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/star.svg',
                                  numberText:
                                      _doctorController.val.value.toString(),
                                  descriptionText: 'rating',
                                  isDoctor: true,
                                ),
                                RoundedSVGContainer(
                                  isDoctor: true,
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/messages.svg',
                                  numberText: data!.reviews!.length.toString(),
                                  descriptionText: 'reviews',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          Heading(
                            title: 'About me',
                          ),
                          SizedBox(height: 1.h),
                          Text('',
                              style: CustomTextStyles.lightTextStyle(size: 14)),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Working Time',
                          ),
                          SizedBox(height: 1.h),
                          Text('Monday-Friday, 08:00 AM - 10:00 PM',
                              style: CustomTextStyles.lightTextStyle(size: 14)),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Appointment Cost',
                          ),
                          SizedBox(height: 1.h),
                          Obx(() => Text(
                              '${_doctorController.doctorDetail!.data!.consultationFee!.toString()} for 1 Hour Consultation',
                              style:
                                  CustomTextStyles.lightTextStyle(size: 14))),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Reviews',
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2.h),
                              Obx(() => ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _doctorController.doctorDetail!
                                          .data?.reviews?.length ??
                                      0,
                                  itemBuilder: ((context, index) {
                                    final data = _doctorController
                                        .doctorDetail!.data?.reviews![index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
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
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: new FractionalOffset(.5, 1.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButton(
                      text: isDoctor ? 'Edit Profile' : "Book Appointment",
                      onPressed: () {
                        isDoctor
                            ? Get.to(
                                DoctorFormScreen(
                                  email: data.email.toString(),
                                  password: data.password.toString(),
                                  name: data.name.toString(),
                                  details: data,
                                  isEdit: true,
                                ),
                                transition: Transition.native)
                            : null;
                      },
                      backgroundColor: AppColors.darkBlueColor,
                      textColor: AppColors.whiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
