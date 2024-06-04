import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/auth/profileform_screen.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_textfield.dart';
import '../../Widgets/success_dailog.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Edit Profile',
                  style: CustomTextStyles.darkTextStyle(),
                ),
                Stack(
                  children: <Widget>[
                    Center(
                      child:
                          SvgPicture.asset('Assets/images/profile-circle.svg'),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 90,
                      child: SvgPicture.asset('Assets/images/message-edit.svg'),
                    ),
                  ],
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Sheroze Rehman',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                SearchDropdown(
                  hintText: 'Disease',
                  items: [],
                  value: '',
                  onChanged: (String? value) {},
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
                  controller: TextEditingController(),
                  hintText: 'Location',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Date of Birth',
                  icon: 'Assets/images/calendar.svg',
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: 'Change Password',
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return CustomDialog(

                            //       title: 'Congratulations!',
                            //       content:
                            //           'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                            //     );
                            //   },
                            // );
                          },
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xffFFFFFF)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
