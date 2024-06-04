import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/view/user_flow/bloodbank_user/select_timing_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:sizer/sizer.dart';

class RequestBlood extends StatefulWidget {
  bool isRegister;
  RequestBlood({this.isRegister = false});
  @override
  State<RequestBlood> createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodGroupUnitsController =
      TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();

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
                      controller: _fnameController,
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
                      hintText: 'Enter Name',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _bloodGroupController,
                      focusNode: _focusNode2,
                      nextFocusNode: _focusNode3,
                      hintText: 'Blood Group',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _locationController,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                      isenable: false,
                      hintText: 'Location',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SearchDropdown(
                      hintText: 'Gender',
                      items: ['Male', 'Female'],
                      value: '',
                      onChanged: (String? value) {},
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _cityController,
                      focusNode: _focusNode5,
                      nextFocusNode: _focusNode6,
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
                      controller: _nameController,
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
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
                        controller: _timeController,
                        focusNode: _focusNode2,
                        nextFocusNode: _focusNode3,
                        hintText: 'When do you need it ? Select Time & Date',
                        icon: '',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _bloodGroupUnitsController,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                      hintText: 'Enter Units of Blood required',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _bloodGroupController,
                      focusNode: _focusNode4,
                      nextFocusNode: _focusNode5,
                      hintText: 'Enter Blood Group Required',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SearchDropdown(
                      hintText: 'Gender',
                      items: ['Male', 'Female'],
                      value: '',
                      onChanged: (String? value) {},
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _cityController,
                      focusNode: _focusNode6,
                      nextFocusNode: _focusNode7,
                      hintText: 'City',
                      icon: '',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RoundedBorderTextField(
                      controller: _locationController,
                      focusNode: _focusNode7,
                      nextFocusNode: _focusNode8,
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
