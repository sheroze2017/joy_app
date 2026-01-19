import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/dailog/multi_time_selector.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/dailog/success_dailog.dart';
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
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:joy_app/widgets/dailog/doctor_availability_dailog.dart';
import 'package:joy_app/widgets/textfield/single_select_dropdown.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import 'package:sizer/sizer.dart';

class DoctorFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String? userRole; // DOCTOR role for signup (optional for edit flows)
  DoctorDetailsMap? details;
  bool isSocial;
  bool isEdit;

  DoctorFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.userRole,
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

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final TextEditingController _medicalCertificateController =
  //     TextEditingController();

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

  TextEditingController controller = TextEditingController();
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  // Convert availability to List<Set<String>> for dialog
  List<Set<String>> _convertAvailabilityToDialogFormat(List<Map<String, dynamic>>? availability) {
    final List<Set<String>> result = List.generate(7, (_) => <String>{});
    if (availability == null || availability.isEmpty) return result;
    
    final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (var avail in availability) {
      final day = avail['day'] as String?;
      final times = avail['times'] as List<dynamic>?;
      if (day != null && times != null) {
        final dayIndex = daysOfWeek.indexWhere((d) => d.toLowerCase() == day.toLowerCase());
        if (dayIndex != -1) {
          result[dayIndex] = times.map((t) => t.toString()).toSet();
        }
      }
    }
    return result;
  }
  
  // Helper function to convert availability to API format
  List<Map<String, dynamic>> convertAvailabilityToApiFormat(List<Set<String>> dateAvailability) {
    final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final List<Map<String, dynamic>> availability = [];
    
    for (int i = 0; i < daysOfWeek.length; i++) {
      if (dateAvailability[i].isNotEmpty) {
        availability.add({
          "day": daysOfWeek[i],
          "times": dateAvailability[i].toList()
        });
      }
    }
    return availability;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.details != null) {
      final details = widget.details!;
      
      // Load existing values
      _selectedImage = details.image?.toString() ?? '';
      _originalImage = _selectedImage;
      
      _fnameController.text = details.name?.toString() ?? '';
      _originalName = _fnameController.text;
      
      // Set gender from details.gender (normalize to match dropdown values: "Male" or "Female")
      final genderValue = details.gender?.toString() ?? '';
      // Normalize gender value to match dropdown options
      String normalizedGender = '';
      if (genderValue.toLowerCase().contains('female')) {
        normalizedGender = 'Female';
      } else if (genderValue.toLowerCase().contains('male')) {
        normalizedGender = 'Male';
      }
      _genderController.text = normalizedGender;
      _originalGender = normalizedGender;
      
      _locationController.text = details.location?.toString() ?? '';
      _originalLocation = _locationController.text;
      
      _expertiseController.text = details.expertise?.toString() ?? '';
      _originalExpertise = _expertiseController.text;
      
      _feesController.text = details.consultationFee?.toString() ?? '';
      _originalFees = _feesController.text;
      
      _qualificationController.text = details.qualifications?.toString() ?? '';
      _originalQualification = _qualificationController.text;
      
      _phoneController.text = details.phone?.toString() ?? '';
      _originalPhone = _phoneController.text;
      
      _aboutMeController.text = details.aboutMe?.toString() ?? '';
      _originalAboutMe = _aboutMeController.text;
      
      // Load password - initialize as empty in edit mode so user can type new password
      // Store original password but don't pre-fill the field
      // Handle "null" string case (when password is passed as string "null")
      if (widget.password == 'null' || widget.password.isEmpty) {
        _originalPassword = '';
      } else {
        _originalPassword = widget.password;
      }
      // Ensure password field is empty and editable - dispose and recreate controller if needed
      _passwordController.clear();
      // Force controller to be ready for input
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _passwordController.clear();
        }
      });
      
      // Document might be in a different field or not available
      _originalDocument = '';
      
      // Load availability from details
      if (details.availability != null && details.availability!.isNotEmpty) {
        _originalAvailability = details.availability!.map((avail) {
          // Handle times as String (comma-separated) or List
          List<String> timesList = [];
          if (avail.times != null && avail.times!.isNotEmpty) {
            // Availability model stores times as comma-separated string
            timesList = avail.times!.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
          }
          return {
            'day': avail.day,
            'times': timesList
          };
        }).toList();
        dateAvailability = _convertAvailabilityToDialogFormat(_originalAvailability);
        
        // Generate formatted string for display
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final String formattedString = generateFormattedString(
              dateAvailability, [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ]);
          _availabilityController.text = formattedString;
        });
      }
    }
  }

  var selectedFilePath = [];
  String? _selectedImage;
  
  // Store original values for comparison
  String? _originalName;
  String? _originalGender;
  String? _originalLocation;
  String? _originalExpertise;
  String? _originalFees;
  String? _originalQualification;
  String? _originalPhone;
  String? _originalAboutMe;
  String? _originalImage;
  String? _originalDocument;
  String? _originalPassword;
  List<Map<String, dynamic>>? _originalAvailability;
  bool _availabilityChanged = false;

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
  List<Set<String>> dateAvailability = [];

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
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    showLabel: true,
                    validator: validateName,
                    controller: _fnameController,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    showLabel: true,
                    //validator: validateName,
                    controller: _aboutMeController,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    hintText: 'About Me',
                    icon: '',
                    maxlines: true,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    showLabel: true,
                    controller: _passwordController,
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    hintText: 'Password',
                    icon: '',
                    validator: (value) {
                      if (widget.isEdit && (value == null || value.isEmpty)) {
                        // Password is optional in edit mode
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff6B7280)
                                : Color(0xff4B5563),
                          ),
                        ),
                      ),
                      SearchSingleDropdown(
                        hintText: 'Gender',
                        items: ['Male', 'Female'],
                        value: _genderController.text.isEmpty ? null : _genderController.text,
                        onChanged: (String? value) {
                          if (value != null) {
                            _genderController.text = value;
                          }
                        },
                        icon: '',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    showLabel: true,
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

                          _locationController.text = value['searchValue'];
                        }
                      });
                    },
                    child: RoundedBorderTextField(
                      showLabel: true,
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
                    showLabel: true,
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
                    showLabel: true,
                    controller: _qualificationController,
                    focusNode: _focusNode6,
                    nextFocusNode: _focusNode7,
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
                      showLabel: true,
                      controller: _phoneController,
                      focusNode: _focusNode7,
                      nextFocusNode: _focusNode8,
                      hintText: 'Phone Number',
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
                            mediaController.certificateController.value
                                .setText(filePaths[0].toString());
                          }
                        }).then((value) => mediaController.uploadPhoto(
                            mediaController.certificateController.value.text,
                            context));
                      },
                      child: Obx(
                        () => RoundedBorderTextField(
                          //showLabel: true,
                          showLoader: mediaController.imgUploaded.value,
                          isenable: false,
                          controller:
                              mediaController.certificateController.value,
                          focusNode: _focusNode8,
                          nextFocusNode: _focusNode9,
                          validator: (value) {
                            // Document is optional, no validation needed
                            return null;
                          },
                          hintText: 'Add Medical Certificate',
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
                                mediaController.certificateController.value
                                    .setText(
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
                  widget.details == null
                      ? InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DoctorAvailDailog(
                                  initialSelectedTimes: dateAvailability,
                                  onConfirm:
                                      (List<Set<String>> selectedTimes) async {
                                    dateAvailability = selectedTimes;
                                    _availabilityChanged = true;
                                    setState(() {});
                                    String result = generateFormattedString(
                                        selectedTimes, [
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday',
                                      'Sunday'
                                    ]);
                                    _availabilityController.text = result;
                                  },
                                );
                              },
                            );
                          },
                          child: RoundedBorderTextField(
                            maxlines: true,
                            focusNode: _focusNode9,
                            isenable: false,
                            showLabel: true,
                            controller: _availabilityController,
                            hintText: 'Availability',
                            icon: '',
                            validator: (value) {
                              // Make availability optional in edit mode if it already exists
                              if (widget.isEdit && _originalAvailability != null && _originalAvailability!.isNotEmpty) {
                                return null;
                              }
                              if (value == null || value.isEmpty) {
                                return 'Please enter availability';
                              } else {
                                return null;
                              }
                            },
                          ),
                        )
                      : Container(),
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
                                    // Single-step doctor signup
                                    bool result =
                                        await authController.doctorRegister(
                                            dateAvailability,
                                            _fnameController.text,
                                            _locationController.text,
                                            _phoneController.text,
                                            '',
                                            widget.isSocial
                                                ? 'SOCIAL'
                                                : 'EMAIL',
                                            widget.userRole ?? 'DOCTOR',
                                            widget.email,
                                            widget.password,
                                            _genderController.text,
                                            _expertiseController.text,
                                            _qualificationController.text,
                                            mediaController.imgUrl.value
                                                .toString(),
                                            _feesController.text,
                                            context,
                                            _selectedImage.toString(),
                                            _aboutMeController.text);
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
                                    // Convert availability to API format if changed
                                    List<Map<String, dynamic>>? availabilityToSend;
                                    if (_availabilityChanged || (_originalAvailability == null || _originalAvailability!.isEmpty) && dateAvailability.isNotEmpty) {
                                      availabilityToSend = convertAvailabilityToApiFormat(dateAvailability);
                                    }
                                    
                                    await _doctorUpdateController.updateDoctor(
                                        widget.details!.userId.toString(),
                                        _fnameController.text,
                                        widget.email,
                                        _passwordController.text.isEmpty 
                                            ? _originalPassword ?? widget.password
                                            : _passwordController.text,
                                        _locationController.text,
                                        await getToken().toString(),
                                        _genderController.text,
                                        'DOCTOR',
                                        'EMAIL',
                                        _phoneController.text,
                                        _expertiseController.text,
                                        _feesController.text,
                                        _qualificationController.text,
                                        mediaController
                                            .certificateController.value.text,
                                        _aboutMeController.text,
                                        context,
                                        _selectedImage.toString(),
                                        availability: availabilityToSend,
                                        originalValues: {
                                          'name': _originalName,
                                          'email': widget.email,
                                          'password': _originalPassword ?? widget.password,
                                          'location': _originalLocation,
                                          'gender': _originalGender,
                                          'phone': _originalPhone,
                                          'expertise': _originalExpertise,
                                          'consultation_fee': _originalFees,
                                          'qualifications': _originalQualification,
                                          'document': _originalDocument,
                                          'about_me': _originalAboutMe,
                                          'image': _originalImage,
                                        });
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

String generateFormattedString(
    List<Set<String>> selectedTimesPerDay, List<String> daysOfWeek) {
  String formattedString = '';
  for (int i = 0; i < daysOfWeek.length; i++) {
    formattedString += daysOfWeek[i] + '\n';
    if (selectedTimesPerDay[i].isNotEmpty) {
      formattedString += selectedTimesPerDay[i].join(' ') + '\n\n';
    } else {
      formattedString += '\n';
    }
  }
  return formattedString;
}
