import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/dailog/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/auth/components/calendar_dob.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:joy_app/widgets/textfield/single_select_dropdown.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../bloc/auth_bloc.dart';

class FormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  bool isSocial;
  bool isEdit;

  FormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.isSocial = false,
      this.isEdit = false,
      super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _profileImgController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  TextEditingController controller = TextEditingController();
  final authController = Get.put(AuthController());

  final mediaController = Get.find<MediaPostController>();

  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;

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

  ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _selectedImage = _profileController.image.value;
      _nameController.setText(_profileController.firstName.toString());
      _phoneController.setText(_profileController.phone.toString());
    } else {
      _nameController.setText(widget.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Profile' : 'Fill Your Profile',
        icon: Icons.arrow_back_sharp,
        onPressed: () {
          Get.back();
        },
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
                    validator: validateName,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _nameController,
                    hintText: 'Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter disease';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _diseaseController,
                    hintText: 'Disease',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter about me';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    controller: _aboutMeController,
                    hintText: 'About Me',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SearchSingleDropdown(
                    hintText: 'Gender',
                    items: ['Male', 'Female'],
                    value: '',
                    onChanged: (String? value) {
                      _genderController.text = value.toString();
                    },
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      ).then((value) {
                        if (value != null) {
                          double latitude = value['latitude'];
                          double longitude = value['longitude'];
                          String searchValue = value['searchValue'];

                          _locationController.setText(value['searchValue']);
                        }
                      });
                    },
                    child: RoundedBorderTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        } else {
                          return null;
                        }
                      },
                      isenable: false,
                      focusNode: _focusNode4,
                      nextFocusNode: _focusNode5,
                      controller: _locationController,
                      hintText: 'Location',
                      showLabel: true,
                      icon: '',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () async {
                      String dob = await showDatePickerDialog(context);
                      _dobController.setText(dob);
                    },
                    child: RoundedBorderTextField(
                      isenable: false,
                      showLabel: true,
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
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      validator: validatePhoneNumber,
                      textInputType: TextInputType.number,
                      focusNode: _focusNode6,
                      nextFocusNode: _focusNode7,
                      controller: _phoneController,
                      hintText: 'Phone No',
                      icon: ''),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Obx(
                        () => RoundedButton(
                            showLoader: authController.registerLoader.value,
                            text: widget.isEdit ? 'Edit' : 'Save',
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                              } else {
                                bool success = widget.isEdit
                                    ? await authController.editUser(
                                        _nameController.text,
                                        _locationController.text,
                                        _phoneController.text,
                                        "",
                                        'EMAIL',
                                        "USER",
                                        _profileController.email.value
                                            .toString(),
                                        _profileController.password.value
                                            .toString(),
                                        _dobController.text,
                                        _genderController.text,
                                        context,
                                        _selectedImage.toString())
                                    : await authController.userRegister(
                                        _nameController.text,
                                        _locationController.text,
                                        _phoneController.text,
                                        "",
                                        widget.isSocial ? 'SOCIAL' : 'EMAIL',
                                        "USER",
                                        widget.email,
                                        widget.password,
                                        _dobController.text,
                                        _genderController.text,
                                        context,
                                        _selectedImage.toString(),_aboutMeController.text);
                                if (success == true) {
                                  widget.isEdit
                                      ? {_profileController.updateUserDetal()}
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Obx(() => CustomDialog(
                                                  isUser: true,
                                                  showButton: !authController
                                                      .registerLoader.value,
                                                  title: 'Congratulations!',
                                                  content:
                                                      'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                                ));
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
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // widget.isEdit
                  //     ? Row(
                  //         children: [
                  //           Expanded(
                  //             child: RoundedButton(
                  //                 text: 'Change Password',
                  //                 onPressed: () {
                  //                   // showDialog(
                  //                   //   context: context,
                  //                   //   builder: (BuildContext context) {
                  //                   //     return CustomDialog(

                  //                   //       title: 'Congratulations!',
                  //                   //       content:
                  //                   //           'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                  //                   //     );
                  //                   //   },
                  //                   // );
                  //                 },
                  //                 backgroundColor: ThemeUtil.isDarkMode(context)
                  //                     ? Color(0xffC5D3E3)
                  //                     : Color(0xff1C2A3A),
                  //                 textColor: ThemeUtil.isDarkMode(context)
                  //                     ? AppColors.blackColor
                  //                     : Color(0xffFFFFFF)),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                  SizedBox(
                    height: 4.h,
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
