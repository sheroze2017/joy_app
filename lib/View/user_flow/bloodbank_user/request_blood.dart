import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/view/user_flow/bloodbank_user/select_timing_screen.dart';
import 'package:joy_app/widgets/custom_appbar.dart';
import 'package:joy_app/widgets/custom_textfield.dart';
import 'package:joy_app/widgets/rounded_button.dart';
import 'package:sizer/sizer.dart';

class RequestBlood extends StatefulWidget {
  bool isRegister;
  RequestBlood({this.isRegister = false});
  @override
  State<RequestBlood> createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: widget.isRegister ? 'Register as Donor' : 'Request Blood',
          leading: Container(),
          actions: [],
          showIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: widget.isRegister
              ? Column(
                  children: [
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Enter Name',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Blood Group',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      isenable: false,
                      controller: TextEditingController(),
                      hintText: 'Location',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Gender',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'City',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                              text: widget.isRegister
                                  ? 'Register'
                                  : 'Request Blood',
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return CustomDialog(
                                //       isDoctorForm: true,
                                //       buttonColor: Color(0xff1C2A3A),
                                //       showButton: true,
                                //       title: 'Congratulations!',
                                //       content:
                                //           'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                //     );
                                //   },
                                // );
                              },
                              backgroundColor: AppColors.redColor,
                              textColor: Color(0xffFFFFFF)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                  ],
                )
              : Column(
                  children: [
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Enter Patient Name',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(SelectTimingScreen());
                      },
                      child: RoundedBorderTextField(
                        isenable: false,
                        controller: TextEditingController(),
                        hintText: 'When do you need it ? Select Time & Date',
                        icon: '',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Enter Units of Blood required',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Enter Blood Group Required',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Gender',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'City',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: TextEditingController(),
                      hintText: 'Your Location',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                              text: 'Request Blood',
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return CustomDialog(
                                //       isDoctorForm: true,
                                //       buttonColor: Color(0xff1C2A3A),
                                //       showButton: true,
                                //       title: 'Congratulations!',
                                //       content:
                                //           'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                //     );
                                //   },
                                // );
                              },
                              backgroundColor: AppColors.redColor,
                              textColor: Color(0xffFFFFFF)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
