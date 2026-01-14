import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/select_timing_screen.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:joy_app/widgets/textfield/custom_textfield.dart';
import 'package:joy_app/widgets/textfield/single_select_dropdown.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';

class RequestBlood extends StatefulWidget {
  bool isRegister;
  RequestBlood({this.isRegister = false});
  @override
  State<RequestBlood> createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodGroupUnitsController =
      TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  UserBloodBankController _userBloodBankController =
      Get.put(UserBloodBankController());
  FriendsSocialController _friendsController = Get.find<FriendsSocialController>();
  bool _isLoadingProfile = true;
  String? _userGender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Get user name and gender from stored user object
      UserHive? currentUser = await getCurrentUser();
      if (currentUser != null) {
        // Pre-fill name from stored user
        _fnameController.text = currentUser.firstName;
        
        // Get gender from stored user object (from login response)
        if (widget.isRegister && currentUser.gender != null && currentUser.gender!.isNotEmpty) {
          // Use gender from stored user object
          String genderUpper = currentUser.gender!.toUpperCase();
          _genderController.text = genderUpper;
          print('✅ [RequestBlood] Gender loaded from stored user: $genderUpper');
        } else if (widget.isRegister) {
          // Fallback: Try to fetch from profile API if not in stored user
          try {
            await _friendsController.getSearchUserProfileData(false, '', context);
            if (_friendsController.userProfileData.value != null) {
              _userGender = _friendsController.userProfileData.value!.gender;
              if (_userGender != null && _userGender!.isNotEmpty) {
                // Convert to uppercase format (MALE/FEMALE) for the API
                String genderUpper = _userGender!.toUpperCase();
                _genderController.text = genderUpper;
                print('✅ [RequestBlood] Gender loaded from profile API: $genderUpper');
              }
            }
          } catch (e) {
            print('⚠️ [RequestBlood] Could not fetch gender from profile API: $e');
            // Gender will remain empty, user will see validation error if they try to submit
          }
        }
      }
    } catch (e) {
      print('❌ [RequestBlood] Error loading user data: $e');
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: widget.isRegister ? 'Register as Donor' : 'Request Blood',
          leading: Container(),
          actions: [],
          showIcon: false),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: widget.isRegister
                ? Column(
                    children: [
                      RoundedBorderTextField(
                        controller: _fnameController,
                        focusNode: _focusNode1,
                        nextFocusNode: _focusNode2,
                        hintText: 'Enter Name',
                        icon: '',
                        isenable: false, // Make name field non-editable
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RoundedBorderTextField(
                        controller: _bloodGroupController,
                        focusNode: _focusNode2,
                        nextFocusNode: _focusNode3,
                        hintText: 'Blood Group',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter blood group';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RoundedBorderTextField(
                        controller: _locationController,
                        focusNode: _focusNode3,
                        showLabel: true,
                        nextFocusNode: _focusNode4,
                        isenable: true,
                        hintText: 'Location',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      // Gender field - fixed text (not dropdown) for Register as Donor
                      RoundedBorderTextField(
                        controller: _genderController,
                        focusNode: _focusNode4,
                        nextFocusNode: _focusNode5,
                        hintText: 'Gender',
                        icon: '',
                        isenable: false, // Make gender field non-editable
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gender is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RoundedBorderTextField(
                        controller: _cityController,
                        focusNode: _focusNode5,
                        nextFocusNode: _focusNode6,
                        hintText: 'City',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter city';
                          } else {
                            return null;
                          }
                        },
                        icon: '',
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: RoundedButtonSmall(
                                showLoader:
                                    _userBloodBankController.showLoader.value,
                                text: widget.isRegister
                                    ? 'Register'
                                    : 'Request Blood',
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                  } else {
                                    if (_genderController.text.isEmpty) {
                                      showErrorMessage(
                                          context, 'Gender is required');
                                    } else {
                                      // For register donor, type is always "VOLUNTARY"
                                      _userBloodBankController.createDonorUser(
                                          _fnameController.text,
                                          _bloodGroupController.text,
                                          _locationController.text,
                                          _genderController.text,
                                          _cityController.text,
                                          '',
                                          context,
                                          'VOLUNTARY');
                                    }
                                  }
                                },
                                backgroundColor: AppColors.redColor,
                                textColor: Color(0xffFFFFFF),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      RoundedBorderTextField(
                        controller: _nameController,
                        focusNode: _focusNode1,
                        nextFocusNode: _focusNode2,
                        hintText: 'Enter Patient Name',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectTimingScreen()),
                          ).then((selection) {
                            if (selection != null &&
                                selection is DateTimeSelection) {
                              String selectedDate = selection.date;
                              String selectedTime = selection.time;
                              _timeController
                                  .setText(selectedDate + '-' + selectedTime);
                            }
                          });
                        },
                        child: RoundedBorderTextField(
                          isenable: false,
                          showLabel: true,
                          controller: _timeController,
                          focusNode: _focusNode2,
                          nextFocusNode: _focusNode3,
                          hintText: 'When do you need it ? Select Time & Date',
                          icon: '',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select time & date';
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
                        controller: _bloodGroupUnitsController,
                        focusNode: _focusNode3,
                        nextFocusNode: _focusNode4,
                        hintText: 'Enter Units of Blood required',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter units of blood';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RoundedBorderTextField(
                        controller: _bloodGroupController,
                        focusNode: _focusNode4,
                        nextFocusNode: _focusNode5,
                        hintText: 'Enter Blood Group Required',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter blood group';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SearchSingleDropdown(
                        hintText: 'Gender',
                        items: ['MALE', 'FEMALE'],
                        value: '',
                        onChanged: (String? value) {
                          _genderController.setText(value.toString());
                        },
                        icon: '',
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SearchSingleDropdown(
                        hintText: 'Request Type',
                        items: ['Blood', 'Plasma'],
                        value: '',
                        onChanged: (String? value) {
                          _bloodTypeController.setText(value.toString());
                        },
                        icon: '',
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RoundedBorderTextField(
                        controller: _cityController,
                        focusNode: _focusNode6,
                        nextFocusNode: _focusNode7,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter city';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'City',
                        icon: '',
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      RoundedBorderTextField(
                        controller: _locationController,
                        focusNode: _focusNode7,
                        nextFocusNode: _focusNode8,
                        hintText: 'Your Location',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: RoundedButtonSmall(
                                  showLoader:
                                      _userBloodBankController.showLoader.value,
                                  text: 'Request Blood',
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                    } else {
                                      if (_genderController.text.isEmpty) {
                                        showErrorMessage(
                                            context, 'Please select gender');
                                      } else if (_timeController.text.isEmpty) {
                                        showErrorMessage(
                                            context, 'Please select time');
                                      } else if (_bloodTypeController.text.isEmpty) {
                                        showErrorMessage(
                                            context, 'Please select request type');
                                      } else {
                                        String date = _timeController.text
                                            .split('-')[0];
                                        String time = _timeController.text
                                            .split('-')[1];

                                        _userBloodBankController
                                            .createBloodAppeal(
                                                _nameController.text,
                                                date,
                                                time,
                                                _bloodGroupUnitsController.text,
                                                _bloodGroupController.text,
                                                _genderController.text,
                                                _cityController.text,
                                                _locationController.text,
                                                '',
                                                _bloodTypeController.text,
                                                context);
                                      }
                                    }
                                  },
                                  backgroundColor: AppColors.redColor,
                                  textColor: Color(0xffFFFFFF)),
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
    );
  }
}
