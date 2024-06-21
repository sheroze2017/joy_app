import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../modules/auth/utils/auth_utils.dart';

class PharmacyFormScreen extends StatefulWidget {
  PharmacyFormScreen({super.key});

  @override
  State<PharmacyFormScreen> createState() => _PharmacyFormScreenState();
}

class _PharmacyFormScreenState extends State<PharmacyFormScreen> {
  String? selectedValue;
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
    //List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Your Pharmacy',
        icon: Icons.arrow_back_sharp,
        onPressed: () {},
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                        child: SvgPicture.asset(
                            'Assets/images/profile-circle.svg'),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 90,
                        child:
                            SvgPicture.asset('Assets/images/message-edit.svg'),
                      ),
                    ],
                  ),
                  RoundedBorderTextField(
                    controller: _nameController,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'Pharmacy Name',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter pharmacy name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _contactController,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    hintText: 'Contact',
                    icon: '',
                    validator: validatePhoneNumber,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      } else {
                        return null;
                      }
                    },
                    controller: _locationController,
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    hintText: 'Location',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultiTimeSelector(
                            times: [
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
                            ],
                            onConfirm: (List<String> selectedTimes) {
                              _availabilityController
                                  .setText(selectedTimes.join(' '));
                            },
                          );
                        },
                      );
                    },
                    child: RoundedBorderTextField(
                      focusNode: _focusNode4,
                      nextFocusNode: _focusNode5,
                      isenable: false,
                      controller: _availabilityController,
                      hintText: 'Availability',
                      icon: '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter availability';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _prescriptionController,
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    hintText: 'Attach File of Prescription',
                    icon: 'Assets/icons/attach-icon.svg',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please attach file prescription';
                      } else {
                        return null;
                      }
                    },
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
                              FocusScope.of(context).unfocus();

                              if (!_formKey.currentState!.validate()) {
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      isPharmacyForm: true,
                                      buttonColor: Color(0xff1C2A3A),
                                      showButton: true,
                                      title: 'Congratulations!',
                                      content:
                                          'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                    );
                                  },
                                );
                              }
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC5D3E3)
                                : Color(0xff1C2A3A),
                            textColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xff121212)
                                : Color(0xffFFFFFF)),
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
      ),
    );
  }
}
