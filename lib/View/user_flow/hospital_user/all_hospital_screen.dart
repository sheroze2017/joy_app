import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/modules/blood_bank/view/all_donor_screen.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/modules/hospital/view/home_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/user_flow/bloodbank_user/blood_donation_appeal.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:sizer/sizer.dart';

import '../../../modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import '../../home/components/hospital_card_widget.dart';
import '../bloodbank_user/request_blood.dart';
import '../pharmacy_user/pharmacy_product_screen.dart';

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
                                    transition: Transition.native)
                                : widget.isHospital
                                    ? Get.to(
                                        HospitalHomeScreen(
                                          isUser: true,
                                          hospitalId: _userHospitalController
                                              .searchResults[index].userId
                                              .toString(),
                                        ),
                                        transition: Transition.native)
                                    : print('null');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.isPharmacy
                                    ? Color(0xffE2FFE3)
                                    : widget.isBloodBank
                                        ? Color(0xffFFECEC)
                                        : Color(0xffEEF5FF),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      widget.isBloodBank
                                          ? bloodBankController
                                                  .searchResults[index].image
                                                  .toString()
                                                  .contains('http')
                                              ? bloodBankController
                                                  .searchResults[index].image
                                                  .toString()
                                              : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png'
                                          : widget.isPharmacy
                                              ? pharmacyController
                                                      .searchResults[index]
                                                      .image
                                                      .toString()
                                                      .contains('http')
                                                  ? pharmacyController
                                                      .searchResults[index]
                                                      .image
                                                      .toString()
                                                  : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png'
                                              : _userHospitalController
                                                      .searchResults[index]
                                                      .image
                                                      .toString()
                                                      .contains('http')
                                                  ? _userHospitalController
                                                      .searchResults[index]
                                                      .image
                                                      .toString()
                                                  : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                                      width: 28.w,
                                      height: 28.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
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
              ? AppColors.whiteColor
              : Color(0xff4B5563)),
    );
  }
}

class LocationWidget extends StatelessWidget {
  bool isBloodbank;
  String? location;
  LocationWidget({this.isBloodbank = false, this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('Assets/icons/location.svg'),
        SizedBox(
          width: 0.5.w,
        ),
        Text(location ?? '123 Oak Street, CA 98765',
            style: CustomTextStyles.lightTextStyle(
                color: isBloodbank ? Color(0xff383D44) : Color(0xff6B7280),
                size: 10.8))
      ],
    );
  }
}

class ReviewBar extends StatelessWidget {
  int count;
  String rating;
  ReviewBar({super.key, required this.count, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(rating,
            style: CustomTextStyles.w600TextStyle(
                color: Color(0xff6B7280), size: 10.8)),
        RatingBar.builder(
          itemSize: 15,
          initialRating: double.parse(rating),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          tapOnlyMode: true,
          itemCount: 5,
          updateOnDrag: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        SizedBox(
          width: 0.5.w,
        ),
        Text('(${count} Reviews)',
            style: CustomTextStyles.lightTextStyle(
                color: Color(0xff6B7280), size: 10.8)),
      ],
    );
  }
}
