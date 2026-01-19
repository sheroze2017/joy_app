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
import '../../auth/utils/auth_hive_utils.dart';
import '../../../core/network/request.dart';
import '../../../core/constants/endpoints.dart';

class BloodBankFormScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String? userRole; // BLOODBANK role for signup (optional for edit flows)
  bool isEdit;
  bool isSocial;
  BloodBankFormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.userRole,
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
  
  // Store original values for comparison
  String? _originalName;
  String? _originalPhone;
  String? _originalLocation;
  String? _originalLat;
  String? _originalLng;
  String? _originalImage;
  String? _originalPlaceId;
  List<Map<String, dynamic>>? _originalAvailability;

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

  // Convert timings from API format to availability format
  List<Map<String, dynamic>> _convertTimingsToAvailability(List<dynamic>? timings) {
    if (timings == null || timings.isEmpty) return [];
    
    final List<Map<String, dynamic>> availability = [];
    for (var timing in timings) {
      if (timing is Map<String, dynamic>) {
        final day = timing['day'] as String?;
        final times = timing['times'] as List<dynamic>?;
        if (day != null && times != null && times.isNotEmpty) {
          availability.add({
            "day": day,
            "times": times.map((t) => t.toString()).toList()
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

  // Fetch blood bank profile and load data
  Future<void> _loadBloodBankProfile() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) return;
      
      // Call getProfile API to get full blood bank details
      // This will update Hive, but we also need the raw response to get details.timings
      await authController.fetchAndUpdateUserProfile(currentUser.userId.toString());
      
      // Now get the raw response to access details.timings and details.location
      // We'll use the core network request directly
      final coreNetwork = DioClient.getInstance();
      final rawResponse = await coreNetwork.post(
        Endpoints.getProfile,
        data: {"user_id": currentUser.userId.toString()}
      );
      
      if (rawResponse['code'] == 200 && rawResponse['data'] != null) {
        final data = rawResponse['data'] as Map<String, dynamic>;
        final details = data['details'] as Map<String, dynamic>?;
        
        // Load location from details.location (more detailed) or fallback to root location
        if (details != null && details['location'] != null) {
          _locationController.text = details['location'].toString();
          _originalLocation = _locationController.text;
          
          // Also set lat/lng if available
          if (details['lat'] != null) {
            latitude = double.tryParse(details['lat'].toString()) ?? 0.0;
            _originalLat = details['lat'].toString();
          }
          if (details['lng'] != null) {
            longitude = double.tryParse(details['lng'].toString()) ?? 0.0;
            _originalLng = details['lng'].toString();
          }
          if (details['place_id'] != null) {
            _originalPlaceId = details['place_id'].toString();
          }
        } else if (data['location'] != null) {
          _locationController.text = data['location'].toString();
          _originalLocation = _locationController.text;
        }
        
        // Load availability from details.timings (preferred) or root timings
        List<dynamic>? timings;
        if (details != null && details['timings'] != null) {
          timings = details['timings'] as List<dynamic>?;
        } else if (data['timings'] != null) {
          timings = data['timings'] as List<dynamic>?;
        }
        
        if (timings != null && timings.isNotEmpty) {
          _originalAvailability = _convertTimingsToAvailability(timings);
          dateAvailability = _convertAvailabilityToDialogFormat(_originalAvailability);
          
          // Generate formatted string for display
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
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
              }
            });
          }
        }
      }
    } catch (e) {
      print('Error loading blood bank profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _selectedImage = _profileController.image.value;
      _originalImage = _selectedImage;
      
      _nameController.text = _profileController.firstName.toString();
      _originalName = _nameController.text;
      
      _contactController.text = _profileController.phone.toString();
      _originalPhone = _contactController.text;
      
      // Start with basic location from ProfileController, will be updated by _loadBloodBankProfile
      _locationController.text = _profileController.location.value.toString();
      _originalLocation = _locationController.text;
      
      // Initialize availability as empty, will be loaded by _loadBloodBankProfile
      _originalAvailability = [];
      dateAvailability = [];
      
      // Fetch full blood bank profile to get details.location and details.timings
      _loadBloodBankProfile();
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
                    showLabel: true,
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
                      showLabel: true,
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
                          _locationController.text = value['searchValue'];
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
                              _availabilityController.text = result;
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
                                // Convert availability to API format
                                List<Map<String, dynamic>> availability = [];
                                for (int i = 0; i < dateAvailability.length; i++) {
                                  if (dateAvailability[i].isNotEmpty) {
                                    final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
                                    availability.add({
                                      "day": daysOfWeek[i],
                                      "times": dateAvailability[i].toList()
                                    });
                                  }
                                }
                                
                                // Build original values map for comparison
                                Map<String, dynamic> originalValues = {};
                                if (widget.isEdit) {
                                  originalValues = {
                                    'name': _originalName,
                                    'phone': _originalPhone,
                                    'location': _originalLocation,
                                    'lat': _originalLat,
                                    'lng': _originalLng,
                                    'place_id': _originalPlaceId,
                                    'image': _originalImage,
                                    'availability': _originalAvailability,
                                  };
                                }
                                
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
                                        _selectedImage.toString(),
                                        availability: availability,
                                        originalValues: originalValues)
                                    : await authController.bloodBankRegister(
                                        _nameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        widget.isSocial ? 'SOCIAL' : "EMAIL",
                                        widget.userRole ?? 'BLOODBANK',
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
