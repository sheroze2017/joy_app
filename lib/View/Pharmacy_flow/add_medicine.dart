import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:sizer/sizer.dart';

class AddMedicine extends StatefulWidget {
  AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Product',
        icon: Icons.arrow_back_sharp,
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Container(
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
                      bottom: 30,
                      right: 105,
                      child: SvgPicture.asset('Assets/images/message-edit.svg'),
                    ),
                  ],
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Product Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  maxlines: true,
                  controller: TextEditingController(),
                  hintText: 'Description',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderDropdown(
                  value: selectedValue,
                  items: dropdownItems,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  hintText: 'Select Category',
                  icon: '', // Path to your icon
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
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Dosage',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Stock',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Price',
                  icon: '',
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
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return CustomDialog(
                            //       showButton: true,
                            //       title: 'Congratulations!',
                            //       content:
                            //           'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                            //     );
                            //   },
                            // );
                          },
                          backgroundColor: AppColors.darkGreenColor,
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
