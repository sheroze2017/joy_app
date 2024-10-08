import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/modules/blood_bank/view/all_donor_screen.dart';
import 'package:joy_app/modules/pharmacy/view/review_screen.dart';
import 'package:joy_app/modules/user/user_blood_bank/model/all_bloodbank_model.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/blood_donation_appeal.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';

import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  String? hospitalDetailId;
  bool? isPharmacyCheckout;
  bool showButton;
  bool isBookAppointment;
  Color? buttonColor;
  bool? isDoctorForm;
  bool? isPharmacyForm;
  bool? isBloodBankForm;
  bool? isDoctorAppointment;
  bool? isHospitalForm;
  bool isBloodRequest;
  bool isUser;
  bool isRegisterDonor;
  String? pharmacyId;
  CustomDialog(
      {super.key,
      required this.title,
      this.pharmacyId,
      required this.content,
      this.buttonColor,
      this.hospitalDetailId,
      this.isPharmacyCheckout = false,
      this.showButton = false,
      this.isBookAppointment = false,
      this.isDoctorForm = false,
      this.isDoctorAppointment = false,
      this.isBloodBankForm = false,
      this.isPharmacyForm = false,
      this.isHospitalForm = false,
      this.isUser = false,
      this.isRegisterDonor = false,
      this.isBloodRequest = false});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),
        ),
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          child: dialogContent(context, isBookAppointment),
        ),
      ],
    );
  }

  dialogContent(BuildContext context, isBookAppointment) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 20),
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(48),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'Assets/images/accountcreated.svg',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 2.h),
              Text(title,
                  style: CustomTextStyles.darkTextStyle(
                      color: (isBloodRequest || isRegisterDonor)
                          ? AppColors.redColor
                          : null)),
              SizedBox(height: 2.h),
              Text(
                content,
                style: CustomTextStyles.lightTextStyle(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xffAAAAAA)
                        : null),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
              SizedBox(height: 2.h),
              showButton
                  ? Row(
                      children: [
                        Expanded(
                          child: RoundedButton(
                              text: 'Done',
                              onPressed: () {
                                isPharmacyCheckout == true
                                    ? Get.to(
                                        ReviewScreen(
                                          isPharmacy: true,
                                          pharmacyId: pharmacyId,
                                          buttonBgColor:
                                              ThemeUtil.isDarkMode(context)
                                                  ? AppColors.lightGreenColoreb1
                                                  : AppColors.darkGreenColor,
                                        ),
                                        transition: Transition.native)
                                    : isBloodRequest
                                        ? {
                                            Get.back(),
                                            Get.off(AllDonorScreen())
                                          }
                                        : isRegisterDonor
                                            ? {
                                                Get.back(),
                                                Get.off(
                                                    BloodDonationAppealUser(
                                                      isBloodDontate: true,
                                                      isUser: true,
                                                    ),
                                                    transition:
                                                        Transition.native)
                                              }
                                            : isBookAppointment
                                                ? {
                                                    Get.back(),
                                                    Get.back(),
                                                    Get.back(),
                                                    Get.back()
                                                  }
                                                : Get.offAll(
                                                    NavBarScreen(
                                                        hospitalDetailId:
                                                            hospitalDetailId,
                                                        isBloodBank:
                                                            isBloodBankForm,
                                                        isPharmacy:
                                                            isPharmacyForm,
                                                        isDoctor: isDoctorForm,
                                                        isHospital:
                                                            isHospitalForm,
                                                        isUser: isUser),
                                                    transition:
                                                        Transition.native);
                              },
                              backgroundColor: buttonColor != null
                                  ? ThemeUtil.isDarkMode(context)
                                      ? Color(0xffC5D3E3)
                                      : Color(0xff1C2A3A)
                                  : isBookAppointment
                                      ? AppColors.darkBlueColor
                                      : (isBloodRequest || isRegisterDonor)
                                          ? AppColors.redColor
                                          : AppColors.darkGreenColor,
                              textColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0xff121212)
                                  : AppColors.whiteColor),
                        ),
                      ],
                    )
                  : SpinKitFadingCircle(
                      color: Colors.grey,
                      size: 50.0,
                    )
            ],
          ),
        ),
      ],
    );
  }
}
