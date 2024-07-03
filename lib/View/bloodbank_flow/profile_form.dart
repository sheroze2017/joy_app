import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/common/utils/file_selector.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../modules/auth/bloc/auth_bloc.dart';
import '../../modules/auth/utils/auth_utils.dart';

class BloodBankFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;

  BloodBankFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      super.key});
  @override
  State<BloodBankFormScreen> createState() => _BloodBankFormScreenState();
}

class _BloodBankFormScreenState extends State<BloodBankFormScreen> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();

  final authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;

  final mediaController = Get.find<MediaPostController>();

  Future<void> _pickImage() async {
    final List<String?> paths = await pickSingleFile();
    if (paths.isNotEmpty) {
      final String path = await paths.first!;
      String profileImg =
          await mediaController.uploadProfilePhoto(path, context);
      setState(() {
        _selectedImage = profileImg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Blood Bank',
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
                  Obx(
                    () => mediaController.profileUpload.value
                        ? Container(
                            height: 43.w,
                            width: 43.w,
                            child: Lottie.asset(
                                'Assets/animations/image_upload.json'),
                          )
                        : Stack(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: _selectedImage == null ||
                                          !_selectedImage!.contains('http')
                                      ? Center(
                                          child: SvgPicture.asset(
                                              'Assets/images/profile-circle.svg'),
                                        )
                                      : Center(
                                          child: Container(
                                            width: 43.w,
                                            height: 43.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape
                                                  .circle, // Add this line
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1), // Optional
                                            ),
                                            child: Center(
                                              child: Container(
                                                child: ClipOval(
                                                  // Add this widget
                                                  child: Image.network(
                                                    fit: BoxFit.cover,
                                                    _selectedImage!,
                                                    width: 41.w,
                                                    height: 41.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                              Positioned(
                                bottom: 20,
                                right: 100,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: ThemeUtil.isDarkMode(context)
                                            ? AppColors.lightBlueColor3e3
                                            : Color(0xff1C2A3A),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        'Assets/icons/pen.svg',
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    )),
                              )
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter blood bank name';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _nameController,
                    hintText: 'Blood Bank Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      focusNode: _focusNode2,
                      nextFocusNode: _focusNode3,
                      controller: _contactController,
                      hintText: 'Contact',
                      icon: '',
                      validator: validatePhoneNumber),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    controller: _locationController,
                    hintText: 'Location',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      } else {
                        return null;
                      }
                    },
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
                      focusNode: _focusNode5,
                      nextFocusNode: _focusNode6,
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
                  Row(
                    children: [
                      Expanded(
                          child: Obx(
                        () => RoundedButton(
                            showLoader: authController.registerLoader.value,
                            text: 'Save',
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (!_formKey.currentState!.validate()) {
                              } else {
                                bool result =
                                    await authController.bloodBankRegister(
                                        _nameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        "EMAIL",
                                        "BLOODBANK",
                                        "22",
                                        "22",
                                        "ASDA21321",
                                        context,
                                        _selectedImage.toString());
                                if (result) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        isBloodBankForm: true,
                                        buttonColor: Color(0xff1C2A3A),
                                        showButton: true,
                                        title: 'Congratulations!',
                                        content:
                                            'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC5D3E3)
                                : Color(0xff1C2A3A),
                            textColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xff121212)
                                : Color(0xffFFFFFF)),
                      )),
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
