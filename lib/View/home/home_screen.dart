import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/view/home/components/hospital_card_widget.dart';
import 'package:joy_app/view/hospital_flow/home_screen.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
  ];

  List<String>? filePath;

  final _pageController = PageController(viewportFraction: 1, keepPage: true);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: CustomTextStyles.lightTextStyle(),
                  ),
                  SizedBox(height: 1.w),
                  Row(
                    children: [
                      SvgPicture.asset('Assets/icons/pindrop.svg'),
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
                      color: Color(0xffF3F4F6)),
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
                        style: CustomTextStyles.darkHeadingTextStyle(),
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
                        child: HosipitalCardWidget(),
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
                        style: CustomTextStyles.darkHeadingTextStyle(),
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
                        child: HosipitalCardWidget(),
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
                        style: CustomTextStyles.darkHeadingTextStyle(),
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
