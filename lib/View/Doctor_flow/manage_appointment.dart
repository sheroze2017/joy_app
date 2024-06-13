import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/doctor_flow/home_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import 'patient_profile.dart';

class ManageAppointment extends StatefulWidget {
  bool? showPatientHistoryFromScreen;

  ManageAppointment({super.key, this.showPatientHistoryFromScreen = false});

  @override
  State<ManageAppointment> createState() => _ManageAppointmentState();
}

class _ManageAppointmentState extends State<ManageAppointment> {
  bool showPatientHistory = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daignosisController = TextEditingController(
      text:
          'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur');
  final TextEditingController _prescriptionController = TextEditingController(
      text:
          'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur');

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: showPatientHistory == true ||
                      widget.showPatientHistoryFromScreen == true
                  ? Column(
                      children: [
                        Divider(
                          color: Color(0xffE5E7EB),
                          thickness: 0.3,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(PatientProfileScreen());
                          },
                          child: MeetingCallScheduler(
                            buttonColor: AppColors.darkBlueColor,
                            bgColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.purpleBlueColor
                                : AppColors.lightishBlueColor5ff,
                            isActive: false,
                            imgPath: 'Assets/images/oldPerson.png',
                            name: 'James',
                            time: '22:30 Am - 23:00 Am',
                            location: 'Imam Hospital',
                            category: 'Cardiology',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(PatientProfileScreen());
                            },
                            child: MeetingCallScheduler(
                              buttonColor: AppColors.darkBlueColor,
                              bgColor: ThemeUtil.isDarkMode(context)
                                  ? AppColors.purpleBlueColor
                                  : AppColors.lightishBlueColor5ff,
                              isActive: false,
                              imgPath: 'Assets/images/oldPerson.png',
                              name: 'James',
                              time: '22:30 Am - 23:00 Am',
                              location: 'Imam Hospital',
                              category: 'Cardiology',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(PatientProfileScreen());
                          },
                          child: MeetingCallScheduler(
                            buttonColor: AppColors.darkBlueColor,
                            bgColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.purpleBlueColor
                                : AppColors.lightishBlueColor5ff,
                            isActive: false,
                            imgPath: 'Assets/images/oldPerson.png',
                            name: 'James',
                            time: '22:30 Am - 23:00 Am',
                            location: 'Imam Hospital',
                            category: 'Cardiology',
                          ),
                        ),
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
                                    onPressed: () {},
                                    backgroundColor: AppColors.darkBlueColor,
                                    textColor: AppColors.whiteColor),
                              ),
                            ],
                          ),
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
                            hintText:
                                'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
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
                          maxlines: true,
                          hintText: 'Medication Prescription',
                          controller: _prescriptionController,
                          icon: '',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: RoundedButtonSmall(
                                    text: 'Submit',
                                    onPressed: () {
                                      // showPatientHistory = !showPatientHistory;
                                      // setState(() {});
                                    },
                                    backgroundColor: AppColors.darkBlueColor,
                                    textColor: AppColors.whiteColor),
                              ),
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
        ));
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Duration _remainingTime = Duration(minutes: 1, seconds: 0);

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateTimer() {
    setState(() {
      _remainingTime -= Duration(seconds: 1);
      if (_remainingTime.inSeconds <= 0) {
        _controller.stop();
      }
    });
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
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
