import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/view/auth/profileform_screen.dart';
import 'package:sizer/sizer.dart';

class AddMedicine extends StatefulWidget {
  AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  String? selectedValue;
  final TextEditingController _dobController = TextEditingController();

  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: 'May 22,2024 - 10:00 AM to 10:30 AM');

  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();

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
                  controller: _nameController,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  hintText: 'Product Name',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  maxlines: true,
                  controller: _descController,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  hintText: 'Description',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                SearchDropdown(
                  hintText: 'Select Category',
                  items: [''],
                  value: '',
                  onChanged: (String? value) {},
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _dobController,
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  hintText: 'Date of Birth',
                  icon: 'Assets/images/calendar.svg',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _dosageController,
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
                  hintText: 'Dosage',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _stockController,
                  focusNode: _focusNode6,
                  nextFocusNode: _focusNode7,
                  hintText: 'Stock',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _priceController,
                  focusNode: _focusNode7,
                  nextFocusNode: _focusNode8,
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
