import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/home/components/hospital_card_shimmer.dart';
import 'package:joy_app/modules/home/components/hospital_card_widget.dart';
import 'package:joy_app/modules/hospital/view/home_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:joy_app/modules/user/user_hospital/view/all_hospital_screen.dart';
import 'package:joy_app/modules/pharmacy/view/pharmacy_product_screen.dart';
import 'package:joy_app/widgets/appbar/location_appbar.dart';
import 'package:sizer/sizer.dart';
import '../../user_blood_bank/bloc/user_blood_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    'Assets/images/pharmacy.png',
    'Assets/images/blood.png',
    'Assets/images/doctorbanner.png',
    'Assets/images/hospitalbanner.png'
  ];

  List<String>? filePath;

  final _pageController = PageController(viewportFraction: 1, keepPage: true);
  int _currentIndex = 0;
  final pharmacyController = Get.put(AllPharmacyController());
  final _userdoctorController = Get.find<UserDoctorController>();
  final _bloodBankController = Get.put(UserBloodBankController());
  final _userHospitalController = Get.put(UserHospitalController());
  final locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    pharmacyController.getAllPharmacy();
    _userdoctorController.getAllDoctors();
    _userdoctorController.getAllUserAppointment();
    _bloodBankController.getAllBloodBank();
    _userHospitalController.getAllHospitals();
    _bloodBankController.getAllBloodRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LocationAppBar(
          title: Column(
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      ).then((value) {
                        if (value != null) {
                          locationController.setLocation(value['latitude'],
                              value['longitude'], value['searchValue']);
                        }
                      });
                    },
                    child: SvgPicture.asset(
                      'Assets/icons/pindrop.svg',
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffC5D3E3)
                          : Color(0xff1C2A3A),
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Obx(
                    () => Text(
                      locationController.location.value,
                      style: CustomTextStyles.w600TextStyle(
                          size: 14, color: Color(0xff374151)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff171717)
                          : Color(0xffF3F4F6)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        SvgPicture.asset('Assets/icons/notification-bing.svg'),
                  )),
            )
          ],
          showIcon: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            pharmacyController.getAllPharmacy();
            _bloodBankController.getAllBloodBank();
            _userHospitalController.getAllHospitals();
            _bloodBankController.getAllBloodRequest();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16),
                    child: InkWell(
                      onTap: () {
                        Get.to(AllDoctorsScreen(appBarText: 'All Doctors'),
                            transition: Transition.native);
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
                              return InkWell(
                                onTap: () {
                                  if (url.contains('hospital')) {
                                    Get.to(
                                        AllHospitalScreen(
                                          appBarText: 'All Hospital',
                                          isHospital: true,
                                        ),
                                        transition: Transition.native);
                                  } else if (url.contains('blood')) {
                                    Get.to(
                                        AllHospitalScreen(
                                          appBarText: 'All Blood Bank',
                                          isBloodBank: true,
                                        ),
                                        transition: Transition.native);
                                  } else if (url.contains('pharmacy')) {
                                    Get.to(
                                        AllHospitalScreen(
                                          appBarText: 'All Pharmacy',
                                          isPharmacy: true,
                                        ),
                                        transition: Transition.native);
                                  } else if (url.contains('doctor')) {
                                    Get.to(
                                        AllDoctorsScreen(
                                            appBarText: 'All Doctors'),
                                        transition: Transition.native);
                                  }
                                },
                                child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  height: 42.w,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: Image.asset(
                                        height: 42.w,
                                        url,
                                        fit: BoxFit.fitWidth,
                                      ),
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
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          aspectRatio: 2,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                      // Positioned(
                      //   bottom: 2,
                      //   left: 0,
                      //   right: 0,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: imageList.map((url) {
                      //       int index = imageList.indexOf(url);
                      //       return Container(
                      //         width: _currentIndex == index ? 5.w : 2.w,
                      //         height: 2.w,
                      //         margin: EdgeInsets.symmetric(
                      //             vertical: 10.0, horizontal: 2.0),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(50),
                      //           color: _currentIndex == index
                      //               ? Colors.white
                      //               : Colors.grey,
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
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
                            Get.to(
                                AllHospitalScreen(
                                    appBarText: 'All Pharmacies',
                                    isPharmacy: true),
                                transition: Transition.native);
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
                  Obx(
                    () => Container(
                      height: 70.w,
                      child: pharmacyController.fetchPharmacyLoader.value
                          ? ListView.builder(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 0),
                                    child: ShimmerListViewItem());
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  pharmacyController.pharmacies.length < 5
                                      ? pharmacyController.pharmacies.length
                                      : 4,
                              itemBuilder: (context, index) {
                                final data =
                                    pharmacyController.pharmacies[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PharmacyProductScreen(
                                                  userId:
                                                      data.userId.toString(),
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
                    padding: const EdgeInsets.only(right: 16, left: 16),
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
                            Get.to(
                                AllHospitalScreen(
                                    appBarText: 'All Hospitals',
                                    isHospital: true),
                                transition: Transition.native);
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
                  Obx(
                    () => Container(
                      height: 70.w,
                      child: _userHospitalController.fetchHospital.value
                          ? ListView.builder(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ShimmerListViewItem();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: _userHospitalController
                                          .hospitalList.length <
                                      5
                                  ? _userHospitalController.hospitalList.length
                                  : 4,
                              itemBuilder: (context, index) {
                                final hospitaldata =
                                    _userHospitalController.hospitalList[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HospitalHomeScreen(
                                                    //   hospitalDetail: hospitaldata,
                                                    hospitalId: hospitaldata
                                                        .userId
                                                        .toString(),
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
                    padding: const EdgeInsets.only(right: 16, left: 16),
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
                            Get.to(
                                AllHospitalScreen(
                                    appBarText: 'All Blood Banks',
                                    isBloodBank: true),
                                transition: Transition.native);
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
                  Obx(
                    () => Container(
                      height: 70.w, // Set a fixed height
                      child: _bloodBankController.fetchBloodBank.value
                          ? ListView.builder(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ShimmerListViewItem();
                              },
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _bloodBankController.bloodbank.length < 5
                                      ? _bloodBankController.bloodbank.length
                                      : 4,
                              padding: const EdgeInsets.only(left: 16.0),
                              itemBuilder: (context, index) {
                                final data =
                                    _bloodBankController.bloodbank[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 0),
                                  child: HosipitalCardWidget(
                                    bloodBankData: data,
                                    isBloodBank: true,
                                  ),
                                );
                              },
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
