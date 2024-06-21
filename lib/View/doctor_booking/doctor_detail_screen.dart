import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/doctor_booking/your_profileform_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

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
  @override
  Widget build(BuildContext context) {
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
                                child: Image.asset(
                                  'Assets/images/doctor.png',
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
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          docName,
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
                                          Category,
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
                                              child: Text(location,
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
                                  numberText: '50+',
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
                                  numberText: '5',
                                  descriptionText: 'rating',
                                  isDoctor: true,
                                ),
                                RoundedSVGContainer(
                                  isDoctor: true,
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/messages.svg',
                                  numberText: '1872',
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
                          Text(
                              'Dr. David Patel, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA. ',
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
                          Text('150\$ for 1 Hour Consultation',
                              style: CustomTextStyles.lightTextStyle(size: 14)),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Reviews',
                          ),
                          SizedBox(height: 1.h),
                          UserRatingWidget(
                            docName: 'Emily Anderson',
                            reviewText: '',
                            rating: '5',
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
                            ? print('yet to find')
                            : Get.to(ProfileFormScreen());
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
