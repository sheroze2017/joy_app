import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/auth/profileform_screen.dart';
import 'package:joy_app/widgets/single_select_dropdown.dart';
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

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: 'May 22,2024 - 10:00 AM to 10:30 AM');

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  controller: _nameController,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
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
                SearchSingleDropdown(
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
                  controller: _locationController,
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  hintText: 'Location',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _dobController,
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
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
                          backgroundColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xffC5D3E3)
                              : Color(0xff1C2A3A),
                          textColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.blackColor
                              : Color(0xffFFFFFF)),
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
