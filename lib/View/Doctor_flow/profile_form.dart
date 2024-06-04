import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/view/auth/profileform_screen.dart';
import 'package:sizer/sizer.dart';

class DoctorFormScreen extends StatefulWidget {
  DoctorFormScreen({super.key});

  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  String? selectedValue;
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: 'May 22,2024 - 10:00 AM to 10:30 AM');

  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();

  final TextEditingController _medicalCertificateController =
      TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();
  final FocusNode _focusNode10 = FocusNode();
  final FocusNode _focusNode11 = FocusNode();

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Fill Your Profile',
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
                    Center(
                      child:
                          SvgPicture.asset('Assets/images/profile-circle.svg'),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 90,
                      child: SvgPicture.asset('Assets/images/message-edit.svg'),
                    ),
                  ],
                ),
                RoundedBorderTextField(
                  controller: _fnameController,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  hintText: 'First Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _lnameController,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  hintText: 'Last Name',
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
                  controller: _expertiseController,
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  hintText: 'Expertise',
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
                RoundedBorderTextField(
                  controller: _feesController,
                  focusNode: _focusNode6,
                  nextFocusNode: _focusNode7,
                  hintText: 'Consultation Fee',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _qualificationController,
                  focusNode: _focusNode7,
                  nextFocusNode: _focusNode8,
                  hintText: 'Qualification',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _medicalCertificateController,
                  focusNode: _focusNode8,
                  nextFocusNode: _focusNode9,
                  hintText: 'Attach File of Medical Certificate',
                  icon: 'Assets/icons/attach-icon.svg',
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
                    isenable: false,
                    controller: _timeController,
                    focusNode: _focusNode9,
                    nextFocusNode: _focusNode10,
                    hintText: 'Select timings',
                    icon: 'Assets/images/calendar.svg',
                  ),
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
                                  isDoctorForm: true,
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
