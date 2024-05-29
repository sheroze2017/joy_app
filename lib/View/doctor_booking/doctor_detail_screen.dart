import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/View/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/View/profile/my_profile.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String docName;
  final String location;
  final String Category;

  const DoctorDetailScreen(
      {super.key,
      required this.docName,
      required this.location,
      required this.Category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          bgColor: AppColors.lightishBlueColorebf,
          title: 'Doctor Details',
          leading: Icon(Icons.arrow_back),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'Assets/icons/favourite.svg',
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
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: AppColors.lightishBlueColorebf,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
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
                                width: 2.w,
                              ),
                              Container(
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
                                            .darkHeadingTextStyle(),
                                      ),
                                      Divider(
                                        color: Color(0XFFE5E7EB),
                                      ),
                                      Text(
                                        Category,
                                        style: CustomTextStyles.w600TextStyle(
                                            size: 14, color: Color(0xff4B5563)),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'Assets/icons/location.svg'),
                                          SizedBox(
                                            width: 0.5.w,
                                          ),
                                          Text(location,
                                              style: CustomTextStyles
                                                  .lightTextStyle(
                                                      color: Color(0xff4B5563),
                                                      size: 14))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedSVGContainer(
                                bgColor: AppColors.lightishBlueColorebf,
                                iconColor: Color(0xff023477),
                                svgAsset: 'Assets/icons/profile-2user.svg',
                                numberText: '50+',
                                descriptionText: 'Doctors',
                              ),
                              RoundedSVGContainer(
                                bgColor: AppColors.lightishBlueColorebf,
                                iconColor: Color(0xff023477),
                                svgAsset: 'Assets/icons/medal.svg',
                                numberText: '10+',
                                descriptionText: 'medal',
                              ),
                              RoundedSVGContainer(
                                bgColor: AppColors.lightishBlueColorebf,
                                iconColor: Color(0xff023477),
                                svgAsset: 'Assets/icons/star.svg',
                                numberText: '5',
                                descriptionText: 'star',
                              ),
                              RoundedSVGContainer(
                                bgColor: AppColors.lightishBlueColorebf,
                                iconColor: Color(0xff023477),
                                svgAsset: 'Assets/icons/messages.svg',
                                numberText: '1872',
                                descriptionText: 'reviews',
                              ),
                            ],
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
                        horizontal: 16.0, vertical: 8),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          Heading(
                            title: 'About me',
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                              'Dr. David Patel, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA. ',
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff4B5563), size: 14)),
                          SizedBox(height: 1.h),
                          Heading(
                            title: 'Working Timings',
                          ),
                          SizedBox(height: 0.5.h),
                          Text('Monday-Friday, 08.00 AM-18.00 pM',
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff4B5563), size: 14)),
                          SizedBox(height: 0.5.h),
                          SizedBox(height: 1.h),
                          Heading(
                            title: 'Appointment Cost',
                          ),
                          SizedBox(height: 0.5.h),
                          Text('150\$ for 1 Hour Consultation',
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff4B5563), size: 14)),
                          SizedBox(height: 1.h),
                          Heading(
                            title: 'Reviews',
                          ),
                          SizedBox(height: 1.h),
                          UserRatingWidget(
                            docName: 'Emily Anderson',
                            reviewText: '',
                            rating: '5',
                          ),
                          SizedBox(height: 0.h),
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
                      text: "Book Appointment",
                      onPressed: () {},
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
