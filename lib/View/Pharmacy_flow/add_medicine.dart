import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/view/auth/utils/auth_utils.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Product',
        icon: Icons.arrow_back_sharp,
        onPressed: () {},
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      Center(
                        child: SvgPicture.asset(
                            'Assets/images/profile-circle.svg'),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 105,
                        child:
                            SvgPicture.asset('Assets/images/message-edit.svg'),
                      ),
                    ],
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      } else {
                        return null;
                      }
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      } else {
                        return null;
                      }
                    },
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
                    controller: _dosageController,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    hintText: 'Dosage',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dosage';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _stockController,
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    hintText: 'Stock',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      controller: _priceController,
                      focusNode: _focusNode6,
                      nextFocusNode: _focusNode7,
                      hintText: 'Price',
                      icon: '',
                      validator: validateCurrencyAmount),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                            text: 'Save',
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              if (!_formKey.currentState!.validate()) {}
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
      ),
    );
  }
}
