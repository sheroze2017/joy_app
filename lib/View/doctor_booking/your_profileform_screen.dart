import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/doctor_booking/book_appointment_screen.dart';
import 'package:sizer/sizer.dart';

class ProfileFormScreen extends StatefulWidget {
  ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<ProfileFormScreen> {
  String? selectedValue;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _complainController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Fill Your Profile',
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[
                    Center(
                      child: Image.asset('Assets/images/profile.png'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  controller: _nameController,
                  hintText: 'Patient Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  controller: _ageController,
                  hintText: 'Age',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode3,
                  nextFocusNode: _focusNode4,
                  controller: _genderController,
                  hintText: 'Gender',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text('Main Complain',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor3D4)),
                SizedBox(
                  height: 1.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  controller: _complainController,
                  hintText: 'Depression, Anxiety',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text('Symptoms',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor3D4)),
                SizedBox(
                  height: 1.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
                  controller: _symptomsController,
                  hintText:
                      'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode6,
                  nextFocusNode: _focusNode7,
                  controller: _locationController,
                  hintText: 'Location',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode7,
                  nextFocusNode: _focusNode8,
                  controller: _timeController,
                  hintText: 'May 22,2024 - 10:00 AM to 10:30 AM',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode8,
                  nextFocusNode: _focusNode9,
                  controller: _medicalCertificateController,
                  hintText: 'Upload Medical Certificate',
                  icon: 'Assets/icons/attach-icon.svg',
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: new Stack(
        alignment: new FractionalOffset(.5, 1.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButton(
                      text: "Next",
                      onPressed: () {
                        Get.to(BookAppointmentScreen());
                      },
                      backgroundColor: AppColors.darkBlueColor,
                      textColor: AppColors.whiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
