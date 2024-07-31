import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/view/common/utils/file_selector.dart';
import 'package:joy_app/modules/user/user_doctor/view/book_appointment_screen.dart';
import 'package:joy_app/widgets/flutter_toast_message.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../modules/doctor/models/doctor_detail_model.dart';
import '../../widgets/single_select_dropdown.dart';

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
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _medicalCertificateController =
      TextEditingController();

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
  var selectedFilePath = [];
  ProfileController _pfc = Get.find<ProfileController>();
  final mediaController = Get.find<MediaPostController>();
  UserDoctorController _doctorController = Get.find<UserDoctorController>();

  @override
  void initState() {
    super.initState();
    _nameController.setText(_pfc.firstName.value);
    _locationController.setText(_pfc.location.toString());
    
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
                  Obx(
                    () => Center(
                      child: Container(
                        width: 43.w,
                        height: 43.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Add this line
                          border: Border.all(
                              color: Colors.grey, width: 1), // Optional
                        ),
                        child: Center(
                          child: Container(
                            child: ClipOval(
                              // Add this widget
                              child: Image.network(
                                fit: BoxFit.cover,
                                _pfc.image.contains('http')
                                    ? _pfc.image.toString()
                                    : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                width: 41.w,
                                height: 41.w,
                              ),
                            ),
                          ),
                        ),
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
                  // RoundedBorderTextField(
                  //   focusNode: _focusNode7,
                  //   nextFocusNode: _focusNode8,
                  //   controller: _timeController,
                  //   hintText: 'May 22,2024 - 10:00 AM to 10:30 AM',
                  //   icon: '',
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please select your schedule';
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please attach documents';
                          //   } else if (mediaController.imgUrl.isEmpty) {
                          //     return 'Please attach files';
                          //   } else {
                          //     return null;
                          //   }
                          // },
                          hintText: 'Attach File of Medical Certificate',
                          icon: 'Assets/icons/attach-icon.svg',
                        ),
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: new Stack(
        alignment: new FractionalOffset(.5, 1.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButton(
                      text: "Next",
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState!.validate()) {
                        } else {
                          if (_genderController.text.isEmpty) {
                            showErrorMessage(context, 'please select gender');
                          } else {}
                          Get.to(
                              BookAppointmentScreen(
                                age: _ageController.text,
                                doctorDetail: widget.doctorDetail,
                                complain: _complainController.text,
                                certificateUrl: mediaController.imgUrl.value,
                                gender: _genderController.text,
                                location: _locationController.text,
                                patientName: _nameController.text,
                                symptoms: _symptomsController.text,
                              ),
                              transition: Transition.native);
                        }
                      },
                      backgroundColor: AppColors.darkBlueColor,
                      textColor: AppColors.whiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
