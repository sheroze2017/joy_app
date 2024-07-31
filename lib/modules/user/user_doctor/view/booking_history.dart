import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/user/user_doctor/view/manage_booking.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import '../bloc/user_doctor_bloc.dart';
import '../../../../common/profile/view/my_profile.dart';
import 'doctor_daignosis.dart';

class UserBookingHistory extends StatefulWidget {
  const UserBookingHistory({super.key});

  @override
  State<UserBookingHistory> createState() => _ManageAllAppointmentUserState();
}

class _ManageAllAppointmentUserState extends State<UserBookingHistory>
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
          'Medical History',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.whiteColor
                  : Color(0xff374151)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Obx(() => _userdoctorController.userAppointment.isEmpty ||
                    _userdoctorController.userAppointment
                        .where((element) =>
                            element.status!.toLowerCase() == 'completed')
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
                        itemCount: _userdoctorController.userAppointment.length,
                        itemBuilder: (context, index) {
                          if (_userdoctorController
                                  .userAppointment[index].status!
                                  .toLowerCase() ==
                              'completed') {
                            final doctorData =
                                _userdoctorController.userAppointment[index];
                            return InkWell(
                              onTap: () {
                                Get.to(
                                    DoctorDaginosis(
                                      details: _userdoctorController
                                          .userAppointment[index],
                                      prescription: _userdoctorController
                                          .userAppointment[index].medications,
                                      patName: _userdoctorController
                                          .userAppointment[index].patientName,
                                      daignosis: _userdoctorController
                                          .userAppointment[index].diagnosis,
                                    ),
                                    transition: Transition.native);
                              },
                              child: DoctorsCardWidget(
                                imgUrl: doctorData.doctorDetails!.doctorImage
                                    .toString(),
                                reviewCount: '',
                                docName: doctorData.doctorDetails!.doctorName
                                    .toString(),
                                Category: '',
                                loction: doctorData.doctorDetails!.doctorLocation.toString(),
                                rating: '5',
                              ),
                            );
                          } else
                            return SizedBox();
                        }),
                  )),
          ],
        ),
      ),
    );
  }
}
