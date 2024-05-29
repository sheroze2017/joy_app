import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:sizer/sizer.dart';

class DoctorFormScreen extends StatefulWidget {
  DoctorFormScreen({super.key});

  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

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
                  controller: TextEditingController(),
                  hintText: 'First Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Last Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderDropdown(
                  value: selectedValue,
                  items: ['Male', 'Female'],
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  hintText: 'Gender',
                  icon: '', // Path to your icon
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Expertise',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Location',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Consultation Fee',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Qualification',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
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
                    controller: TextEditingController(),
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
