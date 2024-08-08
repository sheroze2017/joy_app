import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/component/donors_card.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/fucntions/utils.dart';

class DonationApproval extends StatelessWidget {
  bool isBloodDonate;
  bool isPlasmaDonate;
  bool isOld;
  String date;
  String patName;
  String count;
  String priority;
  String location;
  String bloodType;
  bool isUser;
  String time;
  String phoneNo;
  String city;
  String gender;

  DonationApproval(
      {this.isBloodDonate = false,
      this.isPlasmaDonate = false,
      this.isOld = false,
      this.date = '',
      this.patName = '',
      this.count = '4',
      this.priority = '',
      this.location = 'Cardiology Center, USA',
      this.bloodType = 'B+',
      this.isUser = false,
      this.time = '',
      this.phoneNo = '',
      this.city = '',
      this.gender = ''});
  UserBloodBankController _userBloodBankController =
      Get.put(UserBloodBankController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isBloodDonate
              ? AppColors.redLightColor
              : AppColors.yellowLightColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date + ' ' + convertTimeFormat(time),
              style: CustomTextStyles.darkHeadingTextStyle(size: 14),
            ),
            Divider(
              color: Color(0xffE5E7EB),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient: ' + patName,
                          style: CustomTextStyles.darkHeadingTextStyle(),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'Need: ${count} unit ${isBloodDonate ? 'of ${bloodType} Blood' : ''}',
                          style: CustomTextStyles.w600TextStyle(
                              size: 14, color: Color(0xff4B5563)),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'Timing: ',
                              style: CustomTextStyles.w600TextStyle(
                                  size: 14, color: Color(0xff4B5563)),
                            ),
                            Text(
                              '${priority}Urgently',
                              style: CustomTextStyles.w600TextStyle(
                                  size: 14,
                                  color: isBloodDonate
                                      ? AppColors.redColor
                                      : AppColors.blackColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('Assets/icons/location.svg'),
                            SizedBox(
                              width: 0.5.w,
                            ),
                            Text(location,
                                style: CustomTextStyles.lightTextStyle(
                                    color: Color(0xff4B5563), size: 14))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Color(0xffE5E7EB),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                      text: isOld ? 'Cancel' : 'Donate',
                      onPressed: () {
                        //      showPaymentBottomSheet(context, true);
                      },
                      backgroundColor: isBloodDonate
                          ? AppColors.redColor
                          : AppColors.yellowColor,
                      textColor: AppColors.whiteColor),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: RoundedButtonSmall(
                      text: isUser
                          ? 'Share'
                          : isOld
                              ? 'Re-post'
                              : 'Contact',
                      onPressed: () {
                        isOld
                            ? _userBloodBankController.createBloodAppeal(
                                patName,
                                date,
                                time,
                                count,
                                bloodType,
                                gender,
                                city,
                                location,
                                '',
                                isBloodDonate ? 'Blood' : 'Plasna',
                                context)
                            : makingPhoneCall(
                                phoneNo); //      showPaymentBottomSheet(context, true);
                      },
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? AppColors.blackColor
                          : AppColors.whiteColor,
                      textColor: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : isBloodDonate
                              ? AppColors.redColor
                              : AppColors.yellowColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
