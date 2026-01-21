import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/blood_bank_detail.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/blood_bank_details_screen.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/my_appeals.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/location_widget.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/reviewbar_widget.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/user_all_order.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/hospital/view/home_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/blood_donation_appeal.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/widgets/donor_detail_sheet.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:sizer/sizer.dart';

import '../bloc/user_hospital_bloc.dart';
import '../../../home/components/hospital_card_widget.dart';
import '../../user_blood_bank/view/request_blood.dart';
import '../../user_pharmacy/all_pharmacy/view/product_screen.dart';
import '../../user_home/bloc/nearby_services_bloc.dart';
import '../../user_home/model/nearby_services_model.dart';
import '../../user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import '../model/all_hospital_model.dart';

class AllHospitalScreen extends StatefulWidget {
  bool isPharmacy;
  bool isBloodBank;
  bool isHospital;
  final String appBarText;
  AllHospitalScreen(
      {super.key,
      this.isPharmacy = false,
      this.isBloodBank = false,
      this.isHospital = false,
      required this.appBarText});

  @override
  State<AllHospitalScreen> createState() => _AllHospitalScreenState();
}

class _AllHospitalScreenState extends State<AllHospitalScreen> {
  final pharmacyController = Get.put(AllPharmacyController());
  final bloodBankController = Get.put(UserBloodBankController());
  final _userHospitalController = Get.put(UserHospitalController());
  final locationController = Get.find<LocationController>();
  final _profileController = Get.find<ProfileController>();
  final nearbyServicesController = Get.put(NearbyServicesController());

