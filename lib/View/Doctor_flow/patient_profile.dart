import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class PatientProfileScreen extends StatefulWidget {
  PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<PatientProfileScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: HomeAppBar(
        title: "Patient's Profile",
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
                  controller: TextEditingController(text: 'James'),
                  hintText: 'James',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(text: 'Robinson'),
                  hintText: 'Robinson',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(text: 'Female'),
                  hintText: 'Female',
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
                  controller:
                      TextEditingController(text: 'Depression, Anxiety'),
                  hintText: 'Depression, Anxiety',
                  maxlines: true,
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
                  controller: TextEditingController(
                    text:
                        'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                  ),
                  maxlines: true,
                  hintText:
                      'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(text: '25 years old'),
                  hintText: 'Age',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(text: 'USA'),
                  hintText: 'USA',
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
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(text: '20\$ Paid'),
                  hintText: '',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(
                      text: 'May 22,2024 - 10:00 AM to 10:30 AM'),
                  hintText: 'May 22,2024 - 10:00 AM to 10:30 AM',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Medical Certificate - PDF',
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
    );
  }
}
