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
import '../../../../auth/utils/auth_hive_utils.dart';
import '../../../../../core/network/request.dart';
import '../../../../../core/constants/endpoints.dart';
import '../../../../../styles/custom_textstyle.dart';

class PharmacyFormScreen extends StatefulWidget {
  final String email;
  final String password;
  bool isSocial;
  final String name;
  final String? userRole; // PHARMACY role for signup (optional for edit flows)
  bool isEdit;
  PharmacyFormScreen(
      {required this.email,
      required this.password,
      this.isSocial = false,
      required this.name,
      this.userRole,
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
  final TextEditingController _passwordController = TextEditingController();
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
  
  // Store original values for comparison
  String? _originalName;
  String? _originalPhone;
  String? _originalLocation;
  String? _originalPassword;
  String? _originalImage;
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

  // Fetch pharmacy profile and load data
  Future<void> _loadPharmacyProfile() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) return;
      
      // Call getProfile API to get full pharmacy details
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
        } else if (data['location'] != null) {
          _locationController.text = data['location'].toString();
          _originalLocation = _locationController.text;
        }
        
        // Load availability from details.timings
        if (details != null && details['timings'] != null) {
          final timings = details['timings'] as List<dynamic>?;
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
      }
    } catch (e) {
      print('Error loading pharmacy profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      // Load existing values from ProfileController
      _selectedImage = _profileController.image.value;
      _originalImage = _selectedImage;
      
      _nameController.text = _profileController.firstName.toString();
      _originalName = _nameController.text;
      
      _contactController.text = _profileController.phone.toString();
      _originalPhone = _contactController.text;
      
      // Start with basic location from ProfileController, will be updated by _loadPharmacyProfile
      _locationController.text = _profileController.location.value.toString();
      _originalLocation = _locationController.text;
      
      // Load password from widget.password
      _passwordController.text = widget.password;
      _originalPassword = widget.password == 'null' ? null : widget.password;
      
      // Initialize availability as empty, will be loaded by _loadPharmacyProfile
      _originalAvailability = [];
      dateAvailability = [];
      
      // Fetch full pharmacy profile to get details.location and details.timings
      _loadPharmacyProfile();
    }
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
                    showLabel: true,
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
                    showLabel: true,
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
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _focusNode5,
                    obscureText: true,
                    enableInteractiveSelection: true,
                    readOnly: false,
                    style: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
                    cursorColor: const Color(0xffD1D5DB),
                    decoration: InputDecoration(
                      label: Text('Password'),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      hintText: 'Password',
                      hintStyle: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffD1D5DB)),
                      ),
                    ),
                    validator: (value) {
                      // Password is optional in edit mode
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _focusNode5.unfocus();
                      FocusScope.of(context).requestFocus(_focusNode6);
                    },
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
                          focusNode: _focusNode6,
                          nextFocusNode: _focusNode7,
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
                                // Convert availability to API format
                                List<Map<String, dynamic>> availability = [];
                                if (dateAvailability.isNotEmpty) {
                                  final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
                                  for (int i = 0; i < daysOfWeek.length; i++) {
                                    if (dateAvailability[i].isNotEmpty) {
                                      availability.add({
                                        "day": daysOfWeek[i],
                                        "times": dateAvailability[i].toList()
                                      });
                                    }
                                  }
                                }
                                
                                // Create original values map for comparison
                                Map<String, dynamic> originalValues = {
                                  'name': _originalName ?? '',
                                  'phone': _originalPhone ?? '',
                                  'location': _originalLocation ?? '',
                                  'password': _originalPassword ?? '',
                                  'image': _originalImage ?? '',
                                };
                                
                                bool result = widget.isEdit
                                    ? await authController.editPharmacy(
                                        _nameController.text,
                                        _profileController.email.value.toString(),
                                        _passwordController.text,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        "EMAIL",
                                        "PHARMACY",
                                        latitude.toString(),
                                        longitude.toString(),
                                        "ASDA21321312312",
                                        context,
                                        _selectedImage.toString(),
                                        availability: availability,
                                        originalValues: originalValues)
                                    : await authController.PharmacyRegister(
                                        _nameController.text,
                                        widget.email,
                                        widget.password,
                                        _locationController.text,
                                        "",
                                        _contactController.text,
                                        widget.isSocial ? 'SOCIAL' : "EMAIL",
                                        widget.userRole ?? 'PHARMACY',
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
