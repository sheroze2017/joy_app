import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/View/hospital_user/all_hospital_screen.dart';
import 'package:joy_app/View/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/View/social_media/new_friend.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class AllDoctorsScreen extends StatelessWidget {
  final bool isPharmacy;
  final bool isBloodBank;
  final bool isHospital;
  final String appBarText;
  AllDoctorsScreen(
      {super.key,
      this.isPharmacy = false,
      this.isBloodBank = false,
      this.isHospital = false,
      required this.appBarText});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: appBarText,
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: true),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h,
              ),
              RoundedSearchTextField(
                  hintText: 'Search', controller: TextEditingController()),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 45.w,
                child: HorizontalDoctorCategories(),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                '532 found',
                style: CustomTextStyles.darkHeadingTextStyle(),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: VerticalDoctorsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorsCardWidget extends StatelessWidget {
  final String imgUrl;
  final String Category;
  final String docName;
  final String loction;
  final String reviewCount;
  final bool isFav;
  final String rating;

  const DoctorsCardWidget(
      {super.key,
      required this.imgUrl,
      required this.Category,
      required this.docName,
      required this.loction,
      required this.reviewCount,
      this.isFav = false,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffEEF5FF), borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
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
                width: 51.28.w,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            docName,
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'Assets/icons/favourite.svg',
                              ))
                        ],
                      ),
                      Divider(
                        color: AppColors.lightGreyColor,
                      ),
                      Text(
                        Category,
                        style: CustomTextStyles.w600TextStyle(
                            size: 14, color: Color(0xff4B5563)),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset('Assets/icons/location.svg'),
                          SizedBox(
                            width: 0.5.w,
                          ),
                          Text(loction,
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff4B5563), size: 14))
                        ],
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 15,
                            initialRating: 6,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 1,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Text(rating,
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff4B5563), size: 12)),
                          SizedBox(
                            width: 0.5.w,
                          ),
                          Text(' | ${reviewCount} Reviews',
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff6B7280), size: 10.8)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorCategory extends StatelessWidget {
  final String catrgory;
  final String DoctorCount;
  final Color bgColor;
  final Color fgColor;
  final String imagePath;

  const DoctorCategory(
      {super.key,
      required this.catrgory,
      required this.DoctorCount,
      required this.bgColor,
      required this.fgColor,
      required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 37.54.w,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(22.31)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: fgColor, borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(imagePath),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                catrgory,
                style: CustomTextStyles.w600TextStyle(
                    color: AppColors.blackColor393, size: 18.86),
              ),
              Text(
                '${DoctorCount} Doctors',
                style: CustomTextStyles.lightSmallTextStyle(
                    color: AppColors.blackColor393, size: 15.44),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 3.h,
                      height: 3.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: 1,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ),
                  Container(
                    width: 3.h,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Color(0xffD1C3E6),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+6',
                        style: CustomTextStyles.lightTextStyle(
                            size: 9.6, color: AppColors.blackColor393),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HospitalName extends StatelessWidget {
  const HospitalName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sunrise Health Clinic',
      style: CustomTextStyles.darkHeadingTextStyle(
          size: 12.67, color: Color(0xff4B5563)),
    );
  }
}

class HorizontalDoctorCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Handle onTap event
          },
          child: DoctorCategory(
            catrgory: 'Dental',
            DoctorCount: '$index',
            bgColor: AppColors.lightBlueColore5e,
            fgColor: AppColors.lightBlueColord0d,
            imagePath: 'Assets/icons/dental.svg',
          ),
        );
      },
    );
  }
}

class VerticalDoctorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Change this according to your actual data count
      itemBuilder: (context, index) {
        return DoctorsCardWidget(
          imgUrl: '',
          reviewCount: '1,872',
          docName: 'Dr. David Patel',
          Category: 'Cardiologist',
          loction: 'Cardiology Center, USA',
          rating: '5',
        );
      },
    );
  }
}
