import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/core/utils/fucntions/utils.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:joy_app/modules/doctor/models/doctor_appointment_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/patient_profile.dart';
import 'package:joy_app/modules/doctor/view/manage_appointment.dart';
import 'package:joy_app/modules/doctor/view/reschedule_appointment.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:sizer/sizer.dart';

class AllAppointments extends StatelessWidget {
  AllAppointments({super.key});
  DoctorController _doctorController = Get.put(DoctorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
            title: 'Appointments',
            leading: Container(),
            actions: [],
            showIcon: false),
        body: RefreshIndicator(
          onRefresh: () async {
            _doctorController.AllAppointments();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Divider(
                        color: Color(0xffE5E7EB),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Obx(() {
                        // Filter appointments: show PENDING and CONFIRMED (exclude CANCELLED)
                        // Also deduplicate by appointmentId to prevent duplicates
                        final Set<String> seenIds = <String>{};
                        final appointments = _doctorController.doctorAppointment
                            .where((element) {
                              final appointmentId = element.appointmentId?.toString() ?? '';
                              final status = element.status?.toUpperCase() ?? '';
                              final isValidStatus = status == 'PENDING' ||
                                  status == 'CONFIRMED' ||
                                  status == 'IN_PROGRESS';
                              // Exclude CANCELLED appointments
                              final isNotCancelled = status != 'CANCELLED';
                              // Only include if valid status and not already seen
                              if (isValidStatus && isNotCancelled && appointmentId.isNotEmpty && !seenIds.contains(appointmentId)) {
                                seenIds.add(appointmentId);
                                return true;
                              }
                              return false;
                            })
                            .toList();
                        
                        return appointments.isEmpty
                            ? Column(
                                children: [
                                  Center(
                                    child: SubHeading(
                                      title: 'No appointments',
                                    ),
                                  ),
                                  Obx(() => RoundedButtonSmall(
                                      showLoader: _doctorController
                                          .fetchAppointmentLoader.value,
                                      text: 'refresh',
                                      onPressed: () {
                                        !_doctorController
                                                .fetchAppointmentLoader.value
                                            ? {
                                                _doctorController
                                                    .AllAppointments()
                                              }
                                            : {
                                                showErrorMessage(context,
                                                    'Request already in process')
                                              };
                                      },
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white))
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointments[index];
                                  final appointmentId = appointment.appointmentId?.toString() ?? '';
                                  return Column(
                                    key: ValueKey('appointment_selector_$appointmentId'), // Unique key to prevent duplicates
                                    children: [
                                      AppointmentSelector(
                                        details: appointment,
                                        allAppointmentIds: appointments
                                            .map((e) => e.appointmentId?.toString() ?? '')
                                            .where((id) => id.isNotEmpty)
                                            .toList(),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                    ],
                                  );
                                });
                      })
                    ],
                  ),
                ),
              ),
              Obx(() => _doctorController.appointmentLoader.value
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox())
            ],
          ),
        ));
  }
}

class AppointmentSelector extends StatefulWidget {
  final Appointment details;
  final List<String> allAppointmentIds;
  
  AppointmentSelector({required this.details, required this.allAppointmentIds});

  @override
  State<AppointmentSelector> createState() => _AppointmentSelectorState();
}

class _AppointmentSelectorState extends State<AppointmentSelector> {
  final _doctorController = Get.find<DoctorController>();
  bool _isInProgress = false;
  bool _shouldDisableStart = false;
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;
  Timer? _elapsedTimer; // Timer for updating elapsed time every second
  Timer? _statusCheckTimer; // Timer for checking status periodically

