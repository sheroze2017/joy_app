import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:joy_app/modules/auth/bloc/auth_bloc.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/pharmacy_flow/product_screen.dart';
import 'package:joy_app/view/doctor_booking/all_doctor_screen.dart';
import 'package:joy_app/view/hospital_flow/home_screen.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/user_flow/bloodbank_user/blood_donation_appeal.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:sizer/sizer.dart';

import '../../../modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import '../../bloodbank_flow/blood_appeal_screen.dart';
import '../bloodbank_user/request_blood.dart';
import '../pharmacy_user/pharmacy_product_screen.dart';
import 'hospital_detail_screen.dart';

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
  @override
  void initState() {
    super.initState();
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
                              Get.to(BloodDonationAppealUser(
                                isBloodDontate: true,
                                isUser: true,
                              ));
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
                              Get.to(BloodDonationAppealUser(
                                isPlasmaDonate: true,
                                isUser: true,
                              ));
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RoundedButton(
                              text: "Request Blood",
                              onPressed: () {
                                Get.to(RequestBlood());
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
                                Get.to(RequestBlood(
                                  isRegister: true,
                                ));
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
                      ? bloodBankController.bloodbank.length.toString() +
                          ' found'
                      : widget.isPharmacy
                          ? pharmacyController.pharmacies.length.toString() +
                              ' found'
                          : _userHospitalController.hospitalList.length
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
                          ? bloodBankController.bloodbank.length
                          : widget.isPharmacy
                              ? pharmacyController.pharmacies.length
                              : _userHospitalController.hospitalList.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.w),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.isPharmacy
                                ? Get.to(PharmacyProductScreen(
                                    userId: pharmacyController
                                        .pharmacies[index].userId
                                        .toString(),
                                  ))
                                : widget.isHospital
                                    ? Get.to(HospitalHomeScreen(
                                        isUser: true,
                                        hospitalId: _userHospitalController
                                            .hospitalList[index].userId
                                            .toString(),
                                      ))
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
                                                  .bloodbank[index].image
                                                  .toString()
                                                  .contains('http')
                                              ? bloodBankController
                                                  .bloodbank[index].image
                                                  .toString()
                                              : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png'
                                          : widget.isPharmacy
                                              ? pharmacyController
                                                      .pharmacies[index].image
                                                      .toString()
                                                      .contains('http')
                                                  ? pharmacyController
                                                      .pharmacies[index].image
                                                      .toString()
                                                  : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png'
                                              : _userHospitalController
                                                      .hospitalList[index].image
                                                      .toString()
                                                      .contains('http')
                                                  ? _userHospitalController
                                                      .hospitalList[index].image
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
                                                  .bloodbank[index].name
                                                  .toString()
                                              : widget.isPharmacy
                                                  ? pharmacyController
                                                      .pharmacies[index].name
                                                      .toString()
                                                  : _userHospitalController
                                                      .hospitalList[index].name
                                                      .toString(),
                                        ),
                                        LocationWidget(
                                          location: widget.isBloodBank
                                              ? bloodBankController
                                                  .bloodbank[index].location
                                                  .toString()
                                              : widget.isPharmacy
                                                  ? pharmacyController
                                                      .pharmacies[index]
                                                      .location
                                                      .toString()
                                                  : _userHospitalController
                                                      .hospitalList[index]
                                                      .location
                                                      .toString(),
                                        ),
                                        ReviewBar(
                                            rating: '0',
                                            count: widget.isBloodBank
                                                ? bloodBankController
                                                    .bloodbank[index]
                                                    .reviews!
                                                    .length
                                                : widget.isPharmacy
                                                    ? pharmacyController
                                                        .pharmacies[index]
                                                        .reviews!
                                                        .length
                                                    : _userHospitalController
                                                        .hospitalList[index]
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
                                                Text('0.0 km/0min',
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
