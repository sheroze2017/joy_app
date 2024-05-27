import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:sizer/sizer.dart';

class FormScreen extends StatefulWidget {
  FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Fill Your Profile',
        icon: Icons.arrow_back_sharp,
        onPressed: () {},
      ),
      body: Container(
        color: Color(0xffFFFFFF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset('Assets/images/profile-circle.svg'),
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
                hintText: 'Sheroze Rehman',
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
                hintText: 'Disease',
                icon: '', // Path to your icon
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
                hintText: 'Gender',
                icon: '', // Path to your icon
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                showButton: true,
                                title: 'Congratulations!',
                                content:
                                    'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                              );
                            },
                          );
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
    );
  }
}
