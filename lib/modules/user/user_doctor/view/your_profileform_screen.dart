import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/modules/user/user_doctor/view/book_appointment_screen.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../../doctor/models/doctor_detail_model.dart';

class ProfileFormScreen extends StatefulWidget {
  DoctorDetail doctorDetail;

  ProfileFormScreen({super.key, required this.doctorDetail});

  @override
  State<ProfileFormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<ProfileFormScreen> {
  String? selectedValue;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _complainController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  var selectedFilePath = [];
  ProfileController _pfc = Get.find<ProfileController>();
  FriendsSocialController _friendsController = Get.find<FriendsSocialController>();
  final MediaPostController _mediaController = Get.find<MediaPostController>();
  
  String? userImage;
  String? userGender;
  String? userDob;
  bool isLoadingProfile = true;
  String? certificateUrl; // Store uploaded certificate URL
  final TextEditingController _certificateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      UserHive? currentUser = await getCurrentUser();
      if (currentUser != null) {
        // Load profile data from API
        await _friendsController.getSearchUserProfileData(false, '', context);
        
        // Set name from profile controller
        _nameController.setText(_pfc.firstName.value);
        _locationController.setText(_pfc.location.toString());
        
        // Get data from controller
        if (_friendsController.userProfileData.value != null) {
          final profileData = _friendsController.userProfileData.value!;
          userImage = profileData.image;
          userGender = profileData.gender;
          userDob = profileData.dob;
          
          // Calculate age from dob if available
          if (userDob != null && userDob!.isNotEmpty) {
            try {
              final age = _calculateAge(userDob);
              if (age > 0) {
                _ageController.setText(age.toString());
              }
            } catch (e) {
              // If parsing fails, leave empty
            }
          }
          
          // Set gender if available (convert to proper format: MALE/FEMALE -> Male/Female)
          if (userGender != null && userGender!.isNotEmpty) {
            String genderDisplay = userGender!;
            if (genderDisplay.toUpperCase() == 'MALE') {
              genderDisplay = 'Male';
            } else if (genderDisplay.toUpperCase() == 'FEMALE') {
              genderDisplay = 'Female';
            }
            _genderController.text = genderDisplay;
          }
        }
        
        // Set image fallback
        if (userImage == null || userImage!.isEmpty) {
          userImage = _pfc.image.value;
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  int _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return 0;
    try {
      final dobDate = DateFormat('yyyy-MM-dd').parse(dob);
      return DateTime.now().difference(dobDate).inDays ~/ 365;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildUserAvatar(String? url, double size, BuildContext context) {
    final isValidUrl = url != null &&
        url.trim().isNotEmpty &&
        url.trim().toLowerCase() != 'null' &&
        url.contains('http') &&
        !url.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    if (isValidUrl) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url.trim(),
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
            ),
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Fill Your Details',
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 43.w,
                      height: 43.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: _buildUserAvatar(
                        userImage ?? _pfc.image.value,
                        43.w,
                        context,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  RoundedBorderTextField(
                    validator: validateName,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _nameController,
                    hintText: 'Patient Name',
                    icon: '',
                    isenable: false, // Make read-only
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    textInputType: TextInputType.number,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _ageController,
                    hintText: 'Age',
                    icon: '',
                    isenable: false, // Make read-only
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    controller: _genderController,
                    hintText: 'Gender',
                    icon: '',
                    isenable: false, // Make read-only
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your gender';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text('Main Complain',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  RoundedBorderTextField(
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    controller: _complainController,
                    hintText: 'Depression, Anxiety',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your complains';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text('Symptoms',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  RoundedBorderTextField(
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    controller: _symptomsController,
                    hintText:
                        'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your symptoms';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    focusNode: _focusNode6,
                    nextFocusNode: _focusNode7,
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
                  SizedBox(
                    height: 2.h,
                  ),
                  // Certificate upload section
                  Text('Medical Certificate (Optional)',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        // Allow both images and PDFs for certificates
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                          allowMultiple: false,
                        );
                        
                        if (result != null && result.files.single.path != null) {
                          final filePath = result.files.single.path!;
                          print('📄 [ProfileForm] Certificate file selected: $filePath');
                          
                          // Show loading
                          setState(() {
                            _mediaController.imgUploaded.value = true;
                          });
                          
                          // Upload certificate (without user_id parameter)
                          final uploadedUrl = await _mediaController.mediaPosts.uploadImageFile(filePath);
                          
                          if (uploadedUrl.isNotEmpty) {
                            setState(() {
                              certificateUrl = uploadedUrl;
                              _certificateController.text = 'Certificate uploaded';
                            });
                            showSuccessMessage(context, 'Certificate uploaded successfully');
                            print('✅ [ProfileForm] Certificate uploaded: $uploadedUrl');
                          } else {
                            showErrorMessage(context, 'Error uploading certificate');
                            setState(() {
                              _certificateController.text = '';
                            });
                          }
                        }
                      } catch (e) {
                        print('❌ [ProfileForm] Error uploading certificate: $e');
                        showErrorMessage(context, 'Error uploading certificate');
                        setState(() {
                          _certificateController.text = '';
                          _mediaController.imgUploaded.value = false;
                        });
                      } finally {
                        setState(() {
                          _mediaController.imgUploaded.value = false;
                        });
                      }
                    },
                    child: Obx(
                      () => RoundedBorderTextField(
                        showLoader: _mediaController.imgUploaded.value,
                        isenable: false,
                        controller: _certificateController,
                        focusNode: _focusNode7,
                        nextFocusNode: null,
                        validator: (value) {
                          // Certificate is optional, no validation needed
                          return null;
                        },
                        hintText: certificateUrl != null && certificateUrl!.isNotEmpty
                            ? 'Certificate uploaded'
                            : 'Add Medical Certificate',
                        icon: 'Assets/icons/attach-icon.svg',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 24.0, top: 8.0, left: 16.0, right: 16.0),
        child: RoundedButton(
          text: "Next",
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (!_formKey.currentState!.validate()) {
            } else {
              if (_genderController.text.isEmpty) {
                showErrorMessage(context, 'please select gender');
              } else {
                Get.to(
                    BookAppointmentScreen(
                      age: _ageController.text,
                      doctorDetail: widget.doctorDetail,
                      complain: _complainController.text,
                      certificateUrl: certificateUrl ?? '', // Pass uploaded certificate URL
                      gender: _genderController.text,
                      location: _locationController.text,
                      patientName: _nameController.text,
                      symptoms: _symptomsController.text,
                    ),
                    transition: Transition.native);
              }
            }
          },
          backgroundColor: AppColors.darkBlueColor,
          textColor: AppColors.whiteColor),
      ),
    );
  }
}
