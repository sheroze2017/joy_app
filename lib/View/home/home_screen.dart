import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/view/home/components/hospital_card_widget.dart';
import 'package:joy_app/view/hospital_flow/home_screen.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/pharmacy_product_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    'https://s3-alpha-sig.figma.com/img/6e76/389f/b8c80d0899c8c8ea2b2d81ea6e01642f?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=DpT0kQK2-QJ1fDTl2GYU3bYtMinfTzS7G-Mqm1NIsNG~BunVooDsLfpqkyWjuzsHoQhkEVCbeEelvh0ggQZ638a-zj0vQLU5hISjQRW4A0B-GYbYmDrN4YVUUwviLobWWsfB6VZd8JKkDkwyxRpZFtZQrAsdgnbEooOdQ5Bwj9WeUJeMGdjBf42YO2y-0OhHZnDtWwJ7u2B3r~S2Okk-K0L5Jt9EK~zJPPsiU0neTOg1JvwQGnt1vjfiJQ-i15RbtYGQD6U9enZ7Csma6CRrZXsqxHbhX0eNn7dVpKPZAyIbZIaGXOPKITR0r21PBP~BUmc~Df3xq9WkKTkVwHLJgw__',
    'https://s3-alpha-sig.figma.com/img/9f50/e360/edb80c5d0e9f43d9cc9e7c48030fa945?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=JXIBoKZJ35lb2DkCVCjO5lLx8N0ZBzqMPCA0sumBmu~Z~6ShwyxBMkTk-YRg8NmzX0T-rfaOeiZXQGVhiugfHk1l4-FP7Slk0POX0KJY5cLp9elMAagLh7d789~76mJYxcWeabZBtWOjm6d9yfU0~0tkYWbJ4wGPQnxqXs9XlyVsFLGY97NsuHHGchcHs6I8KWZAauXAISwADSpS7lRKZmq3tJgiSXakLfgoKurjp3CWIcAiymD96F11UatJrYZa2DD5dtnekCtr91Sv5o2sIxeJNv17Ee6rql056c5l7~r3FGoFEiRmMBvY0z4Hyvil4iyTqFqCuK4C4~xN96HoNQ__',
    'https://s3-alpha-sig.figma.com/img/0b53/b0b9/f213d7dbdf0e01693c868dd621270fcb?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=pKMK73X8i32Wc6JFqNHnPxNQ8of-se4bJHmQRUmumKbfOl0RfRgftFjZ4Om0ufmFxEvvt4NAfcRwz5KS~9Cz9XqyHLZU5MStldJ1dx8cIt5QxpExeIxBdaf9ZwOw0ewe5mjeHfmrtIe64rH3KFtfOWBwWmNvAvsYkEb7fm1-wiB440IKp0CbMoZwYPZ-QvP~8xMUCKBps2gSlnI7sUVBoM60gxjlgdmlXbXtBiAtxllm3bkvGCMUGvpvu63TBNbIGZtHCmmp15kiN7YtEyeuyLsuJB531zN6RsuHajVDFYlyW6ZFvgoMI9o7HsN01h2XUAoxyPDvJZbePqLJz2lMfA__'
  ];

  List<String>? filePath;

  final _pageController = PageController(viewportFraction: 1, keepPage: true);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: CustomTextStyles.lightTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffAAAAAA)
                            : null),
                  ),
                  SizedBox(height: 1.w),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'Assets/icons/pindrop.svg',
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffC5D3E3)
                            : Color(0xff1C2A3A),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Seattle, USA',
                        style: CustomTextStyles.w600TextStyle(
                            size: 14, color: Color(0xff374151)),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff171717)
                          : Color(0xffF3F4F6)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        SvgPicture.asset('Assets/icons/notification-bing.svg'),
                  ))
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                  child: InkWell(
                    onTap: () {
                      Get.to(AllDoctorsScreen(appBarText: 'All Doctors'));
                    },
                    child: RoundedSearchTextField(
                        isEnable: false,
                        hintText: 'Search doctor...',
                        controller: TextEditingController()),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Stack(
                  children: [
                    CarouselSlider(
                      items: imageList.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 16),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    width: 100.w,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        aspectRatio: 2,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageList.map((url) {
                          int index = imageList.indexOf(url);
                          return Container(
                            width: _currentIndex == index ? 5.w : 2.w,
                            height: 2.w,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                  child: Row(
                    children: [
                      Text(
                        'Nearby Pharmacies',
                        style: CustomTextStyles.darkHeadingTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : null),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(AllHospitalScreen(
                              appBarText: 'All Pharmacies', isPharmacy: true));
                        },
                        child: Text(
                          'See All',
                          style: CustomTextStyles.lightSmallTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: 70.w, // Set a fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PharmacyProductScreen()),
                            );
                          },
                          child: HosipitalCardWidget(
                            isPharmacy: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                  child: Row(
                    children: [
                      Text(
                        'Nearby Medical Centers',
                        style: CustomTextStyles.darkHeadingTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : null),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(AllHospitalScreen(
                              appBarText: 'All Hospitals', isHospital: true));
                        },
                        child: Text(
                          'See All',
                          style: CustomTextStyles.lightSmallTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: 70.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HospitalHomeScreen(
                                          isUser: true,
                                        )),
                              );
                            },
                            child: HosipitalCardWidget()),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                  child: Row(
                    children: [
                      Text(
                        'Nearby Blood Bank',
                        style: CustomTextStyles.darkHeadingTextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : null),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(AllHospitalScreen(
                              appBarText: 'All Blood Banks',
                              isBloodBank: true));
                        },
                        child: Text(
                          'See All',
                          style: CustomTextStyles.lightSmallTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: 70.w, // Set a fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: HosipitalCardWidget(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
