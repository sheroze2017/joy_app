import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<OrderDetailScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: HomeAppBar(
        title: "Order's Details",
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(text: 'James'),
                  hintText: 'James',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(text: 'Robinson'),
                  hintText: 'Robinson',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(text: '0300-0000000'),
                  hintText: 'Phone No',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(
                      text: 'Panadol 10 Tablets, 5 Injection '),
                  hintText: 'Products',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text('Location',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor3D4)),
                SizedBox(
                  height: 1.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(
                      text:
                          'e veritatis et quasi architecto beatae vitae dicta sunt explicabo.'),
                  hintText: 'Location',
                  maxlines: true,
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(
                    text: 'City',
                  ),
                  maxlines: true,
                  hintText: 'City',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(
                    text: 'Town',
                  ),
                  maxlines: true,
                  hintText: 'Town',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: TextEditingController(text: '20\$ Bill'),
                  hintText: 'Bill',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
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
