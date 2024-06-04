import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/appbar.dart';

class HospitalFormScreen extends StatefulWidget {
  const HospitalFormScreen({super.key});

  @override
  State<HospitalFormScreen> createState() => _HospitalFormScreenState();
}

class _HospitalFormScreenState extends State<HospitalFormScreen> {
  String? selectedValue;

  final TextEditingController _contactController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: 'May 22,2024 - 10:00 AM to 10:30 AM');

  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Your Hospital',
        icon: Icons.arrow_back_sharp,
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Container(
          //color: Color(0xffFFFFFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      width: 100.w,
                      height: 42.56.w,
                      decoration: BoxDecoration(
                          color: AppColors.silverColor4f6,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(29),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      child: Center(
                        child:
                            SvgPicture.asset('Assets/images/upload-cover.svg'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset('Assets/images/message-edit.svg'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _nameController,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  hintText: 'Hospital Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _contactController,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  hintText: 'Contact',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: () {
                    showDialog<List<String>>(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiTimeSelector(times: [
                          '09:00 AM',
                          '10:00 AM',
                          '11:00 AM',
                          '12:00 PM',
                          '01:00 PM',
                          '02:00 PM',
                          '03:00 PM',
                          '04:00 PM',
                          '05:00 PM',
                          '06:00 PM',
                          '07:00 PM',
                          '08:00 PM',
                        ]);
                      },
                    ).then((selectedTimes) {
                      if (selectedTimes != null && selectedTimes.isNotEmpty) {
                        print('Selected Times: $selectedTimes');
                      }
                    });
                  },
                  child: RoundedBorderTextField(
                    controller: _timeController,
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    isenable: false,
                    hintText: 'Timings',
                    icon: '',
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _feesController,
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  hintText: 'Check Up Fee',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _locationController,
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
                  hintText: 'Location',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                SearchDropdown(
                  hintText: 'Public or Private Institute',
                  items: ['Public', 'Private'],
                  value: '',
                  onChanged: (String? value) {},
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _aboutController,
                  focusNode: _focusNode7,
                  nextFocusNode: _focusNode8,
                  hintText: 'About',
                  icon: '',
                  maxlines: true,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: 'Save',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  isHospitalForm: true,
                                  buttonColor: Color(0xff1C2A3A),
                                  showButton: true,
                                  title: 'Congratulations!',
                                  content:
                                      'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                );
                              },
                            );
                          },
                          backgroundColor: Color(0xff1C2A3A),
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
      ),
    );
  }
}
