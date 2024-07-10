import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
import 'package:intl/intl.dart';

import 'package:joy_app/modules/doctor/models/doctor_appointment_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/patient_profile.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:sizer/sizer.dart';

class AllAppointments extends StatelessWidget {
  AllAppointments({super.key});
  DoctorController _doctorController = Get.put(DoctorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
            title: 'Appointments',
            leading: Container(),
            actions: [],
            showIcon: false),
        body: RefreshIndicator(
          onRefresh: () async {
            _doctorController.AllAppointments();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
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
                      Obx(() => _doctorController.doctorAppointment.isEmpty ||
                              _doctorController.doctorAppointment
                                  .where(
                                      (element) => element.status == 'Pending')
                                  .isEmpty
                          ? Column(
                              children: [
                                Center(
                                  child: SubHeading(
                                    title: 'No pending appointments',
                                  ),
                                ),
                                RoundedButtonSmall(
                                    text: 'refresh',
                                    onPressed: () {
                                      _doctorController.AllAppointments();
                                    },
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white)
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  _doctorController.doctorAppointment.length,
                              itemBuilder: (context, index) {
                                if (_doctorController
                                        .doctorAppointment[index].status ==
                                    'Pending') {
                                  return Column(
                                    children: [
                                      AppointmentSelector(
                                        details: _doctorController
                                            .doctorAppointment[index],
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                    ],
                                  );
                                } else
                                  return Container();
                              }))
                    ],
                  ),
                ),
              ),
              Obx(() => _doctorController.appointmentLoader.value
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox())
            ],
          ),
        ));
  }
}

class AppointmentSelector extends StatelessWidget {
  Appointment details;
  AppointmentSelector({required this.details});
  final _doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(PatientProfileScreen(
          details: details,
        ));
      },
      child: Container(
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
                formatDateTime(details.createdAt ?? "2024-06-28 04:29:33"),
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
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.userDetails!.name.toString(),
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            details.complain.toString(),
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
                              Text(details.location.toString(),
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
                  // Expanded(
                  //   child: RoundedButtonSmall(
                  //       text: 'Reschedule',
                  //       onPressed: () {
                  //         //      showPaymentBottomSheet(context, true);
                  //       },
                  //       backgroundColor: ThemeUtil.isDarkMode(context)
                  //           ? Color(0xff0443A9)
                  //           : AppColors.darkBlueColor,
                  //       textColor: AppColors.whiteColor),
                  // ),
                  // SizedBox(
                  //   width: 2.w,
                  // ),
                  Expanded(
                    child: RoundedButtonSmall(
                        text: 'Cancel',
                        onPressed: () {
                          _doctorController.updateAppointment(
                              details.appointmentId.toString(),
                              "CANCELLED",
                              '',
                              context,
                              details.doctorUserId);
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
      ),
    );
  }
}

String formatDateTime(String dateTimeString) {
  try {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat.yMMMMd('en_US').add_Hm();
    return formatter.format(dateTime);
  } catch (e) {
    return dateTimeString;
  }
}
