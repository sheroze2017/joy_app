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

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

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
                  controller: TextEditingController(),
                  hintText: 'Patient Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Age',
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
                Text('Main Complain',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor3D4)),
                SizedBox(
                  height: 1.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
                  hintText:
                      'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
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
                  hintText: 'May 22,2024 - 10:00 AM to 10:30 AM',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
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