  @override
  void initState() {
    super.initState();
    // Ensure data is loaded from unified API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateData();
    });
  }

  void _populateData() {
    // Use data from unified API (nearbyServicesController) if available
    if (widget.isPharmacy) {
      // Convert NearbyPharmacy to PharmacyModelData for compatibility
      if (nearbyServicesController.pharmacies.isNotEmpty) {
        final pharmaciesList = nearbyServicesController.pharmacies
            .map((p) => _convertNearbyPharmacyToPharmacyModel(p))
            .toList();
        pharmacyController.searchResults.value = pharmaciesList;
      }
    } else if (widget.isBloodBank) {
      // Fetch all donors and blood requests for blood bank screen
      bloodBankController.getAllDonors();
      // Load blood requests to show counts on cards
      bloodBankController.getAllBloodRequest();
    } else if (widget.isHospital) {
      // Convert NearbyHospital to Hospital for compatibility
      if (nearbyServicesController.hospitals.isNotEmpty) {
        final hospitalsList = nearbyServicesController.hospitals
            .map((h) => _convertNearbyHospitalToHospital(h))
            .toList();
        _userHospitalController.searchResults.value = hospitalsList;
      } else {
        // If no data, try to refresh
        nearbyServicesController.getNearbyServicesAndBookings().then((_) {
          if (nearbyServicesController.hospitals.isNotEmpty) {
            final hospitalsList = nearbyServicesController.hospitals
                .map((h) => _convertNearbyHospitalToHospital(h))
                .toList();
            _userHospitalController.searchResults.value = hospitalsList;
          }
        });
      }
    }
  }

  // Helper method to convert NearbyPharmacy to PharmacyModelData
  PharmacyModelData _convertNearbyPharmacyToPharmacyModel(NearbyPharmacy nearby) {
    return PharmacyModelData(
      userId: nearby.id?.toString(),
      name: nearby.name ?? '',
      email: nearby.email ?? '',
      location: nearby.details?.location ?? nearby.location ?? '',
      lat: nearby.details?.lat ?? '',
      lng: nearby.details?.lng ?? '',
      placeId: nearby.details?.placeId ?? '',
      image: nearby.image ?? '',
      phone: nearby.phone ?? '',
      reviews: [],
    );
  }

  // Helper method to convert NearbyHospital to Hospital
  Hospital _convertNearbyHospitalToHospital(NearbyHospital nearby) {
    // Try to parse ID as int, fallback to string conversion
    int? userIdInt;
    String? originalIdString;
    if (nearby.id != null) {
      originalIdString = nearby.id.toString(); // Always store original ID as string
      if (nearby.id is int) {
        userIdInt = nearby.id as int;
      } else {
        userIdInt = int.tryParse(nearby.id.toString());
      }
    }
    
    return Hospital(
      userId: userIdInt,
      originalId: originalIdString, // Store original ID string
      name: nearby.name ?? '',
      email: nearby.email ?? '',
      location: nearby.details?.location ?? nearby.location ?? '',
      lat: nearby.details?.lat ?? '',
      lng: nearby.details?.lng ?? '',
      placeId: nearby.details?.placeId ?? '',
      image: nearby.image ?? '',
      phone: nearby.phone ?? '',
      about: nearby.details?.about ?? '',
      institute: nearby.details?.institute ?? '',
      checkupFee: nearby.details?.checkupFee ?? '',
      reviews: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.isBloodBank
          ? Drawer(
              backgroundColor: AppColors.redColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            _profileController.image.contains('http')
                                ? _profileController.image.toString()
                                : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                            width: 12.8.w,
                            height: 12.8.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profileController.firstName.toString(),
                                style: CustomTextStyles.w600TextStyle(
                                  size: 15.59,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _profileController.email.toString(),
                                style: CustomTextStyles.lightSmallTextStyle(
                                  color: Color(0xffF4D9E5),
                                  size: 12.47,
                                ),
                              ),
                              SizedBox(
                                width: 0.5.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(MyBloodAppeals());
                      },
                      child: DrawerItem(
                        isBloodBank: true,
                        isBooking: true,
                        bookingText: 'My Appeals',
                        bookingAsset: 'Assets/icons/blood.svg',
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(AllHospitalScreen(
                          isBloodBank: true,
                          appBarText: 'All Blood Banks',
                        ));
                      },
                      child: DrawerItem(
                        isBloodBank: true,
                        isBooking: false,
                        bookingText: 'blood bank',
                        bookingAsset: 'Assets/icons/bookingplus.svg',
                      ),
                    ),
                  ],
                ),
              ),
            )
          : widget.isPharmacy
              ? Drawer(
                  backgroundColor: AppColors.lightGreenColoreb1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(
                                _profileController.image.contains('http')
                                    ? _profileController.image.toString()
                                    : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                                width: 12.8.w,
                                height: 12.8.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _profileController.firstName.toString(),
                                    style: CustomTextStyles.w600TextStyle(
                                      size: 15.59,
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                  Text(
                                    _profileController.email.toString(),
                                    style: CustomTextStyles.lightSmallTextStyle(
                                      color: AppColors.darkGreenColor,
                                      size: 12.47,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.5.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(UserAllOrderScreen(),
                                transition: Transition.rightToLeft);
                          },
                          child: DrawerItem(
                            isBloodBank: true,
                            isBooking: true,
                            bookingText: 'My Orders',
                            bookingAsset: 'Assets/icons/blood.svg',
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(
                                AllHospitalScreen(
                                  appBarText: 'All Pharmacy',
                                  isPharmacy: true,
                                ),
                                transition: Transition.rightToLeft);
                          },
                          child: DrawerItem(
                            isBloodBank: true,
                            isBooking: true,
                            bookingText: 'All Pharmacy',
                            bookingAsset: 'Assets/icons/pharmacy.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
      appBar: HomeAppBar(
          title: widget.appBarText,
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: true),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedSearchTextField(
                  onChanged: widget.isBloodBank
                      ? (query) => bloodBankController.searchDonors(query)
                      : widget.isPharmacy
                          ? (query) => pharmacyController.searchPharmacy(query)
                          : widget.isHospital
                              ? (query) =>
                                  _userHospitalController.searchHospital(query)
                              : null,
                  hintText: widget.isPharmacy
                      ? 'Search Pharmacies'
                      : widget.isHospital
                          ? 'Search Hospitals'
                          : 'Search Blood Bank',
                  controller: TextEditingController()),
              SizedBox(
                height: 1.h,
              ),
              widget.isBloodBank
                  ? Obx(() {
                      // Count ACTIVE or OPEN status requests for blood/plasma.
                      final activeBloodCount = bloodBankController.allBloodRequest
                          .where((req) {
                            final status = req.status?.toUpperCase() ?? '';
                            return status == 'ACTIVE' || status == 'OPEN';
                          })
                          .length;
                      final activePlasmaCount = bloodBankController.allPlasmaRequest
                          .where((req) {
                            final status = req.status?.toUpperCase() ?? '';
                            return status == 'ACTIVE' || status == 'OPEN';
                          })
                          .length;
                      final donorsCount = bloodBankController.allDonors.length;

                      return SizedBox(
                        height: 18.h,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(
                                      BloodDonationAppealUser(
                                        isBloodDontate: true,
                                        isUser: true,
                                      ),
                                      transition: Transition.native);
                                },
                                child: DoctorCategory(
                                  isUser: false,
                                  catrgory: 'Donate Blood',
                                  DoctorCount: '$activeBloodCount',
                                  bgColor: AppColors.redLightColor,
                                  fgColor: AppColors.redLightDarkColor,
                                  imagePath: 'Assets/images/blood.svg',
                                  isBloodBank: widget.isBloodBank,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                      BloodDonationAppealUser(
                                        isPlasmaDonate: true,
                                        isUser: true,
                                      ),
                                      transition: Transition.native);
                                },
                                child: DoctorCategory(
                                  isUser: false,
                                  catrgory: 'Donate Plasma',
                                  DoctorCount: '$activePlasmaCount',
                                  bgColor: AppColors.yellowLightColor,
                                  fgColor: AppColors.yellowLightDarkColor,
                                  imagePath: 'Assets/images/plasma.svg',
                                  isBloodBank: widget.isBloodBank,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              InkWell(
                                onTap: () {
                                  Get.to(RequestBlood(),
                                      transition: Transition.native);
                                },
                                child: DoctorCategory(
                                  isUser: false,
                                  catrgory: 'Request Blood',
                                  DoctorCount: '$donorsCount',
                                  bgColor: AppColors.lightBlueColore5e,
                                  fgColor: AppColors.lightBlueColord0d,
                                  imagePath: 'Assets/images/blood.svg',
                                  isBloodBank: widget.isBloodBank,
                                  isAppeal: true,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                      RequestBlood(
                                        isRegister: true,
                                      ),
                                      transition: Transition.native);
                                },
                                child: DoctorCategory(
                                  isUser: false,
                                  catrgory: 'Register Donor',
                                  DoctorCount: '$donorsCount',
                                  bgColor: AppColors.lightGreenColor,
                                  fgColor: AppColors.lightGreenColorFC7,
                                  imagePath: 'Assets/images/user.svg',
                                  isBloodBank: widget.isBloodBank,
                                  isAppeal: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  : Container(),
              widget.isBloodBank
                  ? SizedBox(height: 2.h)
                  : SizedBox(
                      height: 0.h,
                    ),
              Obx(
                () => Text(
                  widget.isBloodBank
                      ? bloodBankController.searchedDonors.length.toString() +
                          ' found'
                      : widget.isPharmacy
                          ? pharmacyController.searchResults.length.toString() +
                              ' found'
                          : _userHospitalController.searchResults.length
                                  .toString() +
                              ' found',
                  style: CustomTextStyles.darkHeadingTextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffC8D3E0)
                          : null),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: Obx(
                  () => widget.isBloodBank
                      ? ListView.separated(
                          itemCount: bloodBankController.searchedDonors.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 2.w),
                          itemBuilder: (context, index) {
                            final donor = bloodBankController.searchedDonors[index];
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => DonorDetailSheet(
                                    donor: donor,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0XFFF4F4F4),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 27.w,
                                        height: 27.w,
                                        decoration: BoxDecoration(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff2A2A2A)
                                              : Color(0xffE5E5E5),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 20.w,
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff5A5A5A)
                                              : Color(0xffA5A5A5),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              donor.name ?? 'Unknown',
                                              style: CustomTextStyles.darkHeadingTextStyle(
                                                  size: 16),
                                            ),
                                            SizedBox(height: 0.5.h),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.redLightColor,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    donor.bloodGroup ?? '',
                                                    style: CustomTextStyles.w600TextStyle(
                                                        size: 12,
                                                        color: AppColors.redColor),
                                                  ),
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  donor.gender ?? '',
                                                  style: CustomTextStyles.lightTextStyle(
                                                      size: 12),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 0.5.h),
                                            Row(
                                              children: [
                                                SvgPicture.asset('Assets/icons/location.svg',
                                                    width: 12, height: 12),
                                                SizedBox(width: 1.w),
                                                Expanded(
                                                  child: Text(
                                                    '${donor.location ?? ''}, ${donor.city ?? ''}',
                                                    style: CustomTextStyles.lightTextStyle(
                                                        size: 11),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 0.3.h),
                                            Text(
                                              'Status: ${donor.status ?? 'N/A'}',
                                              style: CustomTextStyles.lightTextStyle(
                                                  size: 10,
                                                  color: donor.status == 'AVAILABLE'
                                                      ? Colors.green
                                                      : Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.separated(
                          itemCount: widget.isPharmacy
                              ? pharmacyController.searchResults.length
                              : _userHospitalController.searchResults.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.w),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (widget.isPharmacy) {
                              final pharmacyId = pharmacyController
                                  .searchResults[index].userId
                                  .toString();
                              
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
                              
                              Get.to(
                                ProductScreen(
                                  userId: pharmacyId,
                                  isAdmin: false, // User mode, not admin
                                ),
                                transition: Transition.rightToLeft,
                              );
                            } else if (widget.isHospital) {
                              final hospital = _userHospitalController
                                  .searchResults[index];
                              // Use originalId if available, otherwise use userId
                              final hospitalId = hospital.originalId ?? hospital.userId?.toString();
                              
                              if (hospitalId == null || hospitalId == 'null' || hospitalId.isEmpty) {
                                // Show error if hospital ID is invalid
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
                              
                              Get.to(
                                HospitalHomeScreen(
                                  isUser: true,
                                  hospitalId: hospitalId,
                                ),
                                transition: Transition.rightToLeft,
                              );
                            } else {
                              // For blood banks, get the userId from PharmacyModelData
                              final bloodBankUserId = pharmacyController
                                  .searchResults[index].userId?.toString();
                              
                              if (bloodBankUserId == null || bloodBankUserId.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Invalid blood bank ID',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              
                              Get.to(
                                BloodBankDetailsScreen(
                                  userId: bloodBankUserId,
                                ),
                                transition: Transition.rightToLeft,
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.isPharmacy
                                    ? Color(0xffE2FFE3)
                                    : widget.isBloodBank
                                        ? Color(0XFFF4F4F4)
                                        : ThemeUtil.isDarkMode(context)
                                            ? AppColors.purpleBlueColor
                                            : Color(0xffEEF5FF),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: CachedNetworkImage(
                                      width: 27.w,
                                      height: 27.w,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.isBloodBank
                                          ? bloodBankController
                                              .searchResults[index].image
                                              .toString()
                                          : widget.isPharmacy
                                              ? pharmacyController
                                                  .searchResults[index].image
                                                  .toString()
                                              : _userHospitalController
                                                  .searchResults[index].image
                                                  .toString(),
                                      placeholder: (context, url) => Center(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: LoadingWidget(),
                                      )),
                                      errorWidget: (context, url, error) => url
                                              .contains('http')
                                          ? Center(
                                              child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: ErorWidget(),
                                            ))
                                          : Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'Assets/images/app-icon.png'),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        HospitalName(
                                          hospitalName: widget.isBloodBank
                                              ? bloodBankController
                                                  .searchResults[index].name
                                                  .toString()
                                              : widget.isPharmacy
                                                  ? pharmacyController
                                                      .searchResults[index].name
                                                      .toString()
                                                  : _userHospitalController
                                                      .searchResults[index].name
                                                      .toString(),
                                        ),
                                        LocationWidget(
                                          location: widget.isBloodBank
                                              ? bloodBankController
                                                  .searchResults[index].location
                                                  .toString()
                                              : widget.isPharmacy
                                                  ? pharmacyController
                                                      .searchResults[index]
                                                      .location
                                                      .toString()
                                                  : _userHospitalController
                                                      .searchResults[index]
                                                      .location
                                                      .toString(),
                                        ),
                                        ReviewBar(
                                            rating: '0',
                                            count: widget.isBloodBank
                                                ? bloodBankController
                                                    .searchResults[index]
                                                    .reviews!
                                                    .length
                                                : widget.isPharmacy
                                                    ? pharmacyController
                                                        .searchResults[index]
                                                        .reviews!
                                                        .length
                                                    : _userHospitalController
                                                        .searchResults[index]
                                                        .reviews!
                                                        .length),
                                        Divider(
                                          color: Color(0xff6B7280),
                                          thickness: 0.1.h,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'Assets/icons/routing.svg'),
                                                SizedBox(
                                                  width: 0.5.w,
                                                ),
                                                Text(
                                                    calculateDistance(
                                                                widget
                                                                        .isPharmacy
                                                                    ? pharmacyController
                                                                        .searchResults[
                                                                            index]
                                                                        .lat!
                                                                    : widget
                                                                            .isBloodBank
                                                                        ? bloodBankController
                                                                            .searchResults[
                                                                                index]
                                                                            .lat!
                                                                        : _userHospitalController
                                                                            .searchResults[
                                                                                index]
                                                                            .lat!,
                                                                widget
                                                                        .isPharmacy
                                                                    ? pharmacyController
                                                                        .searchResults[
                                                                            index]
                                                                        .lat!
                                                                    : widget
                                                                            .isBloodBank
                                                                        ? bloodBankController
                                                                            .searchResults[
                                                                                index]
                                                                            .lat!
                                                                        : _userHospitalController
                                                                            .searchResults[
                                                                                index]
                                                                            .lat!,
                                                                locationController
                                                                    .latitude
                                                                    .value,
                                                                locationController
                                                                    .longitude
                                                                    .value)
                                                            .toStringAsFixed(
                                                                0) +
                                                        ' km/0min',
                                                    style: CustomTextStyles
                                                        .lightTextStyle(
                                                            color: Color(
                                                                0xff6B7280),
                                                            size: 10.8))
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                SvgPicture.asset(widget
                                                        .isPharmacy
                                                    ? 'Assets/icons/pharmacy.svg'
                                                    : 'Assets/icons/hospital.svg'),
                                                SizedBox(
                                                  width: 0.5.w,
                                                ),
                                                Text(
                                                    widget.isPharmacy
                                                        ? 'Pharmacy'
                                                        : 'Hospital',
                                                    style: CustomTextStyles
                                                        .lightTextStyle(
                                                            color: Color(
                                                                0xff6B7280),
                                                            size: 10.8))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HospitalName extends StatelessWidget {
  String? hospitalName;
  HospitalName({this.hospitalName});
  @override
  Widget build(BuildContext context) {
    return Text(
      hospitalName ?? 'Sunrise Health Clinic',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: CustomTextStyles.darkHeadingTextStyle(
          size: 12.67,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff222222)
              : Color(0xff4B5563)),
    );
  }
}
