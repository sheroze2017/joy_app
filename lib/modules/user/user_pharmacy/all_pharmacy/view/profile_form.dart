import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/dailog/multi_time_selector.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/dailog/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/modules/doctor/view/profile_form.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:joy_app/widgets/dailog/doctor_availability_dailog.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../../../../common/profile/bloc/profile_bloc.dart';
import '../../../../auth/bloc/auth_bloc.dart';
import '../../../../auth/utils/auth_utils.dart';

class PharmacyFormScreen extends StatefulWidget {
  final String email;
  final String password;
  bool isSocial;
  final String name;
  bool isEdit;
  PharmacyFormScreen(
      {required this.email,
      required this.password,
      this.isSocial = false,
      required this.name,
      this.isEdit = false,
      super.key});
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
  List<Set<String>> dateAvailability = [];

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();
  final mediaController = Get.find<MediaPostController>();
  String? _selectedImage;
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
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    //List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Pharmacy' : 'Add Your Pharmacy',
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
                      showLabel: true,
                      isenable: false,
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
                  InkWell(
                      onTap: () {
                        pickSingleFile().then((filePaths) {
                          if (filePaths.isEmpty) {
                          } else {
                            _prescriptionController
                                .setText(filePaths[0].toString());
                          }
                        }).then((value) => mediaController.uploadPhoto(
                            _prescriptionController.text, context));
                      },
                      child: Obx(
                        () => RoundedBorderTextField(
                          isenable: false,
                          showLabel: true,

                          showLoader: mediaController.imgUploaded.value,
                          controller: _prescriptionController,
                          focusNode: _focusNode5,
                          nextFocusNode: _focusNode6,
                          hintText: 'Attach File of Prescription',
                          icon: 'Assets/icons/attach-icon.svg',
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please attach file prescription';
                          //   } else {
                          //     return null;
                          //   }
                          // },
                        ),
                      )),
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
                                    ? await authController.editPharmacy(
                                        _nameController.text,
                                        _profileController.email.value
                                            .toString(),
                                        _profileController.password.value
                                            .toString(),
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        "EMAIL",
                                        "PHARMACY",
                                        latitude.toString(),
                                        longitude.toString(),
                                        "ASDA21321312312",
                                        context,
                                        _selectedImage.toString())
                                    : await authController.PharmacyRegister(
                                        _nameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        widget.isSocial ? 'SOCIAL' : "EMAIL",
                                        "PHARMACY",
                                        latitude.toString(),
                                        longitude.toString(),
                                        "ASDA21321312312",
                                        context,
                                        _selectedImage.toString());

                                if (result) {
                                  widget.isEdit
                                      ? {_profileController.updateUserDetal()}
                                      : showDialog(
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
