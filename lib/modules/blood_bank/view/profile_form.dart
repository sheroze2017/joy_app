import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joy_app/Widgets/appbar/appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/dailog/multi_time_selector.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/dailog/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/doctor/view/profile_form.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:joy_app/widgets/dailog/doctor_availability_dailog.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/utils/auth_utils.dart';

class BloodBankFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  bool isEdit;
  bool isSocial;
  BloodBankFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.isSocial = false,
      this.isEdit = false,
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
  List<Set<String>> dateAvailability = [];

  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;
  ProfileController _profileController = Get.put(ProfileController());
  final mediaController = Get.find<MediaPostController>();
  double latitude = 0;
  double longitude = 0;

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
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _selectedImage = _profileController.image.value;
      _nameController.setText(_profileController.firstName.toString());
      _contactController.setText(_profileController.phone.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Blood Bank' : 'Add Blood Bank',
        icon: Icons.arrow_back_sharp,
        onPressed: () {
          Get.back();
        },
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      ).then((value) {
                        if (value != null) {
                          latitude = value['latitude'];
                          longitude = value['longitude'];
                          _locationController.setText(value['searchValue']);
                        }
                      });
                    },
                    child: RoundedBorderTextField(
                      focusNode: _focusNode3,
                      isenable: false,
                                        showLabel: true,

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
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DoctorAvailDailog(
                            initialSelectedTimes: dateAvailability,
                            onConfirm: (List<Set<String>> selectedTimes) async {
                              dateAvailability = selectedTimes;
                              setState(() {});
                              String result = await generateFormattedString(
                                  selectedTimes, [
                                'Monday',
                                'Tuesday',
                                'Wednesday',
                                'Thursday',
                                'Friday',
                                'Saturday',
                                'Sunday'
                              ]);
                              _availabilityController.setText(result);
                            },
                          );
                        },
                      );
                    },
                    child: RoundedBorderTextField(
                      maxlines: true,
                      focusNode: _focusNode4,
                      nextFocusNode: _focusNode5,
                      isenable: false,
                                        showLabel: true,

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
                            text: widget.isEdit ? 'Edit' : 'Save',
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (!_formKey.currentState!.validate()) {
                              } else {
                                bool result = widget.isEdit
                                    ? await authController.editBloodBank(
                                        _nameController.text,
                                        _profileController.email.value
                                            .toString(),
                                        _profileController.password.value
                                            .toString(),
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        "EMAIL",
                                        "BLOODBANK",
                                        latitude.toString(),
                                        longitude.toString(),
                                        "ASDA21321",
                                        context,
                                        _selectedImage.toString())
                                    : await authController.bloodBankRegister(
                                        _nameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        widget.isSocial ? 'SOCIAL' : "EMAIL",
                                        "BLOODBANK",
                                        latitude.toString(),
                                        longitude.toString(),
                                        "ASDA21321",
                                        context,
                                        _selectedImage.toString());
                                if (result) {
                                  widget.isEdit
                                      ? {_profileController.updateUserDetal()}
                                      : showDialog(
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
