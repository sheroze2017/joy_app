import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/modules/doctor/models/doctor_appointment_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PatientProfileScreen extends StatefulWidget {
  Appointment? details;
  PatientProfileScreen({this.details});
  @override
  State<PatientProfileScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<PatientProfileScreen> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _complainController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: 'May 22,2024 - 10:00 AM to 10:30 AM');

  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();

  final TextEditingController _medicalCertificateController =
      TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();
  final FocusNode _focusNode10 = FocusNode();
  final FocusNode _focusNode11 = FocusNode();

  TextEditingController controller = TextEditingController();

  Widget _buildPatientAvatar(String? imageUrl, BuildContext context) {
    final isValidUrl = imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab') &&
        !imageUrl.contains('194.233.69.219');
    
    if (isValidUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.network(
          imageUrl.trim(),
          width: 33.9.w,
          height: 33.9.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Show default placeholder on error
            return Container(
              width: 33.9.w,
              height: 33.9.w,
              decoration: BoxDecoration(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff2A2A2A)
                    : Color(0xffE5E5E5),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.person,
                size: 20.w,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff5A5A5A)
                    : Color(0xffA5A5A5),
              ),
            );
          },
        ),
      );
    }
    // Show default placeholder when image is null/empty/invalid
    return Container(
      width: 33.9.w,
      height: 33.9.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Icon(
        Icons.person,
        size: 20.w,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.details != null) {
      final name = widget.details!.userDetails?.name?.toString() ?? widget.details!.patientName?.toString() ?? '';
      final nameParts = name.split(' ');
      _fnameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      _lnameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      _symptomsController.text = widget.details!.symptoms?.toString() ?? '';
      _complainController.text = widget.details!.complain?.toString() ?? '';
      _locationController.text = widget.details!.location?.toString() ?? '';
      _timeController.text = '${widget.details!.date ?? ''} - ${widget.details!.time ?? ''}';
      _ageController.text = widget.details!.age?.toString() ?? '';
      _genderController.text = widget.details!.gender?.toString() ?? '';
      _diagnosisController.text = widget.details!.diagnosis?.toString() ?? '';
      _medicationsController.text = widget.details!.medications?.toString() ?? '';
      _feesController.text = ''; // Consultation fee not available in Appointment model
      _medicalCertificateController.text = widget.details!.certificate?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: "Patient's Profile",
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[
                    Center(
                      child: _buildPatientAvatar(
                        widget.details?.userDetails?.image?.toString() ?? '',
                        context,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                if (_fnameController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    isenable: false,
                    showLabel: true,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _fnameController,
                    hintText: '',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_lnameController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    isenable: false,
                    showLabel: true,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _lnameController,
                    hintText: '',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_genderController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    isenable: false,
                    showLabel: true,
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    controller: _genderController,
                    hintText: '',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_complainController.text.isNotEmpty) ...[
                  Text('Main Complain',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  RoundedBorderTextField(
                    isenable: false,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    controller: _complainController,
                    hintText: '',
                    maxlines: true,
                    icon: '',
                  ),
                ],
                SizedBox(
                  height: 2.h,
                ),
                if (_symptomsController.text.isNotEmpty) ...[
                  Text('Symptoms',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  RoundedBorderTextField(
                    isenable: false,
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    controller: _symptomsController,
                    maxlines: true,
                    hintText: '',
                    icon: '',
                  ),
                ],
                SizedBox(
                  height: 2.h,
                ),
                if (_ageController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    showLabel: true,
                    isenable: false,
                    focusNode: _focusNode6,
                    nextFocusNode: _focusNode7,
                    controller: _ageController,
                    hintText: '',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_locationController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    showLabel: true,
                    isenable: false,
                    focusNode: _focusNode7,
                    nextFocusNode: _focusNode8,
                    controller: _locationController,
                    hintText: '',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_feesController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    isenable: false,
                    focusNode: _focusNode8,
                    nextFocusNode: _focusNode9,
                    controller: _feesController,
                    hintText: '',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_timeController.text.isNotEmpty) ...[
                  RoundedBorderTextField(
                    showLabel: true,
                    isenable: false,
                    focusNode: _focusNode9,
                    nextFocusNode: _focusNode10,
                    controller: _timeController,
                    icon: '',
                    hintText: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                if (_medicalCertificateController.text.isNotEmpty) ...[
                  InkWell(
                    onTap: () {
                      _showMedicalCertificateImage(context);
                    },
                    child: RoundedBorderTextField(
                      showLabel: true,
                      isenable: false,
                      focusNode: _focusNode10,
                      nextFocusNode: _focusNode11,
                      controller: _medicalCertificateController,
                      hintText: '',
                      icon: 'Assets/icons/attach-icon.svg',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                // Diagnosis Section
                if (widget.details?.diagnosis != null && widget.details!.diagnosis!.isNotEmpty) ...[
                  Text('Diagnosis',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  RoundedBorderTextField(
                    isenable: false,
                    focusNode: _focusNode11,
                    controller: _diagnosisController,
                    hintText: 'Diagnosis',
                    maxlines: true,
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                // Medications Section
                if (widget.details?.medications != null && widget.details!.medications!.isNotEmpty) ...[
                  Text('Medications Prescribed',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : AppColors.blackColor3D4)),
                  SizedBox(
                    height: 1.h,
                  ),
                  RoundedBorderTextField(
                    isenable: false,
                    controller: _medicationsController,
                    hintText: 'Medications Prescribed',
                    maxlines: true,
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
                // Patient Review Section
                if (widget.details?.review != null) ...[
                  Divider(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff1f2228)
                        : Color(0xffE5E7EB),
                    thickness: 0.3,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Patient Review',
                    style: CustomTextStyles.w600TextStyle(
                        size: 16,
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : AppColors.blackColor151),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: (widget.details!.review!.rating is int
                                ? (widget.details!.review!.rating as int).toDouble()
                                : (widget.details!.review!.rating is double
                                    ? widget.details!.review!.rating as double
                                    : 0.0)),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${widget.details!.review!.rating}',
                        style: CustomTextStyles.w600TextStyle(
                            size: 16, color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : AppColors.blackColor151),
                      ),
                    ],
                  ),
                  if (widget.details!.review!.review != null &&
                      widget.details!.review!.review!.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      widget.details!.review!.review!,
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffDBDBDB)
                              : Color(0xff4B5563),
                          size: 14),
                    ),
                  ],
                  SizedBox(height: 2.h),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMedicalCertificateImage(BuildContext context) {
    final certificateUrl = widget.details?.certificate?.toString() ?? '';
    final isValidUrl = certificateUrl.isNotEmpty &&
        certificateUrl.trim().toLowerCase() != 'null' &&
        certificateUrl.contains('http');
    
    if (!isValidUrl) {
      return; // Don't show sheet if no valid image URL
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff121212)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            children: [
              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff2A2A2A)
                          : Color(0xffE5E5E5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : AppColors.blackColor151,
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Image
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 16),
                  child: CachedNetworkImage(
                    imageUrl: certificateUrl.trim(),
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : AppColors.blackColor151,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: CustomTextStyles.lightTextStyle(
                              color: ThemeUtil.isDarkMode(context)
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor151,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
