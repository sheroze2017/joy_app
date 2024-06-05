import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/review_screen.dart';
import 'package:sizer/sizer.dart';

class ManageAllAppointmentUser extends StatefulWidget {
  const ManageAllAppointmentUser({super.key});

  @override
  State<ManageAllAppointmentUser> createState() =>
      _ManageAllAppointmentUserState();
}

class _ManageAllAppointmentUserState extends State<ManageAllAppointmentUser>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: CustomTextStyles.darkTextStyle(color: Color(0xff374151)),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.darkBlueColor,
          labelColor: AppColors.darkBlueColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: CustomTextStyles.w600TextStyle(size: 16),
          tabs: [
            Tab(
              text: 'Upcoming',
            ),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  AppointmentCardUser(),
                  SizedBox(
                    height: 1.h,
                  ),
                  AppointmentCardUser(),
                  SizedBox(
                    height: 1.h,
                  ),
                  AppointmentCardUser()
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  AppointmentCardUser(
                    isCompleted: true,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  AppointmentCardUser(
                    isCompleted: true,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  AppointmentCardUser(
                    isCompleted: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCardUser extends StatelessWidget {
  bool isCompleted;
  AppointmentCardUser({this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.lightishBlueColor5ff),
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
              color: Color(0xffE5E7EB),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'Assets/images/doctor.png',
                    width: 27.9.w,
                    height: 27.9.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. James Robins',
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
                      text: isCompleted ? 'Re-Book' : 'Cancel',
                      onPressed: () {
                        //      showPaymentBottomSheet(context, true);
                      },
                      backgroundColor: AppColors.lightGreyColor,
                      textColor: AppColors.darkBlueColor),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: RoundedButtonSmall(
                      text: isCompleted ? 'Add Review' : 'Reschedule',
                      onPressed: () {
                        isCompleted
                            ? Get.to(ReviewScreen(
                                buttonBgColor: AppColors.darkBlueColor,
                              ))
                            : print('');
                      },
                      backgroundColor: AppColors.darkBlueColor,
                      textColor: AppColors.whiteColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
