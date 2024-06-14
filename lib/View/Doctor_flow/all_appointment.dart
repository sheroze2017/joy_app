import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class AllAppointments extends StatelessWidget {
  const AllAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Appointments',
          leading: Container(),
          actions: [],
          showIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Divider(
                color: Color(0xffE5E7EB),
              ),
              SizedBox(
                height: 2.h,
              ),
              AppointmentSelector(),
              SizedBox(
                height: 1.h,
              ),
              AppointmentSelector(),
              SizedBox(
                height: 1.h,
              ),
              AppointmentSelector()
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentSelector extends StatelessWidget {
  const AppointmentSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeUtil.isDarkMode(context)
              ? AppColors.purpleBlueColor
              : AppColors.lightishBlueColor5ff),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'May 22, 2023 - 10.00 AM',
              style: CustomTextStyles.darkHeadingTextStyle(size: 14),
            ),
            Divider(
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff1f2228)
                  : Color(0xffE5E7EB),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'Assets/images/oldPerson.png',
                    width: 27.9.w,
                    height: 27.9.w,
                    fit: BoxFit.cover,
                  ),
                ),
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
                          'James Robinson',
                          style: CustomTextStyles.darkHeadingTextStyle(),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'Cancer Patient',
                          style: CustomTextStyles.w600TextStyle(
                              size: 14, color: Color(0xff4B5563)),
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
                            Text('USA',
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
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff1f2228)
                  : Color(0xffE5E7EB),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                      text: 'Reschedule',
                      onPressed: () {
                        //      showPaymentBottomSheet(context, true);
                      },
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? Color(0xff0443A9)
                          : AppColors.darkBlueColor,
                      textColor: AppColors.whiteColor),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: RoundedButtonSmall(
                      text: 'Cancel',
                      onPressed: () {
                        //      showPaymentBottomSheet(context, true);
                      },
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? Color(0xff00143D)
                          : AppColors.lightGreyColor,
                      textColor: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : AppColors.darkBlueColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
