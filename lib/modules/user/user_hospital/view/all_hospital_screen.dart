import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/blood_bank/view/all_donor_screen.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/blood_bank_detail.dart';
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
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:sizer/sizer.dart';

import '../bloc/user_hospital_bloc.dart';
import '../../../home/components/hospital_card_widget.dart';
import '../../user_blood_bank/view/request_blood.dart';
import '../../../pharmacy/view/pharmacy_product_screen.dart';

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
  final pharmacyController = Get.find<AllPharmacyController>();
  final bloodBankController = Get.find<UserBloodBankController>();
  final _userHospitalController = Get.find<UserHospitalController>();
  final locationController = Get.find<LocationController>();
  final _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    pharmacyController.searchResults.value =
        pharmacyController.pharmacies.value;
    bloodBankController.searchResults.value =
        bloodBankController.bloodbank.value;
    _userHospitalController.searchResults.value =
        _userHospitalController.hospitalList.value;
    // pharmacyController.getAllPharmacy();
    // bloodBankController.getAllBloodBank();
    //  _userHospitalController.getAllHospitals();
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
                      ? (query) => bloodBankController.searchBloodBanks(query)
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
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
                              DoctorCount: '1',
                              bgColor: AppColors.redLightColor,
                              fgColor: AppColors.redLightDarkColor,
                              imagePath: 'Assets/images/blood.svg',
                              isBloodBank: widget.isBloodBank,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: InkWell(
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
                              DoctorCount: '4',
                              bgColor: AppColors.yellowLightColor,
                              fgColor: AppColors.yellowLightDarkColor,
                              imagePath: 'Assets/images/plasma.svg',
                              isBloodBank: widget.isBloodBank,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              widget.isBloodBank
                  ? SizedBox(
                      height: 1.h,
                    )
                  : SizedBox(
                      height: 0.h,
                    ),
              widget.isBloodBank
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RoundedButton(
                                text: "All Donors",
                                onPressed: () {
                                  Get.to(AllDonorScreen(),
                                      transition: Transition.native);
                                },
                                backgroundColor: AppColors.redLightDarkColor,
                                textColor: Colors.white),
                          )
                        ],
                      ),
                    )
                  : Container(),
              widget.isBloodBank
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RoundedButton(
                              text: "Request Blood",
                              onPressed: () {
                                Get.to(RequestBlood(),
                                    transition: Transition.native);
                              },
                              backgroundColor: AppColors.redLightDarkColor,
                              textColor: Colors.white),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: RoundedButton(
                              text: "Register Donor",
                              onPressed: () {
                                Get.to(
                                    RequestBlood(
                                      isRegister: true,
                                    ),
                                    transition: Transition.native);
                              },
                              backgroundColor: AppColors.redLightDarkColor,
                              textColor: Colors.white),
                        )
                      ],
                    )
                  : Container(),
              widget.isBloodBank
                  ? SizedBox(height: 2.h)
                  : SizedBox(
                      height: 0.h,
                    ),
              Obx(
                () => Text(
                  widget.isBloodBank
                      ? bloodBankController.searchResults.length.toString() +
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
                  () => ListView.separated(
                      itemCount: widget.isBloodBank
                          ? bloodBankController.searchResults.length
                          : widget.isPharmacy
                              ? pharmacyController.searchResults.length
                              : _userHospitalController.searchResults.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.w),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.isPharmacy
                                ? Get.to(
                                    PharmacyProductScreen(
                                      userId: pharmacyController
                                          .searchResults[index].userId
                                          .toString(),
                                    ),
                                    transition: Transition.rightToLeft)
                                : widget.isHospital
                                    ? Get.to(
                                        HospitalHomeScreen(
                                          isUser: true,
                                          hospitalId: _userHospitalController
                                              .searchResults[index].userId
                                              .toString(),
                                        ),
                                        transition: Transition.rightToLeft)
                                    : Get.to(
                                        BloodBankDetailScreen(
                                          donor: bloodBankController
                                              .searchResults[index],
                                        ),
                                        transition: Transition.rightToLeft);
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
      style: CustomTextStyles.darkHeadingTextStyle(
          size: 12.67,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff222222)
              : Color(0xff4B5563)),
    );
  }
}
