import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/dropdown_button.dart';
import 'package:joy_app/Widgets/multi_time_selector.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../../Widgets/appbar.dart';
import '../../auth/bloc/auth_bloc.dart';

class HospitalFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  bool isSocial;
  bool isEdit;

  HospitalFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.isSocial = false,
      this.isEdit = false,
      super.key});
  @override
  State<HospitalFormScreen> createState() => _HospitalFormScreenState();
}

class _HospitalFormScreenState extends State<HospitalFormScreen> {
  String? selectedValue;

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instituteController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final authController = Get.find<AuthController>();
  final _hospitalDetailController = Get.find<HospitalDetailController>();

  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;
  final mediaController = Get.find<MediaPostController>();
  ProfileController _profileController = Get.put(ProfileController());

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
      _feesController.setText(
          _hospitalDetailController.hospitald.value!.checkupFee.toString());
      _locationController.setText(
          _hospitalDetailController.hospitald.value!.location.toString());
      latitude = double.parse(
              _hospitalDetailController.hospitald.value!.lat.toString()) ??
          0.0;
      longitude = double.parse(
              _hospitalDetailController.hospitald.value!.lng.toString()) ??
          0.0;
      _aboutController
          .setText(_hospitalDetailController.hospitald.value!.about.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Hospital' : 'Add Your Hospital',
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
                        return 'Please enter hospital name';
                      } else {
                        return null;
                      }
                    },
                    controller: _nameController,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'Hospital Name',
                    icon: '',
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
                      validator: validatePhoneNumber),
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
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
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
                    controller: _feesController,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    hintText: 'Check Up Fee',
                    icon: '',
                    validator: validateCurrencyAmount,
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
                          latitude = value['latitude'];
                          longitude = value['longitude'];
                          _locationController.setText(value['searchValue']);
                        }
                      });
                    },
                    child: RoundedBorderTextField(
                      isenable: false,
                      controller: _locationController,
                      focusNode: _focusNode5,
                      nextFocusNode: _focusNode6,
                      hintText: 'Location',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        } else {
                          return null;
                        }
                      },
                      icon: '',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SearchDropdown(
                    hintText: 'Public or Private Institute',
                    items: ['Public', 'Private'],
                    value: '',
                    onChanged: (String? value) {
                      _instituteController.text = value.toString();
                    },
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _aboutController,
                    focusNode: _focusNode7,
                    nextFocusNode: _focusNode8,
                    hintText: 'About',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your about';
                      } else {
                        return null;
                      }
                    },
                    maxlines: true,
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
                                  List result = widget.isEdit
                                      ? await authController.editHospital(
                                          _nameController.text,
                                          _profileController.email.value
                                              .toString(),
                                          _profileController.password.value
                                              .toString(),
                                          _locationController.text,
                                          "",
                                          _contactController.text,
                                          "AD1234",
                                          latitude.toString(),
                                          longitude.toString(),
                                          _feesController.text,
                                          _aboutController.text,
                                          _instituteController.text,
                                          context,
                                          _selectedImage.toString())
                                      : await authController.HospitalRegister(
                                          _nameController.text,
                                          widget.email,
                                          widget.password,
                                          _locationController.text,
                                          "",
                                          _contactController.text,
                                          widget.isSocial ? 'SOCIAL' : "EMAIL",
                                          'HOSPITAL',
                                          latitude.toString(),
                                          longitude.toString(),
                                          "AD1234",
                                          _instituteController.text,
                                          _aboutController.text,
                                          _feesController.text,
                                          context,
                                          _selectedImage.toString());
                                  if (result[0] == true) {
                                    widget.isEdit
                                        ? {_profileController.updateUserDetal()}
                                        : showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialog(
                                                hospitalDetailId:
                                                    result[1].toString(),
                                                isHospitalForm: true,
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
