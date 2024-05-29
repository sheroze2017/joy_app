import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/user_flow/Doctor_flow/home_screen.dart';
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
                            bgColor: AppColors.lightishBlueColor5ff,
                            isActive: false,
                            imgPath: 'Assets/images/oldPerson.png',
                            name: '',
                            time: '',
                            location: '',
                            category: '',
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
                              bgColor: AppColors.lightishBlueColor5ff,
                              isActive: false,
                              imgPath: 'Assets/images/oldPerson.png',
                              name: '',
                              time: '',
                              location: '',
                              category: '',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(PatientProfileScreen());
                          },
                          child: MeetingCallScheduler(
                            buttonColor: AppColors.darkBlueColor,
                            bgColor: AppColors.lightishBlueColor5ff,
                            isActive: false,
                            imgPath: 'Assets/images/oldPerson.png',
                            name: '',
                            time: '',
                            location: '',
                            category: '',
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
                                color: AppColors.blackColor151, size: 20)),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Patient's Name",
                          style: CustomTextStyles.lightTextStyle(
                              color: Color(0xff3D4859)),
                        ),
                        RoundedBorderTextField(
                            controller: TextEditingController(),
                            hintText: 'James Robinson',
                            icon: ''),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Your Daignosis",
                          style: CustomTextStyles.lightTextStyle(
                              color: Color(0xff3D4859)),
                        ),
                        RoundedBorderTextField(
                            maxlines: true,
                            controller: TextEditingController(
                                text:
                                    'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur'),
                            hintText:
                                'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                            icon: ''),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Medications Prescribed",
                          style: CustomTextStyles.lightTextStyle(
                              color: Color(0xff3D4859)),
                        ),
                        RoundedBorderTextField(
                            maxlines: true,
                            controller: TextEditingController(
                                text:
                                    'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur'),
                            hintText:
                                'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                            icon: ''),
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
