import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:sizer/sizer.dart';

class PharmacyFormScreen extends StatefulWidget {
  PharmacyFormScreen({super.key});

  @override
  State<PharmacyFormScreen> createState() => _PharmacyFormScreenState();
}

class _PharmacyFormScreenState extends State<PharmacyFormScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Your Pharmacy',
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
                  hintText: 'Pharmacy Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Contact',
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
                    hintText: 'Availability',
                    icon: '',
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Attach File of Prescription',
                  icon: 'Assets/icons/attach-icon.svg',
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
