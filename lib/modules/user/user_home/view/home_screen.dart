import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/modules/user/user_doctor/view/manage_booking.dart';
import 'package:joy_app/modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/home/components/hospital_card_shimmer.dart';
import 'package:joy_app/modules/hospital/view/home_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/modules/user/user_hospital/view/all_hospital_screen.dart';
import 'package:joy_app/modules/pharmacy/view/pharmacy_product_screen.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/user_all_order.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import '../../user_blood_bank/bloc/user_blood_bloc.dart';
import '../../user_home/bloc/nearby_services_bloc.dart';
import '../../user_home/view/widgets/nearby_service_card.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/blood_bank/view/all_donor_screen.dart';
import 'package:joy_app/widgets/drawer/user_drawer.dart';

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
    'Assets/images/hospitalbanner.png',
    'Assets/images/bannerlast.png'
  ];

  List<String>? filePath;

  final _pageController = PageController(viewportFraction: 1, keepPage: true);
  int _currentIndex = 0;
  final pharmacyController = Get.put(AllPharmacyController());
  final _userdoctorController = Get.find<UserDoctorController>();
  final _bloodBankController = Get.put(UserBloodBankController());
  final _userHospitalController = Get.put(UserHospitalController());
  final locationController = Get.find<LocationController>();
  final nearbyServicesController = Get.put(NearbyServicesController());
  final _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Use unified API that returns all data (pharmacies, hospitals, doctors, blood donors, bookings)
    nearbyServicesController.getNearbyServicesAndBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: UserDrawer(),
        appBar: HomeAppBar(
          isImage: true,
          title: '',
          leading: Container(),
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
            // Use unified API that returns all data
            await nearbyServicesController.getNearbyServicesAndBookings();
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
                  Stack(
                    children: [
                      CarouselSlider(
                        items: imageList.map((url) {
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                onTap: () {
                                  if (url.contains('last')) {
                                    Get.to(ManageAllAppointmentUser(),
                                        transition: Transition.rightToLeft);
                                  }
                                  if (url.contains('hospital')) {
                                    Get.to(
                                        AllHospitalScreen(
                                          appBarText: 'All Hospital',
                                          isHospital: true,
                                        ),
                                        transition: Transition.rightToLeft);
                                  } else if (url.contains('blood')) {
                                    Get.to(
                                        AllHospitalScreen(
                                          appBarText: 'All Blood Bank',
                                          isBloodBank: true,
                                        ),
                                        transition: Transition.rightToLeft);
                                  } else if (url.contains('pharmacy')) {
                                    Get.to(
                                        AllHospitalScreen(
                                          appBarText: 'All Pharmacy',
                                          isPharmacy: true,
                                        ),
                                        transition: Transition.rightToLeft);
                                  } else if (url.contains('doctor')) {
                                    Get.to(
                                        AllDoctorsScreen(
                                            appBarText: 'All Doctors'),
                                        transition: Transition.rightToLeft);
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
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageList.map((url) {
                            int index = imageList.indexOf(url);
                            return Container(
                              width: _currentIndex == index ? 7.w : 2.w,
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
                    height: 1.h,
                  ),
                  // Scrollable Content Sections
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildScrollableContentCard(
                            context,
                            'Consult Doctors Online',
                            'Find and appoint skilled doctors',
                            Icons.medical_services,
                            Colors.blue,
                            () {
                              Get.to(
                                AllDoctorsScreen(appBarText: 'All Doctors'),
                                transition: Transition.native,
                              );
                            },
                          ),
                          SizedBox(width: 2.w),
                          _buildScrollableContentCard(
                            context,
                            'Search for Hospitals',
                            'Find nearby medical centers',
                            Icons.local_hospital,
                            Colors.green,
                            () {
                              Get.to(
                                AllHospitalScreen(
                                  appBarText: 'All Hospitals',
                                  isHospital: true,
                                ),
                                transition: Transition.native,
                              );
                            },
                          ),
                          SizedBox(width: 2.w),
                          _buildScrollableContentCard(
                            context,
                            'Check Medical History',
                            'View your bookings and history',
                            Icons.history,
                            Colors.orange,
                            () {
                              Get.to(
                                ManageAllAppointmentUser(),
                                transition: Transition.native,
                              );
                            },
                          ),
                          SizedBox(width: 2.w),
                          _buildScrollableContentCard(
                            context,
                            'My Pharmacy Orders',
                            'View your pharmacy orders',
                            Icons.shopping_bag,
                            Colors.purple,
                            () {
                              Get.to(
                                UserAllOrderScreen(),
                                transition: Transition.native,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
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
                            style:
                                CustomTextStyles.lightSmallTextStyle(size: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h, // Reduced from 1.h to minimize space below title
                  ),
                  Obx(
                    () => Container(
                      height: 65.w, // Reduced from 70.w to minimize empty space
                      child: nearbyServicesController.fetchLoader.value
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
                              itemCount: nearbyServicesController.pharmacies.length > 4
                                  ? 4
                                  : nearbyServicesController.pharmacies.length,
                              itemBuilder: (context, index) {
                                final data =
                                    nearbyServicesController.pharmacies[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 0),
                                  child: InkWell(
                                    onTap: () {
                                      final pharmacyController = Get.find<AllPharmacyController>();
                                      final pharmacyId = data.id.toString();
                                      
                                      // Check if cart is empty or same pharmacy
                                      if (!pharmacyController.canNavigateToPharmacy(pharmacyId)) {
                                        Get.snackbar(
                                          'Cart Restriction',
                                          'Please empty the cart first to add from other pharmacy',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.orange,
                                          colorText: Colors.white,
                                          duration: Duration(seconds: 3),
                                          icon: Icon(Icons.shopping_cart, color: Colors.white),
                                        );
                                        return;
                                      }
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PharmacyProductScreen(
                                                  userId: pharmacyId,
                                                )),
                                      );
                                    },
                                    child: NearbyServiceCard(
                                      pharmacy: data,
                                      onTap: () {
                                        final pharmacyController = Get.find<AllPharmacyController>();
                                        final pharmacyId = data.id.toString();
                                        
                                        // Check if cart is empty or same pharmacy
                                        if (!pharmacyController.canNavigateToPharmacy(pharmacyId)) {
                                          Get.snackbar(
                                            'Cart Restriction',
                                            'Please empty the cart first to add from other pharmacy',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.orange,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 3),
                                            icon: Icon(Icons.shopping_cart, color: Colors.white),
                                          );
                                          return;
                                        }
                                        
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PharmacyProductScreen(
                                                    userId: pharmacyId,
                                                  )),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h, // Reduced from 3.h to minimize space between sections
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
                            style:
                                CustomTextStyles.lightSmallTextStyle(size: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h, // Reduced from 1.h to minimize space below title
                  ),
                  Obx(
                    () => Container(
                      height: 65.w, // Reduced from 70.w to minimize empty space
                      child: nearbyServicesController.fetchLoader.value
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
                              itemCount: nearbyServicesController.hospitals.length > 4
                                  ? 4
                                  : nearbyServicesController.hospitals.length,
                              itemBuilder: (context, index) {
                                final hospitaldata =
                                    nearbyServicesController.hospitals[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 0),
                                      child: InkWell(
                                      onTap: () {
                                        final hospitalId = hospitaldata.id?.toString();
                                        if (hospitalId == null || hospitalId == 'null' || hospitalId.isEmpty) {
                                          Get.snackbar(
                                            'Error',
                                            'Invalid hospital ID. Please try again.',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 2),
                                            icon: Icon(Icons.error, color: Colors.white),
                                          );
                                          return;
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HospitalHomeScreen(
                                                    hospitalId: hospitalId,
                                                    isUser: true,
                                                  )),
                                        );
                                      },
                                      child: NearbyServiceCard(
                                        hospital: hospitaldata,
                                        onTap: () {
                                          final hospitalId = hospitaldata.id?.toString();
                                          if (hospitalId == null || hospitalId == 'null' || hospitalId.isEmpty) {
                                            Get.snackbar(
                                              'Error',
                                              'Invalid hospital ID. Please try again.',
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                              icon: Icon(Icons.error, color: Colors.white),
                                            );
                                            return;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HospitalHomeScreen(
                                                      hospitalId: hospitalId,
                                                      isUser: true,
                                                    )),
                                          );
                                        },
                                      )),
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h, // Reduced from 3.h to minimize space between sections
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: Row(
                      children: [
                        Text(
                          'All Donors',
                          style: CustomTextStyles.darkHeadingTextStyle(
                              color: ThemeUtil.isDarkMode(context)
                                  ? AppColors.whiteColor
                                  : null),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Get.to(
                                AllDonorScreen(),
                                transition: Transition.native);
                          },
                          child: Text(
                            'See All',
                            style:
                                CustomTextStyles.lightSmallTextStyle(size: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                 
                  Obx(
                    () => Container(
                      height: 65.w, // Reduced from 70.w to minimize empty space
                      child: nearbyServicesController.fetchLoader.value
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
                              itemCount: nearbyServicesController.bloodDonors.length > 4
                                  ? 4
                                  : nearbyServicesController.bloodDonors.length,
                              padding: const EdgeInsets.only(left: 16.0),
                              itemBuilder: (context, index) {
                                final data =
                                    nearbyServicesController.bloodDonors[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 0),
                                  child: NearbyServiceCard(
                                    bloodDonor: data,
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

  Widget _buildScrollableContentCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70.w,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 1.h),
            Text(
              title,
              style: CustomTextStyles.darkHeadingTextStyle(
                color: ThemeUtil.isDarkMode(context)
                    ? AppColors.whiteColor
                    : null,
                size: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: CustomTextStyles.lightTextStyle(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xffAAAAAA)
                    : Color(0xff6B7280),
                size: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final bool isBooking;
  final String bookingText;
  final String bookingAsset;
  final isBloodBank;
  const DrawerItem({
    required this.isBooking,
    required this.bookingText,
    required this.bookingAsset,
    required this.isBloodBank,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(62),
        color: isBooking
            ? Colors.white
            : isBloodBank
                ? AppColors.redColor
                : AppColors.darkBlueColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          children: [
            Container(
              child: SvgPicture.asset(
                bookingAsset,
              ),
              height: 6.w,
              width: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              bookingText,
              style: CustomTextStyles.w600TextStyle(
                  size: 16,
                  color: isBooking ? Color(0xff1F1F29) : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
