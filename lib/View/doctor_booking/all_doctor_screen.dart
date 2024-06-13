import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/bloodbank_flow/all_donor_screen.dart';
import 'package:joy_app/view/bloodbank_flow/blood_appeal_screen.dart';
import 'package:joy_app/view/bloodbank_flow/profile_form.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/view/doctor_booking/doctor_detail_screen.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
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
                style: CustomTextStyles.darkHeadingTextStyle(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xffC8D3E0)
                        : null),
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
              Expanded(
                child: Container(
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
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
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
  bool isBloodBank;
  bool? isUser;

  DoctorCategory(
      {super.key,
      required this.catrgory,
      required this.DoctorCount,
      required this.bgColor,
      required this.fgColor,
      required this.imagePath,
      this.isBloodBank = false,
      this.isUser = true});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isUser == false ? 0 : 8.0),
      child: Container(
        width: isBloodBank ? 38.87.w : 37.54.w,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(22.31)),
        child: Padding(
          padding: isBloodBank
              ? EdgeInsets.fromLTRB(15.44, 15.44, 12, 15.44)
              : EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: fgColor, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(imagePath),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catrgory,
                    style: CustomTextStyles.w600TextStyle(
                        color: AppColors.blackColor393,
                        size: isBloodBank ? 16 : 18.86,
                        letterspacing: -1),
                  ),
                  Text(
                    isBloodBank
                        ? '${DoctorCount}+ Patients waiting'
                        : '${DoctorCount} Doctors',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor393,
                        size: isBloodBank ? 8 : 15.44),
                  ),
                ],
              ),
              isUser == true
                  ? Row(
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
                              backgroundImage: NetworkImage(
                                  'https://s3-alpha-sig.figma.com/img/03f8/d194/48dd31b8127b7f6577d5ff98da01cf59?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=lgLceP1ZBkEXbOBgkLxwPEqC~XNBIv8ttTKC8oLRSutfDk3qzEwbwicLgmk6ck-utlWYJsPIw-N4~zYhSpW9xy8F3RVnsS6c-JH7gXOAszbQREfqlywHKb~qxnVTLZEdGtniH7XzTgyNNaI6f67HuUYN~YSh0brcpTS2lolLBxHo0Aj77cTy~7My4KdTR52XEUTm-0ojlJL6H-KvF6hzPFZa4LjyV6x5XO8kCpIPfBSo~9OccwFKXGgGlxfLqR5yAgt3VChGyZlDYIkgdWc9hmceD2~WmVaQvS6HtzF0W4Mc0T26ON-R8JTQc~iOvfm7gHB-dJwxN0GOVe8q8B-wIA__'),
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
                  : Container()
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
  bool isBloodBank;
  HorizontalDoctorCategories({this.isBloodBank = false});
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
                  ? Get.to(BloodDonationAppeal(
                      isBloodDontate: true,
                    ))
                  : index == 1
                      ? Get.to(BloodDonationAppeal(
                          isPlasmaDonate: true,
                        ))
                      : Get.to(AllDonorScreen());
            }
          },
          child: DoctorCategory(
            catrgory: isBloodBank ? bloodBankCategory[index] : 'Dental',
            DoctorCount: '$index',
            bgColor: isBloodBank
                ? bgColors[index % 2 == 0 ? 0 : 1]
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

class VerticalDoctorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(DoctorDetailScreen(
              docName: 'Dr. David Patel',
              location: 'Golden Cardiology Center',
              Category: 'Cardiologist',
            ));
          },
          child: DoctorsCardWidget(
            imgUrl: '',
            reviewCount: '1,872',
            docName: 'Dr. David Patel',
            Category: 'Cardiologist',
            loction: 'Cardiology Center, USA',
            rating: '5',
          ),
        );
      },
    );
  }
}

List<String> bloodBankCategory = [
  'Donate Blood',
  'Donate Plasma',
  'Appeal Blood'
];

List<String> bloodBankCatImage = [
  'Assets/images/blood.svg',
  'Assets/images/plasma.svg',
];
List bgColors = [AppColors.redLightColor, AppColors.yellowLightColor];
List fgColors = [AppColors.redLightDarkColor, AppColors.yellowLightDarkColor];

List bgColorsDoctors = [
  AppColors.lightBlueColore5e,
  AppColors.lightPurpleColore1e
];

List fgColorsDoctors = [
  AppColors.lightBlueColord0d,
  AppColors.lightPurpleColord2c
];
