import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/home/navbar.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/review_screen.dart';
import 'package:joy_app/widgets/rounded_button.dart';

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
                      color: isBloodRequest ? AppColors.redColor : null)),
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
                                    ? Get.to(ReviewScreen(
                                        isPharmacy: true,
                                        pharmacyId: pharmacyId,
                                        buttonBgColor:
                                            ThemeUtil.isDarkMode(context)
                                                ? AppColors.lightGreenColoreb1
                                                : AppColors.darkGreenColor,
                                      ))
                                    : isBloodRequest || isBookAppointment
                                        ? Get.to(Get.offAll(NavBarScreen(
                                            isUser: true,
                                          )))
                                        : Get.offAll(NavBarScreen(
                                            hospitalDetailId: hospitalDetailId,
                                            isBloodBank: isBloodBankForm,
                                            isPharmacy: isPharmacyForm,
                                            isDoctor: isDoctorForm,
                                            isHospital: isHospitalForm,
                                            isUser: isUser));
                              },
                              backgroundColor: buttonColor != null
                                  ? ThemeUtil.isDarkMode(context)
                                      ? Color(0xffC5D3E3)
                                      : Color(0xff1C2A3A)
                                  : isBookAppointment
                                      ? AppColors.darkBlueColor
                                      : isBloodRequest
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
