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
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/splash/view/splash_screen.dart';
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
  final String? userRole; // USER role for signup (optional for edit flows)
  bool isSocial;
  bool isEdit;

  FormScreen(
      {required this.email,
      required this.password,
      required this.name,
      this.userRole,
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _profileImgController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  TextEditingController controller = TextEditingController();
  final authController = Get.put(AuthController());

  final mediaController = Get.find<MediaPostController>();

  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;
  
  // Store original values for comparison
  String? _originalName;
  String? _originalEmail;
  String? _originalPassword;
  String? _originalLocation;
  String? _originalPhone;
  String? _originalDob;
  String? _originalGender;
  String? _originalImage;
  String? _originalAboutMe;

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
  FriendsSocialController? _friendsController;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _loadUserProfileData();
    } else {
      _nameController.setText(widget.name);
    }
  }

  Future<void> _loadUserProfileData() async {
    try {
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) return;
      
      // Get basic data from ProfileController and Hive
      _selectedImage = _profileController.image.value;
      _originalImage = _selectedImage;
      
      _nameController.text = _profileController.firstName.toString();
      _originalName = _nameController.text;
      
      _phoneController.text = _profileController.phone.toString();
      _originalPhone = _phoneController.text;
      
      _passwordController.text = _profileController.password.value.toString();
      _originalPassword = _passwordController.text;
      
      _originalEmail = _profileController.email.value.toString();

      // Fetch full profile data using getMyProfile API
      _friendsController = Get.find<FriendsSocialController>();
      final response = await _friendsController!.friendApi.getMyProfile(currentUser.userId.toString());
      
      if (response.singleData != null || (response.data != null && response.data!.isNotEmpty)) {
        final profileData = response.singleData ?? response.data!.first;
        
        // Populate all fields from profile data
        if (profileData.name != null && profileData.name!.isNotEmpty) {
          _nameController.text = profileData.name!;
          _originalName = _nameController.text;
        }
        
        if (profileData.image != null && profileData.image!.isNotEmpty) {
          _selectedImage = profileData.image!;
          _originalImage = _selectedImage;
        }
        
        // Get profile data (location, dob, gender, aboutMe) from nested structure
        if (profileData.location != null && profileData.location!.isNotEmpty) {
          _locationController.text = profileData.location!;
          _originalLocation = _locationController.text;
        }
        
        if (profileData.dob != null && profileData.dob!.isNotEmpty) {
          _dobController.text = profileData.dob!;
          _originalDob = _dobController.text;
        }
        
        if (profileData.gender != null && profileData.gender!.isNotEmpty) {
          // Normalize gender value to match dropdown options
          String normalizedGender = '';
          if (profileData.gender!.toLowerCase().contains('female')) {
            normalizedGender = 'Female';
          } else if (profileData.gender!.toLowerCase().contains('male')) {
            normalizedGender = 'Male';
          }
          _genderController.text = normalizedGender;
          selectedValue = normalizedGender;
          _originalGender = normalizedGender;
        } else if (currentUser.gender != null && currentUser.gender!.isNotEmpty) {
          String normalizedGender = '';
          if (currentUser.gender!.toLowerCase().contains('female')) {
            normalizedGender = 'Female';
          } else if (currentUser.gender!.toLowerCase().contains('male')) {
            normalizedGender = 'Male';
          }
          _genderController.text = normalizedGender;
          selectedValue = normalizedGender;
          _originalGender = normalizedGender;
        }
        
        if (profileData.aboutMe != null && profileData.aboutMe!.isNotEmpty) {
          _aboutMeController.text = profileData.aboutMe!;
          _originalAboutMe = _aboutMeController.text;
        }
      }
    } catch (e) {
      print('Error loading profile data: $e');
      // Fallback to basic data from ProfileController
      if (_selectedImage == null) {
        _selectedImage = _profileController.image.value;
        _originalImage = _selectedImage;
      }
      if (_nameController.text.isEmpty) {
        _nameController.text = _profileController.firstName.toString();
        _originalName = _nameController.text;
      }
      if (_phoneController.text.isEmpty) {
        _phoneController.text = _profileController.phone.toString();
        _originalPhone = _phoneController.text;
      }
      if (_passwordController.text.isEmpty) {
        _passwordController.text = _profileController.password.value.toString();
        _originalPassword = _passwordController.text;
      }
      _originalEmail = _profileController.email.value.toString();
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
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    showLabel: true,
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
                    showLabel: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter about me';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _aboutMeController,
                    hintText: 'About Me',
                    icon: '',
                    maxlines: true,
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
                        value: selectedValue?.isEmpty ?? true ? null : selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                          _genderController.text = value ?? '';
                        },
                        icon: '',
                      ),
                    ],
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        } else {
                          return null;
                        }
                      },
                      isenable: false,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
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
                      _dobController.text = dob;
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
                      focusNode: _focusNode4,
                      nextFocusNode: _focusNode5,
                      controller: _dobController,
                      hintText: 'Date of Birth',
                      icon: 'Assets/images/calendar.svg',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      showLabel: true,
                      validator: validatePhoneNumber,
                      textInputType: TextInputType.number,
                      focusNode: _focusNode5,
                      nextFocusNode: _focusNode6,
                      controller: _phoneController,
                      hintText: 'Phone Number',
                      icon: ''),
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
                    focusNode: _focusNode6,
                    nextFocusNode: _focusNode7,
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
                                        _passwordController.text,
                                        _dobController.text,
                                        _genderController.text,
                                        context,
                                        _selectedImage.toString(),
                                        aboutMe: _aboutMeController.text,
                                        originalValues: {
                                          'name': _originalName,
                                          'email': _originalEmail,
                                          'password': _originalPassword,
                                          'location': _originalLocation,
                                          'phone': _originalPhone,
                                          'date_of_birth': _originalDob,
                                          'gender': _originalGender,
                                          'image': _originalImage,
                                          'about_me': _originalAboutMe,
                                        })
                                    : await authController.userRegister(
                                        _nameController.text,
                                        _locationController.text,
                                        _phoneController.text,
                                        "",
                                        widget.isSocial ? 'SOCIAL' : 'EMAIL',
                                        widget.userRole ?? 'USER',
                                        widget.email,
                                        widget.password,
                                        _dobController.text,
                                        _genderController.text,
                                        context,
                                        _selectedImage.toString(),
                                        _aboutMeController.text);
                                if (success == true) {
                                  if (widget.isEdit) {
                                    // Redirect to splash screen to refresh user object
                                    Get.offAll(() => SplashScreen(), transition: Transition.fade);
                                  } else {
                                    showDialog(
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
