import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/dropdown_button.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/dailog/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:joy_app/widgets/appbar/appbar.dart';
import 'package:joy_app/widgets/dailog/doctor_availability_dailog.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../hospital/model/hospital_detail_model.dart';

// Helper function to format availability string
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

class HospitalFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String? userRole; // HOSPITAL role for signup (optional for edit flows)
  bool isSocial;
  bool isEdit;

  HospitalFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.userRole,
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
  final TextEditingController _passwordController = TextEditingController();

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
  List<Set<String>> dateAvailability = [];

  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;
  final mediaController = Get.find<MediaPostController>();
  ProfileController _profileController = Get.put(ProfileController());

  double latitude = 0;
  double longitude = 0;
  
  // Store original values for comparison
  String? _originalName;
  String? _originalPhone;
  String? _originalLocation;
  String? _originalLat;
  String? _originalLng;
  String? _originalCheckupFee;
  String? _originalAbout;
  String? _originalInstitute;
  String? _originalImage;
  String? _originalPlaceId;
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

  // Convert HospitalTiming to availability format
  List<Map<String, dynamic>> _convertTimingsToAvailability(List<HospitalTiming>? timings) {
    if (timings == null || timings.isEmpty) return [];
    
    final List<Map<String, dynamic>> availability = [];
    for (var timing in timings) {
      if (timing.day != null) {
        // Handle times array format (new API format)
        if (timing.times != null && timing.times!.isNotEmpty) {
          availability.add({
            "day": timing.day,
            "times": timing.times!
          });
        } 
        // Handle open/close format (old format)
        else if (timing.open != null && timing.close != null) {
          availability.add({
            "day": timing.day,
            "times": ["${timing.open}-${timing.close}"]
          });
        }
      }
    }
    return availability;
  }
  
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

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      final hospitalData = _hospitalDetailController.hospitald.value;
      if (hospitalData != null) {
        // Load existing values
        _selectedImage = _profileController.image.value;
        _originalImage = _selectedImage;
        
        _nameController.text = _profileController.firstName.toString();
        _originalName = _nameController.text;
        
        _contactController.text = _profileController.phone.toString();
        _originalPhone = _contactController.text;
        
        _feesController.text = hospitalData.checkupFee?.toString() ?? '';
        _originalCheckupFee = _feesController.text;
        
        _locationController.text = hospitalData.location?.toString() ?? '';
        _originalLocation = _locationController.text;
        
        latitude = double.tryParse(hospitalData.lat?.toString() ?? '') ?? 0.0;
        _originalLat = hospitalData.lat?.toString() ?? '';
        
        longitude = double.tryParse(hospitalData.lng?.toString() ?? '') ?? 0.0;
        _originalLng = hospitalData.lng?.toString() ?? '';
        
        _aboutController.text = hospitalData.about?.toString() ?? '';
        _originalAbout = _aboutController.text;
        
        _instituteController.text = hospitalData.institute?.toString() ?? '';
        _originalInstitute = _instituteController.text;
        
        _originalPlaceId = hospitalData.placeId?.toString() ?? '';
        
        // Load password from ProfileController
        _passwordController.text = widget.password;
        _originalPassword = widget.password;
        
        // Load availability from timings
        if (hospitalData.timings != null && hospitalData.timings!.isNotEmpty) {
          _originalAvailability = _convertTimingsToAvailability(hospitalData.timings);
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
                    showLabel: true,
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
                      showLabel: true,
                      controller: _contactController,
                      focusNode: _focusNode2,
                      nextFocusNode: _focusNode3,
                      hintText: 'Phone Number',
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
                          return DoctorAvailDailog(
                            initialSelectedTimes: dateAvailability,
                            onConfirm: (List<Set<String>> selectedTimes) async {
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
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
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
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    showLabel: true,
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
                              _locationController.text = value['searchValue'];
                        }
                      });
                    },
                    child: RoundedBorderTextField(
                      showLabel: true,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                          'Institute Type',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff6B7280)
                                : Color(0xff4B5563),
                          ),
                        ),
                      ),
                      SearchDropdown(
                        hintText: 'Public or Private Institute',
                        items: ['Public', 'Private'],
                        value: _instituteController.text.isEmpty ? null : _instituteController.text,
                        onChanged: (String? value) {
                          if (value != null) {
                            _instituteController.text = value;
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
                    controller: _aboutController,
                    focusNode: _focusNode7,
                    nextFocusNode: _focusNode8,
                    hintText: 'Description/Details',
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
                  RoundedBorderTextField(
                    showLabel: true,
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
                    focusNode: _focusNode8,
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: '',
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
                                  dynamic result;
                                  
                                  if (widget.isEdit) {
                                    // Convert availability to API format only if changed
                                    List<Map<String, dynamic>>? availabilityToSend;
                                    if (_availabilityChanged || (_originalAvailability == null || _originalAvailability!.isEmpty) && dateAvailability.isNotEmpty) {
                                      // Convert current availability
                                      final currentAvailability = convertAvailabilityToApiFormat(dateAvailability);
                                      if (currentAvailability.isNotEmpty) {
                                        availabilityToSend = currentAvailability;
                                      }
                                    }
                                    
                                    result = await authController.editHospital(
                                        _nameController.text,
                                        _profileController.email.value.toString(),
                                        _passwordController.text.isEmpty 
                                            ? _originalPassword ?? _profileController.password.value.toString()
                                            : _passwordController.text,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        _hospitalDetailController.hospitald.value?.placeId ?? _originalPlaceId ?? "AD1234",
                                        latitude.toString(),
                                        longitude.toString(),
                                        _feesController.text,
                                        _aboutController.text,
                                        _instituteController.text,
                                        context,
                                        _selectedImage.toString(),
                                        availability: availabilityToSend,
                                        originalValues: {
                                          'name': _originalName,
                                          'email': _profileController.email.value.toString(),
                                          'password': _originalPassword ?? _profileController.password.value.toString(),
                                          'phone': _originalPhone,
                                          'location': _originalLocation,
                                          'lat': _originalLat,
                                          'lng': _originalLng,
                                          'checkup_fee': _originalCheckupFee,
                                          'about': _originalAbout,
                                          'institute': _originalInstitute,
                                          'image': _originalImage,
                                          'place_id': _originalPlaceId,
                                        });
                                  } else {
                                    result = await authController.HospitalRegister(
                                        _nameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        widget.isSocial ? 'SOCIAL' : "EMAIL",
                                        widget.userRole ?? 'HOSPITAL',
                                        latitude.toString(),
                                        longitude.toString(),
                                        "AD1234",
                                        _instituteController.text,
                                        _aboutController.text,
                                        _feesController.text,
                                        context,
                                        _selectedImage.toString());
                                  }
                                  if ((result is List && result[0] == true) || (result is bool && result == true)) {
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
