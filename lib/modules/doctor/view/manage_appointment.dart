import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/widgets/flutter_toast_message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/home_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../bloc/doctor_bloc.dart';
import 'patient_profile.dart';

class ManageAppointment extends StatefulWidget {
  bool? showPatientHistoryFromScreen;
  String? appointmentId;
  String? doctorId;
  String? phoneNo;
  ManageAppointment(
      {super.key,
      this.showPatientHistoryFromScreen = false,
      this.doctorId,
      this.phoneNo,
      this.appointmentId});

  @override
  State<ManageAppointment> createState() => _ManageAppointmentState();
}

class _ManageAppointmentState extends State<ManageAppointment> {
  bool showPatientHistory = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daignosisController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final _doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showPatientHistory = !showPatientHistory;
          setState(() {});
          return true;
        },
        child: Scaffold(
          appBar: HomeAppBar(
              title: showPatientHistory == true ||
                      widget.showPatientHistoryFromScreen == true
                  ? 'Patients History'
                  : 'Appointment In Progress',
              leading: Container(),
              actions: [],
              showIcon: false),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: showPatientHistory == true ||
                        widget.showPatientHistoryFromScreen == true
                    ? _doctorController.doctorAppointment
                                .where((p0) => p0.status == 'COMPLETED')
                                .length ==
                            0
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'No appointments dealt yet',
                                  style: CustomTextStyles.lightTextStyle(),
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
                        : Column(
                            children: [
                              Divider(
                                color: Color(0xffE5E7EB),
                                thickness: 0.3,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Obx(() => ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _doctorController
                                      .doctorAppointment.length,
                                  itemBuilder: (context, index) {
                                    if (_doctorController
                                            .doctorAppointment[index].status ==
                                        'COMPLETED') {
                                      final data = _doctorController
                                          .doctorAppointment[index];
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                  PatientProfileScreen(
                                                    details: data,
                                                  ),
                                                  transition:
                                                      Transition.native);
                                            },
                                            child: MeetingCallScheduler(
                                              buttonColor:
                                                  AppColors.darkBlueColor,
                                              bgColor:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors
                                                          .purpleBlueColor
                                                      : AppColors
                                                          .lightishBlueColor5ff,
                                              isActive: false,
                                              imgPath: data.userDetails!.image
                                                  .toString(),
                                              name: data.userDetails!.name
                                                  .toString(),
                                              time:
                                                  '${data.date}  ${data.time}',
                                              location:
                                                  data.location.toString(),
                                              category: data.gender.toString(),
                                            ),
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
                          )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          TimerWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RoundedButtonSmall(
                                      text: 'Finish',
                                      onPressed: () {
                                        showSuccessMessage(context,
                                            'Appointment finished please submit review for user');
                                      },
                                      backgroundColor: AppColors.darkBlueColor,
                                      textColor: AppColors.whiteColor),
                                ),
                              ],
                            ),
                          ),
                          Text('Make Phone Call to User',
                              style: CustomTextStyles.w600TextStyle(
                                  color: ThemeUtil.isDarkMode(context)
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor151,
                                  size: 16)),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    _makingPhoneCall(widget.phoneNo!);
                                  },
                                  child: Container(
                                      height: 7.h,
                                      width: 7.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            width: 5,
                                            color: AppColors.darkBlueColor,
                                          )),
                                      child: Center(
                                        child: Icon(
                                          Icons.phone,
                                          color: AppColors.darkBlueColor,
                                        ),
                                      ))),
                              SizedBox(
                                width: 4.w,
                              ),
                              InkWell(
                                onTap: () {
                                  openwhatsapp(widget.phoneNo);
                                },
                                child: Container(
                                  height: 7.h,
                                  width: 7.h,
                                  child: SvgPicture.asset(
                                      'Assets/icons/whatsapp-circle.svg'),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4.w,
                          ),
                          Text('Review to Patient ',
                              style: CustomTextStyles.w600TextStyle(
                                  color: ThemeUtil.isDarkMode(context)
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor151,
                                  size: 20)),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Patient's Name",
                            style: CustomTextStyles.lightTextStyle(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffDBDBDB)
                                    : Color(0xff3D4859)),
                          ),
                          RoundedBorderTextField(
                              controller: _nameController,
                              focusNode: _focusNode1,
                              nextFocusNode: _focusNode2,
                              hintText: 'James Robinson',
                              icon: ''),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Your Daignosis",
                            style: CustomTextStyles.lightTextStyle(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffDBDBDB)
                                    : Color(0xff3D4859)),
                          ),
                          RoundedBorderTextField(
                              focusNode: _focusNode2,
                              nextFocusNode: _focusNode3,
                              maxlines: true,
                              controller: _daignosisController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter daignosis';
                                } else {
                                  return null;
                                }
                              },
                              hintText: 'Daignoses ',
                              icon: ''),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Medications Prescribed",
                            style: CustomTextStyles.lightTextStyle(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffDBDBDB)
                                    : Color(0xff3D4859)),
                          ),
                          RoundedBorderTextField(
                            focusNode: _focusNode3,
                            nextFocusNode: _focusNode4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Prescription';
                              } else {
                                return null;
                              }
                            },
                            maxlines: true,
                            hintText: 'Medication Prescription',
                            controller: _prescriptionController,
                            icon: '',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => _doctorController
                                          .appointmentLoader.value
                                      ? Center(
                                          child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: CircularProgressIndicator(),
                                        ))
                                      : Expanded(
                                          child: RoundedButtonSmall(
                                              text: 'Submit',
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                } else {
                                                  _doctorController
                                                      .updateAppointment(
                                                          widget.appointmentId
                                                              .toString(),
                                                          'COMPLETED',
                                                          '${_daignosisController.text.toString()} ${_prescriptionController.text.toString()}',
                                                          context,
                                                          widget.doctorId
                                                              .toString());
                                                  _doctorController
                                                      .giveMedication(
                                                    widget.appointmentId
                                                        .toString(),
                                                    _daignosisController.text
                                                        .toString(),
                                                    _prescriptionController.text
                                                        .toString(),
                                                    context,
                                                  );
                                                }
                                              },
                                              backgroundColor:
                                                  AppColors.darkBlueColor,
                                              textColor: AppColors.whiteColor),
                                        ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          )
                        ],
                      ),
              ),
            ),
          ),
        ));
  }

  _makingPhoneCall(String phoneNo) async {
    var url = Uri.parse("tel:${phoneNo}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openwhatsapp(whatsapp) async {
    var androidUrl =
        "whatsapp://send?phone=$whatsapp&text='Hi, hope you are doing well \nLet we start the meeting to discuss your health issues.'";
    var iosUrl =
        "https://wa.me/$whatsapp?text=${Uri.parse('Hi, hope you are doing well \nLet we start the meeting to discuss your health issues.')}";

    // android , web
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
    // }
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Duration _remainingTime = Duration(minutes: 30, seconds: 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _remainingTime,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(_remainingTime);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 10,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.darkBlueColor),
                backgroundColor: Colors.white,
              ),
            ),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: ThemeUtil.isDarkMode(context)
                    ? AppColors.whiteColor
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
