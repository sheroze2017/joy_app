import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';

class ConfirmationDailog extends StatelessWidget {
  final String link_to_user_id;
  ConfirmationDailog({super.key, required this.link_to_user_id});
  final _hospitalDetailController = Get.find<HospitalDetailController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Linkage',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.getCurrentTheme(context).primaryColor)),
      content:
          Text('Are you sure you want to attach this user to your hospital?'),
      actions: <Widget>[
        RoundedButton(
            text: 'No',
            onPressed: () {
              Get.back();
            },
            backgroundColor: ThemeUtil.isDarkMode(context)
                ? AppColors.blackColor
                : AppColors.whiteColor,
            textColor: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : AppColors.blackColor),
        Obx(
          () => RoundedButton(
              showLoader: _hospitalDetailController.linkLoader.value,
              text: 'Yes',
              onPressed: () async {
                await _hospitalDetailController.linkProfile(
                    link_to_user_id, context);
              },
              backgroundColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xffC5D3E3)
                  : Color(0xff1C2A3A),
              textColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xff121212)
                  : AppColors.whiteColor),
        )
      ],
    );
  }
}

class ConfirmationUnLinkDailog extends StatelessWidget {
  final String link_to_user_id;
  ConfirmationUnLinkDailog({super.key, required this.link_to_user_id});
  final _hospitalDetailController = Get.find<HospitalDetailController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Unlink Profile',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.getCurrentTheme(context).primaryColor)),
      content:
          Text('Are you sure you want to remove this user from your hospital?'),
      actions: <Widget>[
        RoundedButton(
            text: 'No',
            onPressed: () {
              Get.back();
            },
            backgroundColor: ThemeUtil.isDarkMode(context)
                ? AppColors.blackColor
                : AppColors.whiteColor,
            textColor: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : AppColors.blackColor),
        Obx(
          () => RoundedButton(
              showLoader: _hospitalDetailController.unlinkLoader.value,
              text: 'Yes',
              onPressed: () async {
                await _hospitalDetailController.unLinkProfile(
                    link_to_user_id, context);
              },
              backgroundColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xffC5D3E3)
                  : Color(0xff1C2A3A),
              textColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xff121212)
                  : AppColors.whiteColor),
        )
      ],
    );
  }
}

class ConfirmationPharmacyLinkDailog extends StatelessWidget {
  final String pharmacy_id;
  ConfirmationPharmacyLinkDailog({super.key, required this.pharmacy_id});
  final _hospitalDetailController = Get.find<HospitalDetailController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Link Pharmacy',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.getCurrentTheme(context).primaryColor)),
      content:
          Text('Are you sure you want to link this pharmacy to your hospital?'),
      actions: <Widget>[
        RoundedButton(
            text: 'No',
            onPressed: () {
              Get.back();
            },
            backgroundColor: ThemeUtil.isDarkMode(context)
                ? AppColors.blackColor
                : AppColors.whiteColor,
            textColor: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : AppColors.blackColor),
        Obx(
          () => RoundedButton(
              showLoader: _hospitalDetailController.linkLoader.value,
              text: 'Yes',
              onPressed: () async {
                await _hospitalDetailController.linkPharmacy(
                    pharmacy_id, context);
              },
              backgroundColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xffC5D3E3)
                  : Color(0xff1C2A3A),
              textColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xff121212)
                  : AppColors.whiteColor),
        )
      ],
    );
  }
}
