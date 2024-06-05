import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/view/auth/utils/auth_utils.dart';
import 'package:joy_app/widgets/single_select_dropdown.dart';
import 'package:sizer/sizer.dart';

class FormScreen extends StatefulWidget {
  FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  TextEditingController controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Fill Your Profile',
        icon: Icons.arrow_back_sharp,
        onPressed: () {},
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xffFFFFFF),
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
                        right: 100,
                        child:
                            SvgPicture.asset('Assets/images/message-edit.svg'),
                      ),
                    ],
                  ),
                  RoundedBorderTextField(
                    validator: validateName,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _nameController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    controller: _locationController,
                    hintText: 'Location',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your DOB';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    controller: _dobController,
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
                            text: 'Save',
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      isUser: true,
                                      showButton: true,
                                      title: 'Congratulations!',
                                      content:
                                          'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                    );
                                  },
                                );
                              }
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
      ),
    );
  }
}
