import 'dart:async';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/doctor_bloc.dart';
import '../models/doctor_appointment_model.dart';
import '../view/patient_profile.dart';

class ManageAppointment extends StatefulWidget {
  bool? showPatientHistoryFromScreen;
  String? appointmentId;
  String? doctorId;
  String? phoneNo;
  ManageAppointment(
      {super.key,
      this.showPatientHistoryFromScreen = false,
      this.doctorId,
      this.phoneNo,
      this.appointmentId});

  @override
  State<ManageAppointment> createState() => _ManageAppointmentState();
}

class _ManageAppointmentState extends State<ManageAppointment> {
  bool showPatientHistory = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daignosisController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final _doctorController = Get.find<DoctorController>();
  String? _appointmentStatus;
  bool _isLoadingStatus = true;
  Duration _currentElapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadAppointmentStatus();
  }

  Future<bool> _checkIfAnyAppointmentInProgress(String? excludeAppointmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    
    for (String key in allKeys) {
      if (key.startsWith('appointment_status_')) {
        final appointmentId = key.replaceFirst('appointment_status_', '');
        if (appointmentId != excludeAppointmentId && appointmentId.isNotEmpty) {
          final status = prefs.getString(key);
          if (status == 'IN_PROGRESS') {
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<void> _loadAppointmentStatus() async {
    if (widget.appointmentId != null && widget.appointmentId!.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getString('appointment_status_${widget.appointmentId}');
      
      // If no status exists, check if another appointment is in progress
      if (status == null) {
        final hasOtherInProgress = await _checkIfAnyAppointmentInProgress(widget.appointmentId);
        if (hasOtherInProgress) {
          // Another appointment is in progress, show error and go back
          showErrorMessage(context, 'Another appointment is already in progress. Please complete it first.');
          setState(() {
            _appointmentStatus = null;
            _isLoadingStatus = false;
          });
          // Navigate back after a short delay
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              Get.back();
            }
          });
          return;
        }
        // No other appointment in progress, start this one
        await _saveAppointmentStatus('IN_PROGRESS');
        setState(() {
          _appointmentStatus = 'IN_PROGRESS';
          _isLoadingStatus = false;
        });
      } else {
        setState(() {
          _appointmentStatus = status;
          _isLoadingStatus = false;
        });
      }
    } else {
      // Check if any appointment is in progress before starting
      final hasOtherInProgress = await _checkIfAnyAppointmentInProgress(null);
      if (hasOtherInProgress) {
        showErrorMessage(context, 'Another appointment is already in progress. Please complete it first.');
        setState(() {
          _appointmentStatus = null;
          _isLoadingStatus = false;
        });
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            Get.back();
          }
        });
        return;
      }
      setState(() {
        _appointmentStatus = 'IN_PROGRESS';
        _isLoadingStatus = false;
      });
    }
  }

  Future<void> _saveAppointmentStatus(String status) async {
    if (widget.appointmentId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('appointment_status_${widget.appointmentId}', status);
      if (status == 'IN_PROGRESS') {
        await prefs.setString('appointment_start_time_${widget.appointmentId}', DateTime.now().toIso8601String());
      }
      setState(() {
        _appointmentStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showPatientHistory = !showPatientHistory;
          setState(() {});
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              showPatientHistory == true ||
                      (widget.showPatientHistoryFromScreen ?? false) == true
                  ? 'Patients History'
                  : 'Appointment In Progress',
              style: CustomTextStyles.darkTextStyle(
                  color: ThemeUtil.isDarkMode(context)
                      ? AppColors.whiteColor
                      : Color(0xff374151)),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ThemeUtil.isDarkMode(context)
                    ? AppColors.whiteColor
                    : Color(0xff374151),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: showPatientHistory == true ||
                        widget.showPatientHistoryFromScreen == true
                    ? _doctorController.doctorAppointment
                                .where((p0) => p0.status?.toUpperCase() == 'COMPLETED')
                                .isEmpty
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'No appointments dealt yet',
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              ),
                              Obx(() => RoundedButtonSmall(
                                  showLoader: _doctorController
                                      .fetchAppointmentLoader.value,
                                  text: 'refresh',
                                  onPressed: () {
                                    !_doctorController
                                            .fetchAppointmentLoader.value
                                        ? {_doctorController.AllAppointments()}
                                        : {
                                            showErrorMessage(context,
                                                'Request already in process')
                                          };
                                  },
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white))
                            ],
                          )
                        : Column(
                            children: [
                              Divider(
                                color: Color(0xffE5E7EB),
                                thickness: 0.3,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Obx(() {
                                // Filter appointments with COMPLETED status
                                final completedAppointments = _doctorController
                                    .doctorAppointment
                                    .where((appointment) => 
                                        appointment.status?.toUpperCase() == 'COMPLETED')
                                    .toList();
                                
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: completedAppointments.length,
                                    itemBuilder: (context, index) {
                                      final data = completedAppointments[index];
                                      // Format date from "2025-01-10" to "January 10, 2025"
                                      String formattedDate = data.date ?? '';
                                      try {
                                        if (data.date != null && data.date!.isNotEmpty) {
                                          DateTime dateTime = DateTime.parse(data.date!);
                                          formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
                                        }
                                      } catch (e) {
                                        formattedDate = data.date ?? '';
                                      }
                                      
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                  PatientProfileScreen(details: data),
                                                  transition: Transition.native);
                                            },
                                            child: CompletedAppointmentCard(
                                              appointment: data,
                                              formattedDate: formattedDate,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                        ],
                                      );
                                    });
                              })
                            ],
                          )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          TimerWidget(
                            appointmentId: widget.appointmentId,
                            onTimeUpdate: (elapsedTime) {
                              setState(() {
                                _currentElapsedTime = elapsedTime;
                              });
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text('Review to Patient ',
                              style: CustomTextStyles.w600TextStyle(
                                  color: ThemeUtil.isDarkMode(context)
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor151,
                                  size: 20)),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Patient's Name",
                            style: CustomTextStyles.lightTextStyle(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffDBDBDB)
                                    : Color(0xff3D4859)),
                          ),
                          RoundedBorderTextField(
                              controller: _nameController,
                              focusNode: _focusNode1,
                              nextFocusNode: _focusNode2,
                              hintText: 'James Robinson',
                              icon: ''),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Your Daignosis",
                            style: CustomTextStyles.lightTextStyle(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffDBDBDB)
                                    : Color(0xff3D4859)),
                          ),
                          RoundedBorderTextField(
                              focusNode: _focusNode2,
                              nextFocusNode: _focusNode3,
                              maxlines: true,
                              controller: _daignosisController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter daignosis';
                                } else {
                                  return null;
                                }
                              },
                              hintText: 'Daignoses ',
                              icon: ''),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Medications Prescribed",
                            style: CustomTextStyles.lightTextStyle(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffDBDBDB)
                                    : Color(0xff3D4859)),
                          ),
                          RoundedBorderTextField(
                            focusNode: _focusNode3,
                            nextFocusNode: _focusNode4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Prescription';
                              } else {
                                return null;
                              }
                            },
                            maxlines: true,
                            hintText: 'Medication Prescription',
                            controller: _prescriptionController,
                            icon: '',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => _doctorController
                                          .appointmentLoader.value
                                      ? Center(
                                          child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: CircularProgressIndicator(),
                                        ))
                                      : Expanded(
                                          child: RoundedButtonSmall(
                                              text: 'Submit',
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                } else {
                                                  // Get elapsed time from timer and round to minutes
                                                  // Round up: if there are any seconds, add 1 minute
                                                  int timeTakenMinutes = _currentElapsedTime.inMinutes;
                                                  if (_currentElapsedTime.inSeconds % 60 > 0) {
                                                    timeTakenMinutes += 1;
                                                  }
                                                  
                                                  // Save status as COMPLETED
                                                  await _saveAppointmentStatus('COMPLETED');
                                                  
                                                  // Call API with diagnosis, medications, and time_taken
                                                  await _doctorController.giveMedicationWithTime(
                                                    widget.appointmentId?.toString() ?? '',
                                                    _daignosisController.text.toString(),
                                                    _prescriptionController.text.toString(),
                                                    timeTakenMinutes.toString(),
                                                    context,
                                                  );
                                                  
                                                  // Also update appointment status
                                                  _doctorController
                                                      .updateAppointment(
                                                          widget.appointmentId
                                                              .toString(),
                                                          'COMPLETED',
                                                          '${_daignosisController.text.toString()} ${_prescriptionController.text.toString()}',
                                                          context,
                                                          widget.doctorId
                                                              .toString());
                                                }
                                              },
                                              backgroundColor:
                                                  AppColors.darkBlueColor,
                                              textColor: AppColors.whiteColor),
                                        ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          )
                        ],
                      ),
              ),
            ),
          ),
        ));
  }

}

class CompletedAppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final String formattedDate;

  CompletedAppointmentCard({
    required this.appointment,
    required this.formattedDate,
  });

  Widget _buildPatientAvatar(String? imageUrl, BuildContext context) {
    final isValidUrl = imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab') &&
        !imageUrl.contains('194.233.69.219');
    
    if (isValidUrl) {
      return CachedNetworkImage(
        imageUrl: imageUrl.trim(),
        width: 27.9.w,
        height: 27.9.w,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Container(
            width: 27.9.w,
            height: 27.9.w,
            decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff2A2A2A)
                  : Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              Icons.person,
              size: 15.w,
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff5A5A5A)
                  : Color(0xffA5A5A5),
            ),
          );
        },
      );
    }
    return Container(
      width: 27.9.w,
      height: 27.9.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(
        Icons.person,
        size: 15.w,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeUtil.isDarkMode(context)
              ? AppColors.purpleBlueColor
              : AppColors.lightishBlueColor5ff,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Time
              Text(
                '$formattedDate - ${appointment.time ?? ''}',
                style: CustomTextStyles.darkHeadingTextStyle(size: 14),
              ),
              Divider(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff1f2228)
                    : Color(0xffE5E7EB),
                thickness: 0.3,
              ),
              SizedBox(height: 0.5.h),
              // Patient Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: _buildPatientAvatar(
                        appointment.userDetails?.image?.toString() ?? '',
                        context),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.userDetails?.name?.toString() ??
                              appointment.patientName ??
                              'Unknown',
                          style: CustomTextStyles.darkHeadingTextStyle(),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          appointment.gender?.toString() ?? '',
                          style: CustomTextStyles.w600TextStyle(
                              size: 14, color: Color(0xff4B5563)),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: Color(0xff4B5563)),
                            SizedBox(width: 0.5.w),
                            Expanded(
                              child: Text(
                                appointment.location?.toString() ?? '',
                                style: CustomTextStyles.lightTextStyle(
                                    color: Color(0xff4B5563), size: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}

class TimerWidget extends StatefulWidget {
  final String? appointmentId;
  final Function(Duration)? onTimeUpdate;
  
  TimerWidget({this.appointmentId, this.onTimeUpdate});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Load start time first, then start timer
    _loadStartTime();
  }

  Future<void> _loadStartTime() async {
    if (widget.appointmentId != null && widget.appointmentId!.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final startTimeString = prefs.getString('appointment_start_time_${widget.appointmentId}');
      final status = prefs.getString('appointment_status_${widget.appointmentId}');
      
      if (startTimeString != null && status == 'IN_PROGRESS') {
        // Resume existing timer
        if (mounted) {
          setState(() {
            _startTime = DateTime.parse(startTimeString);
          });
          _calculateElapsedTime();
        }
      } else if (status != 'COMPLETED') {
        // Check if another appointment is in progress before starting
        bool hasOtherInProgress = false;
        final allKeys = prefs.getKeys();
        for (String key in allKeys) {
          if (key.startsWith('appointment_status_')) {
            final appointmentId = key.replaceFirst('appointment_status_', '');
            if (appointmentId != widget.appointmentId && appointmentId.isNotEmpty) {
              final otherStatus = prefs.getString(key);
              if (otherStatus == 'IN_PROGRESS') {
                hasOtherInProgress = true;
                break;
              }
            }
          }
        }
        
        if (!hasOtherInProgress) {
          // Start new appointment only if no other is in progress
          if (mounted) {
            setState(() {
              _startTime = DateTime.now();
            });
            await _saveStartTime();
            _calculateElapsedTime();
          }
        }
      }
    } else {
      // No appointment ID - check before starting
      final prefs = await SharedPreferences.getInstance();
      bool hasOtherInProgress = false;
      final allKeys = prefs.getKeys();
      for (String key in allKeys) {
        if (key.startsWith('appointment_status_')) {
          final status = prefs.getString(key);
          if (status == 'IN_PROGRESS') {
            hasOtherInProgress = true;
            break;
          }
        }
      }
      
      if (!hasOtherInProgress) {
        if (mounted) {
          setState(() {
            _startTime = DateTime.now();
          });
          _calculateElapsedTime();
        }
      }
    }
    
    // Start periodic timer after initial setup
    if (mounted && _startTime != null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted && _startTime != null) {
          _calculateElapsedTime();
        }
      });
    }
  }

  Future<void> _saveStartTime() async {
    if (widget.appointmentId != null && _startTime != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('appointment_start_time_${widget.appointmentId}', _startTime!.toIso8601String());
      await prefs.setString('appointment_status_${widget.appointmentId}', 'IN_PROGRESS');
    }
  }

  void _calculateElapsedTime() {
    if (_startTime != null) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
        // Notify parent of time update
        if (widget.onTimeUpdate != null) {
          widget.onTimeUpdate!(_elapsedTime);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(_elapsedTime);
    
    // Calculate progress (0.0 to 1.0) - using a 60-minute max for visualization
    // This gives a better visual representation for typical appointment durations
    double progress = (_elapsedTime.inMinutes / 60.0).clamp(0.0, 1.0);

    return Center(
      child: Container(
        width: 40.w,
        height: 40.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Complete circle background (lighter blue - outer ring)
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffE0F2FE), // Light blue background
              ),
            ),
            // Progress indicator (darker blue arc)
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.darkBlueColor), // Darker blue for progress
                backgroundColor: Colors.transparent,
              ),
            ),
            // Timer text
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: ThemeUtil.isDarkMode(context)
                    ? AppColors.whiteColor
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