  @override
  void initState() {
    super.initState();
    _checkAppointmentStatus();
    // Periodically check status to catch changes (every 2 seconds)
    _statusCheckTimer = Timer.periodic(Duration(seconds: 2), (statusTimer) {
      if (!mounted) {
        statusTimer.cancel();
        return;
      }
      _checkAppointmentStatus();
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkAppointmentStatus() async {
    final appointmentId = widget.details.appointmentId?.toString() ?? '';
    if (appointmentId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getString('appointment_status_$appointmentId');
      final startTimeString = prefs.getString('appointment_start_time_$appointmentId');
      
      // Check if any OTHER appointment is in progress
      String? inProgressId;
      for (var id in widget.allAppointmentIds) {
        if (id != appointmentId && id.isNotEmpty) {
          final otherStatus = prefs.getString('appointment_status_$id');
          if (otherStatus == 'IN_PROGRESS') {
            inProgressId = id;
            break;
          }
        }
      }
      
      // Update start time and calculate elapsed time if in progress
      DateTime? newStartTime;
      if (status == 'IN_PROGRESS' && startTimeString != null) {
        try {
          newStartTime = DateTime.parse(startTimeString);
        } catch (e) {
          newStartTime = null;
        }
      }
      
      final bool newIsInProgress = status == 'IN_PROGRESS';
      
      setState(() {
        _isInProgress = newIsInProgress;
        _shouldDisableStart = inProgressId != null && !newIsInProgress;
        _startTime = newStartTime;
      });
      
      // Start/stop elapsed time timer based on status
      if (newIsInProgress && newStartTime != null) {
        // Start timer if not already running
        if (_elapsedTimer == null || !_elapsedTimer!.isActive) {
          _calculateElapsedTime(); // Calculate immediately
          _elapsedTimer?.cancel(); // Cancel old timer if exists
          _elapsedTimer = Timer.periodic(Duration(seconds: 1), (timer) {
            if (mounted && _startTime != null) {
              _calculateElapsedTime();
            } else {
              timer.cancel();
            }
          });
        }
      } else {
        // Stop timer if not in progress
        if (_elapsedTimer != null && _elapsedTimer!.isActive) {
          _elapsedTimer?.cancel();
          _elapsedTimer = null;
        }
        if (!newIsInProgress) {
          setState(() {
            _elapsedTime = Duration.zero;
          });
        }
      }
    }
  }

  void _calculateElapsedTime() {
    if (_startTime != null) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
      });
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _handleReschedule(BuildContext context) async {
    try {
      // Get current logged in doctor user
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        showErrorMessage(context, 'User not logged in');
        return;
      }

      // Call getDoctorDetails API
      await _doctorController.getDoctorDetail();
      final doctorDetail = _doctorController.doctorDetail;
      if (doctorDetail == null) {
        showErrorMessage(context, 'Error loading doctor details');
        return;
      }

      // Navigate to reschedule screen
      Get.to(
        RescheduleAppointment(
          appointmentId: widget.details.appointmentId?.toString() ?? '',
          doctorDetail: doctorDetail,
        ),
        transition: Transition.native,
      );
    } catch (e) {
      showErrorMessage(context, 'Error: ${e.toString()}');
    }
  }

  void _handleCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _doctorController.cancelAppointment(
                  widget.details.appointmentId?.toString() ?? '',
                  context,
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

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
    return InkWell(
      onTap: () {
        Get.to(
            PatientProfileScreen(
              details: widget.details,
            ),
            transition: Transition.native);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ThemeUtil.isDarkMode(context)
                ? AppColors.purpleBlueColor
                : AppColors.lightishBlueColor5ff),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Format date from "2025-01-10" to "January 10, 2025"
              Text(
                widget.details.date != null && widget.details.date!.isNotEmpty
                    ? (() {
                        try {
                          DateTime dateTime = DateTime.parse(widget.details.date!);
                          return '${DateFormat('MMMM dd, yyyy').format(dateTime)} - ${widget.details.time ?? ''}';
                        } catch (e) {
                          return '${widget.details.date} - ${widget.details.time ?? ''}';
                        }
                      })()
                    : formatDateTime(
                        widget.details.createdAt ?? "2024-06-28 04:29:33", false),
                style: CustomTextStyles.darkHeadingTextStyle(size: 14),
              ),
              Divider(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff1f2228)
                    : Color(0xffE5E7EB),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: _buildPatientAvatar(widget.details.userDetails?.image?.toString() ?? '', context),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.details.userDetails?.name?.toString() ?? widget.details.patientName ?? 'Unknown',
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            widget.details.complain?.toString() ?? '',
                            style: CustomTextStyles.w600TextStyle(
                                size: 14, color: Color(0xff4B5563)),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('Assets/icons/location.svg'),
                              SizedBox(
                                width: 0.5.w,
                              ),
                              Text(widget.details.location?.toString() ?? '',
                                  style: CustomTextStyles.lightTextStyle(
                                      color: Color(0xff4B5563), size: 14))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff1f2228)
                    : Color(0xffE5E7EB),
              ),
              // Show different buttons based on status
              widget.details.status?.toUpperCase() == 'PENDING'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                              text: 'Approve',
                              onPressed: () {
                                _doctorController.updateAppointment(
                                    widget.details.appointmentId.toString(),
                                    "CONFIRMED",
                                    'Appointment confirmed. See you on the scheduled date.',
                                    context,
                                    widget.details.doctorUserId?.toString() ?? '');
                              },
                              backgroundColor: ThemeUtil.isDarkMode(context)
                                  ? AppColors.darkBlueColor
                                  : AppColors.darkBlueColor,
                              textColor: AppColors.whiteColor),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: RoundedButtonSmall(
                              text: 'Cancel',
                              onPressed: () {
                                _doctorController.updateAppointment(
                                    widget.details.appointmentId.toString(),
                                    "CANCELLED",
                                    'Appointment cancelled by doctor.',
                                    context,
                                    widget.details.doctorUserId?.toString() ?? '');
                              },
                              backgroundColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0xff00143D)
                                  : AppColors.lightGreyColor,
                              textColor: ThemeUtil.isDarkMode(context)
                                  ? AppColors.whiteColor
                                  : AppColors.darkBlueColor),
                        ),
                      ],
                    )
                  : widget.details.status?.toUpperCase() == 'CONFIRMED'
                      ? Column(
                          children: [
                            // Show timer if appointment is in progress
                            if (_isInProgress && _elapsedTime.inSeconds > 0) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 16,
                                    color: ThemeUtil.isDarkMode(context)
                                        ? AppColors.whiteColor
                                        : AppColors.darkBlueColor,
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Text(
                                    _formatDuration(_elapsedTime),
                                    style: CustomTextStyles.w600TextStyle(
                                      size: 14,
                                      color: ThemeUtil.isDarkMode(context)
                                          ? AppColors.whiteColor
                                          : AppColors.darkBlueColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                            ],
                            // First line: Start button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RoundedButtonSmall(
                                      text: _isInProgress ? 'Complete' : 'Start',
                                      onPressed: (_shouldDisableStart && !_isInProgress)
                                          ? () {}
                                          : () {
                                              Get.to(
                                                  ManageAppointment(
                                                      phoneNo: widget.details.userDetails?.phone,
                                                      appointmentId:
                                                          widget.details.appointmentId?.toString() ?? '',
                                                      doctorId:
                                                          widget.details.doctorUserId?.toString() ?? ''),
                                                  transition: Transition.native);
                                            },
                                      backgroundColor: (_shouldDisableStart && !_isInProgress)
                                          ? ThemeUtil.isDarkMode(context)
                                              ? Color(0xff00143D)
                                              : Color(0xffE5E7EB)
                                          : ThemeUtil.isDarkMode(context)
                                              ? AppColors.darkBlueColor
                                              : AppColors.darkBlueColor,
                                      textColor: (_shouldDisableStart && !_isInProgress)
                                          ? AppColors.darkBlueColor.withOpacity(0.5)
                                          : AppColors.whiteColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            // Second line: Reschedule and Cancel buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RoundedButtonSmall(
                                      text: 'Reschedule',
                                      onPressed: () {
                                        _handleReschedule(context);
                                      },
                                      backgroundColor: ThemeUtil.isDarkMode(context)
                                          ? Color(0xff00143D)
                                          : AppColors.lightGreyColor,
                                      textColor: ThemeUtil.isDarkMode(context)
                                          ? AppColors.whiteColor
                                          : AppColors.darkBlueColor),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: RoundedButtonSmall(
                                      text: 'Cancel',
                                      onPressed: () {
                                        _handleCancel(context);
                                      },
                                      backgroundColor: ThemeUtil.isDarkMode(context)
                                          ? Color(0xff00143D)
                                          : AppColors.lightGreyColor,
                                      textColor: ThemeUtil.isDarkMode(context)
                                          ? AppColors.whiteColor
                                          : AppColors.darkBlueColor),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
