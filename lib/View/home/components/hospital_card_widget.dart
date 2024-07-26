import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/modules/user/user_blood_bank/model/all_bloodbank_model.dart';
import 'package:joy_app/modules/user/user_hospital/model/all_hospital_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';

import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:sizer/sizer.dart';

class HosipitalCardWidget extends StatelessWidget {
  String? name;
  String? location;
  bool isPharmacy;
  bool isHospital;
  bool isDoctor;
  bool isBloodBank;
  bool isUser;
  PharmacyModelData? pharmacyData;
  BloodBank? bloodBankData;
  Hospital? hospitalData;
  HosipitalCardWidget(
      {this.name,
      this.location,
      this.isBloodBank = false,
      this.isHospital = false,
      this.isDoctor = false,
      this.isPharmacy = false,
      this.pharmacyData,
      this.bloodBankData,
      this.hospitalData,
      this.isUser = false});
  final locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 59.4.w,
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xffE5E7EB),
              width: ThemeUtil.isDarkMode(context) ? 0.1 : 1),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.network(
              getImageUrl(),
              width: 59.4.w,
              height: 31.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: HospitalName(
              hospitalName: isPharmacy
                  ? pharmacyData!.name.toString()
                  : isBloodBank
                      ? bloodBankData!.name.toString()
                      : hospitalData!.name.toString(),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: LocationWidget(
              location: isPharmacy
                  ? pharmacyData!.location.toString()
                  : isBloodBank
                      ? bloodBankData!.location.toString()
                      : hospitalData!.location.toString(),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ReviewBar(
                rating: '0.0',
                count: isPharmacy
                    ? pharmacyData!.reviews!.length
                    : isBloodBank
                        ? bloodBankData!.reviews!.length
                        : hospitalData!.reviews!.length),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              color: Color(0xffE5E7EB),
              thickness: ThemeUtil.isDarkMode(context) ? 0.2 : 0.6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            child: Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('Assets/icons/routing.svg'),
                    SizedBox(
                      width: 0.5.w,
                    ),
                    Text(
                        calculateDistance(
                                    isPharmacy
                                        ? pharmacyData!.lat!
                                        : isBloodBank
                                            ? bloodBankData!.lat!
                                            : hospitalData!.lat!,
                                    isPharmacy
                                        ? pharmacyData!.lng!
                                        : isBloodBank
                                            ? bloodBankData!.lng!
                                            : hospitalData!.lng!,
                                    locationController.latitude.value,
                                    locationController.longitude.value)
                                .toStringAsFixed(0) +
                            ' km/0min',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 10.8))
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    SvgPicture.asset(isPharmacy
                        ? 'Assets/icons/pharmacy.svg'
                        : 'Assets/icons/hospital.svg'),
                    SizedBox(
                      width: 0.5.w,
                    ),
                    Text(
                        isPharmacy
                            ? 'Pharmacy'
                            : isBloodBank
                                ? 'Blood Bank'
                                : 'Hospital',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 10.8))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getImageUrl() {
    if (isPharmacy) {
      return pharmacyData?.image?.contains('http') == true
          ? pharmacyData!.image.toString()
          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg';
    } else if (isHospital) {
      return hospitalData?.image?.contains('http') == true
          ? hospitalData!.image.toString()
          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg';
    } else if (isBloodBank) {
      return bloodBankData?.image?.contains('http') == true
          ? bloodBankData!.image.toString()
          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg';
    } else {
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg';
    }
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  lat1 = double.tryParse(lat1) ?? 0.0;
  lon1 = double.tryParse(lon1) ?? 0.0;
  const R = 6371; // Radius of the earth in km
  var dLat = _toRad(lat2 - lat1);
  var dLon = _toRad(lon2 - lon1);
  var lat1Rad = _toRad(lat1);
  var lat2Rad = _toRad(lat2);

  var a = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1Rad) * cos(lat2Rad);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = R * c;

  return d; // Distance in km
}

double _toRad(x) {
  return x * pi / 180;
}
