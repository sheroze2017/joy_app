import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:joy_app/modules/auth/bloc/auth_bloc.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_update_bloc.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_model.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/view/common/utils/file_selector.dart';
import 'package:joy_app/widgets/single_select_dropdown.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import 'package:sizer/sizer.dart';

class DoctorFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  DoctorDetailsMap? details;
  bool isSocial;
  bool isEdit;

  DoctorFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.isSocial = false,
      this.details,
      this.isEdit = false,
      super.key});
  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  String? selectedValue;
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _medicalCertificateController =
      TextEditingController();

  final mediaController = Get.find<MediaPostController>();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();
  final FocusNode _focusNode10 = FocusNode();
  final FocusNode _focusNode11 = FocusNode();

  TextEditingController controller = TextEditingController();
  final authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.isEdit) {
      _selectedImage = widget.details!.image.toString();
      _fnameController.setText(
          widget.details == null ? '' : widget.details!.name.toString());

      _genderController.setText(
          widget.details == null ? '' : widget.details!.gender.toString());
      _locationController.setText(
          widget.details == null ? '' : widget.details!.location.toString());
      _expertiseController.setText(
          widget.details == null ? '' : widget.details!.expertise.toString());
      _feesController.setText(widget.details == null
          ? ''
          : widget.details!.consultationFee.toString());
      _qualificationController
        ..setText(widget.details == null
            ? ''
            : widget.details!.qualifications.toString());
      _phoneController
        ..setText(
            widget.details == null ? '' : widget.details!.phone.toString());
      _selectedImage =
          widget.details == null ? '' : widget.details!.image.toString();
    }
    super.initState();
  }

  var selectedFilePath = [];
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

  updateDotorController _doctorUpdateController =
      Get.put(updateDotorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.details == null ? 'Fill Your Profile' : 'Edit Profile',
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
                    validator: validateName,
                    controller: _fnameController,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'First Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    // validator: validateName,
                    controller: _lnameController,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    hintText: 'Last Name',
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
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expertise';
                      } else {
                        return null;
                      }
                    },
                    controller: _expertiseController,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    hintText: 'Expertise for e.g: Heart Cardio Gastrologist',
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
                      isenable: false,
                      focusNode: _focusNode5,
                      nextFocusNode: _focusNode6,
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
                  RoundedBorderTextField(
                    controller: _feesController,
                    focusNode: _focusNode6,
                    nextFocusNode: _focusNode7,
                    hintText: 'Consultation Fee',
                    validator: validateCurrencyAmount,
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _qualificationController,
                    focusNode: _focusNode7,
                    nextFocusNode: _focusNode8,
                    hintText: 'Qualification',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter qualification';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      controller: _phoneController,
                      focusNode: _focusNode8,
                      nextFocusNode: _focusNode9,
                      hintText: 'Phone No',
                      icon: '',
                      validator: validatePhoneNumber),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                      onTap: () {
                        pickSingleFile().then((filePaths) {
                          if (filePaths.isEmpty) {
                          } else {
                            _medicalCertificateController
                                .setText(filePaths[0].toString());
                          }
                        }).then((value) => mediaController.uploadPhoto(
                            _medicalCertificateController.text, context));
                      },
                      child: Obx(
                        () => RoundedBorderTextField(
                          showLoader: mediaController.imgUploaded.value,
                          isenable: false,
                          controller: _medicalCertificateController,
                          focusNode: _focusNode9,
                          nextFocusNode: _focusNode10,
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Please attach documents';
                            // } else if (mediaController.imgUrl.isEmpty) {
                            //   return 'Please attach files';
                            // } else {
                            //   return null;
                            // }
                          },
                          hintText: 'Attach File of Medical Certificate',
                          icon: 'Assets/icons/attach-icon.svg',
                        ),
                      )),
                  Column(
                    children: selectedFilePath.map((path) {
                      return Row(
                        children: [
                          Image.file(
                            File(path),
                            width: 4.h,
                            height: 4.h,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                              child: Text(
                            getFileName(path),
                            maxLines: 1,
                          )),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedFilePath.remove(path);
                                _medicalCertificateController.setText(
                                    selectedFilePath.length.toString() +
                                        ' file selected');
                              });
                            },
                          ),
                        ],
                      );
                    }).toList(),
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
                              print("Selected times: $selectedTimes");
                            },
                          );
                        },
                      );
                    },
                    child: RoundedBorderTextField(
                      maxlines: true,
                      focusNode: _focusNode10,
                      nextFocusNode: _focusNode11,
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
                              showLoader: widget.details == null
                                  ? authController.registerLoader.value
                                  : _doctorUpdateController.editLoader.value,
                              text: 'Save',
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) {
                                } else {
                                  if (widget.details == null) {
                                    bool result =
                                        await authController.doctorRegister(
                                            widget.name,
                                            _locationController.text,
                                            _phoneController.text,
                                            '',
                                            widget.isSocial
                                                ? 'SOCIAL'
                                                : 'EMAIL',
                                            'DOCTOR',
                                            widget.email,
                                            widget.password,
                                            _genderController.text,
                                            _expertiseController.text,
                                            _qualificationController.text,
                                            mediaController.imgUrl.value
                                                .toString(),
                                            _feesController.text,
                                            context,
                                            _selectedImage.toString());
                                    if (result == true) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialog(
                                            isDoctorForm: true,
                                            buttonColor: Color(0xff1C2A3A),
                                            showButton: true,
                                            title: 'Congratulations!',
                                            content:
                                                'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    await _doctorUpdateController.updateDoctor(
                                        widget.details!.userId.toString(),
                                        _fnameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        await getToken().toString(),
                                        _genderController.text,
                                        'EMAIL',
                                        'DOCTOR',
                                        _phoneController.text,
                                        _expertiseController.text,
                                        _feesController.text,
                                        _qualificationController.text,
                                        _medicalCertificateController.text,
                                        context,
                                        _selectedImage.toString());
                                    final _doctorController =
                                        Get.find<DoctorController>();
                                    _doctorController.getDoctorDetail();
                                  }
                                }
                              },
                              backgroundColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0xffC5D3E3)
                                  : Color(0xff1C2A3A),
                              textColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0xff121212)
                                  : Color(0xffFFFFFF)),
                        ),
                      )
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
