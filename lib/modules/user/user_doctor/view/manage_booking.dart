import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/modules/pharmacy/view/review_screen.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

import '../bloc/user_doctor_bloc.dart';
import '../model/all_user_appointment.dart';
import '../../../../common/profile/view/my_profile.dart';
import 'doctor_daignosis.dart';

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

  final _userdoctorController = Get.find<UserDoctorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.whiteColor
                  : Color(0xff374151)),
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
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Obx(() => _userdoctorController.userAppointment.isEmpty ||
                            _userdoctorController.userAppointment
                                .where((element) => element.status == 'Pending')
                                .isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Center(
                              child: SubHeading(
                                title: 'No upcoming appointments',
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: _userdoctorController
                                    .userAppointment.length,
                                itemBuilder: (context, index) {
                                  if (_userdoctorController
                                          .userAppointment[index].status ==
                                      'Pending') {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        AppointmentCardUser(
                                          bookingDetail: _userdoctorController
                                              .userAppointment[index],
                                        ),
                                      ],
                                    );
                                  } else
                                    return Container();
                                }),
                          )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Obx(() => _userdoctorController.userAppointment.isEmpty ||
                            _userdoctorController.userAppointment
                                .where((element) =>
                                    element.status!.toLowerCase() ==
                                    'completed')
                                .isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Center(
                              child: SubHeading(
                                title: 'No appointments yet completed',
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: _userdoctorController
                                    .userAppointment.length,
                                itemBuilder: (context, index) {
                                  if (_userdoctorController
                                          .userAppointment[index].status!
                                          .toLowerCase() ==
                                      'completed') {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                DoctorDaginosis(
                                                  details: _userdoctorController
                                                      .userAppointment[index],
                                                  prescription:
                                                      _userdoctorController
                                                          .userAppointment[
                                                              index]
                                                          .medications,
                                                  patName: _userdoctorController
                                                      .userAppointment[index]
                                                      .patientName,
                                                  daignosis:
                                                      _userdoctorController
                                                          .userAppointment[
                                                              index]
                                                          .diagnosis,
                                                ),
                                                transition: Transition.native);
                                          },
                                          child: AppointmentCardUser(
                                            bookingDetail: _userdoctorController
                                                .userAppointment[index],
                                            isCompleted: true,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else
                                    return Container();
                                }),
                          )),
                  ],
                ),
              ),
            ],
          ),
          Obx(() => _userdoctorController.appointmentLoader.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ))
              : Container())
        ],
      ),
    );
  }
}

class AppointmentCardUser extends StatelessWidget {
  bool isCompleted;
  UserAppointment bookingDetail;
  AppointmentCardUser({required this.bookingDetail, this.isCompleted = false});
  final _userdoctorController = Get.find<UserDoctorController>();

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
              bookingDetail.date.toString() +
                  ' - ' +
                  bookingDetail.time.toString(),
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
                  child: Image.network(
                    "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
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
                            bookingDetail.doctorDetails!.doctorName.toString(),
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            bookingDetail
                                .doctorDetails!.doctorDetails!.qualification
                                .toString(),
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
                              Text(bookingDetail.location.toString(),
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
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff1f2228)
                  : Color(0xffE5E7EB),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                      isSmall: true,
                      isBold: true,
                      text: isCompleted ? 'Re-Book' : 'Cancel',
                      onPressed: () {
                        isCompleted
                            ? Get.to(
                                DoctorDetailScreen2(
                                  doctorId:
                                      bookingDetail.doctorUserId.toString(),
                                  docName: '',
                                  location: '',
                                  Category: '',
                                ),
                                transition: Transition.native)
                            : _userdoctorController.updateAppointment(
                                bookingDetail.appointmentId.toString(),
                                'CANCELLED',
                                '',
                                context,
                                bookingDetail.doctorUserId.toString());
                        //      showPaymentBottomSheet(context, true);
                      },
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? Color(0xff00143D)
                          : AppColors.lightGreyColor,
                      textColor: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : Color(0xff033890)),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: RoundedButtonSmall(
                      text: isCompleted ? 'Add Review' : 'Reschedule',
                      onPressed: () {
                        isCompleted
                            ? Get.to(
                                ReviewScreen(
                                  details: bookingDetail,
                                  buttonBgColor: Color(0xff033890),
                                ),
                                transition: Transition.native)
                            : print('');
                      },
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? Color(0xff0443A9)
                          : AppColors.darkBlueColor,
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
