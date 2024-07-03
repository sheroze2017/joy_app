import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
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

import '../../modules/user/user_blood_bank/bloc/user_blood_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    'https://s3-alpha-sig.figma.com/img/6e76/389f/b8c80d0899c8c8ea2b2d81ea6e01642f?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=PDtBEpeZn~ChSfUT3Ben2~nPPaBPEWE3-LrnFMIuxgoBHWGqzP6wcUP8Im1KjgB7VsK2xolhTTKgox01Ft5kfTfy-ecWhW5FE7jFlZ8kH2LxCTa8jg3LyJ1yIuXzA9UiJNQDgbOMOccpsXDWOCRYLKIBbsiSoAY2iedHyh-puh1ivNPheZp0st3LOkTXbHtgBR26wk217KoAcOKRLkTevqeqiZT5ARLooYbSrZutXnTZRuSKxaVlRhkoK4JBfyDHexWlfO4QileKAiasfI4R1iwd-v2lLjmEpCs4X388J6gNl8V2pySb0lhcXkO3WnWjL~uXY9MVkJublyNFs6pRMg__',
    'https://s3-alpha-sig.figma.com/img/0b53/b0b9/f213d7dbdf0e01693c868dd621270fcb?Expires=1718582000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=pKMK73X8i32Wc6JFqNHnPxNQ8of-se4bJHmQRUmumKbfOl0RfRgftFjZ4Om0ufmFxEvvt4NAfcRwz5KS~9Cz9XqyHLZU5MStldJ1dx8cIt5QxpExeIxBdaf9ZwOw0ewe5mjeHfmrtIe64rH3KFtfOWBwWmNvAvsYkEb7fm1-wiB440IKp0CbMoZwYPZ-QvP~'
        'https://s3-alpha-sig.figma.com/img/c6df/9ade/e403579ffaa30dd5dc9121372bfb95f9?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bxW3PKUS2skBH8KLA2yHw0g9H1ahhOzdO~SdewX64gtEuxE8LXIQmJzI6GNktHV2GFO3safSKb7K8iXZdP~ZinNITkvRy8ACHkw6WCEI6Es~3h1eXWDr8Emu9oV8W9sKZzwPxi92evtpdc9qwPGph8bqmMWE0NgqEukohseoZXla-RUNtjOxxbpHRUQWds3XFS3A3--swnxu3BRhQtCQ3dfW6rAejA9mfvdgc8epen5TftkmOfwVfQVS5Tw3euT1MGA~kFRqT-NWKerne5d-LiDwL25-tMLES0jOEZPqVnqTzTFP0Wde5bhmhjJHriwSUlY7Ch1ulG~aUkJX6xukZA__',
  ];

  List<String>? filePath;

  final _pageController = PageController(viewportFraction: 1, keepPage: true);
  int _currentIndex = 0;
  final pharmacyController = Get.put(AllPharmacyController());
  final _userdoctorController = Get.find<UserDoctorController>();
  final _bloodBankController = Get.put(UserBloodBankController());
  final _userHospitalController = Get.put(UserHospitalController());
  @override
  void initState() {
    super.initState();
    pharmacyController.getAllPharmacy();
    _userdoctorController.getAllDoctors();
    _userdoctorController.getAllUserAppointment();
    _bloodBankController.getAllBloodBank();
    _userHospitalController.getAllHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
                        child: SvgPicture.asset(
                            'Assets/icons/notification-bing.svg'),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20),
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
                          height: 42.w,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20),
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
              height: 1.5.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                height: 70.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pharmacyController.pharmacies.length,
                  itemBuilder: (context, index) {
                    final data = pharmacyController.pharmacies[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, left: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PharmacyProductScreen(
                                      userId: data.userId.toString(),
                                    )),
                          );
                        },
                        child: HosipitalCardWidget(
                          pharmacyData: data,
                          isPharmacy: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                height: 70.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _userHospitalController.hospitalList.length < 5
                      ? _userHospitalController.hospitalList.length
                      : 4,
                  itemBuilder: (context, index) {
                    final hospitaldata =
                        _userHospitalController.hospitalList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, left: 0),
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
                          child: HosipitalCardWidget(
                            isHospital: true,
                            hospitalData: hospitaldata,
                          )),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
                          appBarText: 'All Blood Banks', isBloodBank: true));
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                height: 70.w, // Set a fixed height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bloodBankController.bloodbank.length < 5
                      ? _bloodBankController.bloodbank.length
                      : 4,
                  itemBuilder: (context, index) {
                    final data = _bloodBankController.bloodbank[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, left: 0),
                      child: HosipitalCardWidget(
                        bloodBankData: data,
                        isBloodBank: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
