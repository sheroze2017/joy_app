import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/modules/doctor/models/doctor_appointment_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

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

  @override
  Widget build(BuildContext context) {
    _fnameController.setText(widget.details == null
        ? ''
        : 'Name ' + widget.details!.userDetails!.name.toString());
    _symptomsController.setText(
        widget.details == null ? '' : widget.details!.symptoms.toString());
    _complainController.setText(
        widget.details == null ? '' : widget.details!.complain.toString());
    _locationController.setText(widget.details == null
        ? ''
        : 'Location ' + widget.details!.location.toString());
    _timeController.setText(widget.details == null
        ? ''
        : widget.details!.date.toString() +
            ' Time ' +
            widget.details!.time.toString());
    _ageController.setText(
        widget.details == null ? '' : 'Age ' + widget.details!.age.toString());
    _genderController.setText(widget.details!.gender.toString());
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          widget.details!.userDetails!.image!.contains('http')
                              ? widget.details!.userDetails!.image!
                              : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                          width: 33.9.w,
                          height: 33.9.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  controller: _fnameController,
                  hintText: 'James',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  controller: _lnameController,
                  hintText: '',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode3,
                  nextFocusNode: _focusNode4,
                  controller: _genderController,
                  hintText: 'Female',
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
                  isenable: false,
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  controller: _complainController,
                  hintText: 'Depression, Anxiety',
                  maxlines: true,
                  icon: '',
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
                  isenable: false,
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
                  controller: _symptomsController,
                  maxlines: true,
                  hintText:
                      'e veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode6,
                  nextFocusNode: _focusNode7,
                  controller: _ageController,
                  hintText: 'Age',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode7,
                  nextFocusNode: _focusNode8,
                  controller: _locationController,
                  hintText: 'USA',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode8,
                  nextFocusNode: _focusNode9,
                  controller: _feesController,
                  hintText: '20\$ paid',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
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
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode10,
                  nextFocusNode: _focusNode11,
                  controller: _medicalCertificateController,
                  hintText: 'Medical Certificate - PDF',
                  icon: 'Assets/icons/attach-icon.svg',
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
