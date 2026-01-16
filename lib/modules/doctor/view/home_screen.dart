import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/all_appointment.dart';
import 'package:joy_app/modules/doctor/view/manage_appointment.dart';
import 'package:joy_app/modules/user/user_hospital/view/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/profile/view/my_profile.dart';
import '../../../common/navbar/controller/navbar_controller.dart';

class DoctorHomeScreen extends StatefulWidget {
  DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  DoctorController _doctorController = Get.put(DoctorController());
  final NavBarController _navBarController = Get.find<NavBarController>();
  int? _lastTabIndex;

  @override
  void initState() {
    super.initState();
    // Load data initially
    _loadData();
    _lastTabIndex = _navBarController.tabIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use post-frame callback to check tab changes after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentTabIndex = _navBarController.tabIndex;
      // If we're coming back to home screen (tab index 0), refresh data
      if (currentTabIndex == 0 && _lastTabIndex != null && _lastTabIndex != 0) {
        _loadData();
      }
      _lastTabIndex = currentTabIndex;
    });
  }

  void _loadData() {
    if (mounted) {
      _doctorController.AllAppointments();
      _doctorController.getDoctorDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(
      builder: (navController) {
        // Check if we're coming back to home screen (tab index 0)
        if (navController.tabIndex == 0 && _lastTabIndex != null && _lastTabIndex != 0) {
          // Refresh data when returning to home screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _loadData();
            }
          });
        }
        _lastTabIndex = navController.tabIndex;
        
        return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 60.0, // Add 60 margin for iOS dynamic island
            bottom: 0,
          ),
          child: Column(
            children: [
              // Appointments and Patient History cards at the top
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(AllAppointments(),
                            transition: Transition.native);
                      },
                      child: HeaderMenu(
                        bgColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.purpleBlueColor
                            : AppColors.lightBlueColore5e,
                        imgbgColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.darkishBlueColorb46
                            : AppColors.lightBlueColord0d,
                        imagepath: 'Assets/icons/calendar.svg',
                        title: 'Appointments',
                        subTitle: 'Manage Appointments',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(
                            ManageAppointment(
                              showPatientHistoryFromScreen: true,
                            ),
                            transition: Transition.native);
                      },
                      child: HeaderMenu(
                        bgColor: AppColors.lightGreenColor,
                        imgbgColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.darkGreenColor
                            : AppColors.lightGreenColorFC7,
                        iconColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : AppColors.darkGreenColor,
                        imagepath: 'Assets/icons/menu-board.svg',
                        title: 'Patient History',
                        subTitle: 'Manage Patient’s History',
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Upcoming Appointments',
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.lightBlueColor3e3
                            : null),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.to(AllAppointments(), transition: Transition.native);
                    },
                    child: Text(
                      'See All',
                      style: CustomTextStyles.lightSmallTextStyle(size: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Obx(() {
                // Filter appointments: show CONFIRMED and IN_PROGRESS status
                // Also deduplicate by appointmentId to prevent duplicates
                final Set<String> seenIds = <String>{};
                final allAppointments = _doctorController.doctorAppointment
                    .where((element) {
                      final appointmentId = element.appointmentId?.toString() ?? '';
                      final status = element.status?.toUpperCase() ?? '';
                      final isConfirmed = status == 'CONFIRMED';
                      final isInProgress = status == 'IN_PROGRESS';
                      // Include if confirmed or in progress, and not already seen
                      if ((isConfirmed || isInProgress) && appointmentId.isNotEmpty && !seenIds.contains(appointmentId)) {
                        seenIds.add(appointmentId);
                        return true;
                      }
                      return false;
                    })
                    .toList();
                
                // Sort: IN_PROGRESS appointments first, then CONFIRMED
                allAppointments.sort((a, b) {
                  final aStatus = a.status?.toUpperCase() ?? '';
                  final bStatus = b.status?.toUpperCase() ?? '';
                  if (aStatus == 'IN_PROGRESS' && bStatus != 'IN_PROGRESS') return -1;
                  if (aStatus != 'IN_PROGRESS' && bStatus == 'IN_PROGRESS') return 1;
                  return 0;
                });
                
                // Limit to 2 appointments on home screen
                final displayAppointments = allAppointments.take(2).toList();
                
                return displayAppointments.isEmpty
                    ? Center(
                        child: SubHeading(
                          title: 'No upcoming appointments',
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: displayAppointments.length,
                        itemBuilder: (context, index) {
                          final data = displayAppointments[index];
                          final appointmentId = data.appointmentId?.toString() ?? '';
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
                          
                          return AppointmentCardWithTimer(
                            key: ValueKey('appointment_$appointmentId'), // Unique key to prevent duplicates
                            appointmentId: appointmentId,
                            bgColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.purpleBlueColor
                                : AppColors.lightishBlueColor5ff,
                            isHospital: true,
                            imgPath: data.userDetails?.image?.toString() ?? '',
                            name: data.userDetails?.name?.toString() ?? data.patientName ?? 'Unknown',
                            time: '$formattedDate - ${data.time}',
                            location: data.location?.toString() ?? '',
                            category: data.complain?.toString() ?? 'General',
                            buttonColor: Color(0xff0443A9),
                            phoneNo: data.userDetails?.phone,
                            doctorId: data.doctorUserId?.toString() ?? '',
                            allAppointmentIds: displayAppointments
                                .map((e) => e.appointmentId?.toString() ?? '')
                                .where((id) => id.isNotEmpty)
                                .toList(),
                          );
                        });
              }),
              SizedBox(
                height: 0.75.h,
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Heading(
                      title: 'Reviews',
                    ),
                    SizedBox(height: 2.h),
                    Obx(() {
                      // Get reviews from appointments that have a review object
                      final reviews = _doctorController.doctorAppointment
                          .where((appointment) => 
                              appointment.review != null && 
                              appointment.review!.review != null &&
                              appointment.review!.review!.isNotEmpty)
                          .map((appointment) => appointment.review!)
                          .toList();
                      
                      return reviews.isEmpty
                          ? Center(
                              child: SubHeading(
                                title: 'No reviews yet',
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reviews.length,
                              itemBuilder: ((context, index) {
                                final reviewData = reviews[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: UserRatingWidget(
                                    image: reviewData.patientImage,
                                    docName: reviewData.patientName ?? 'Unknown',
                                    reviewText: reviewData.review ?? '',
                                    rating: reviewData.rating,
                                  ),
                                );
                              }));
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

class AppointmentCardWithTimer extends StatefulWidget {
  final String appointmentId;
  final String imgPath;
  final String name;
  final String category;
  final String location;
  final String time;
  final Color buttonColor;
  final Color bgColor;
  final bool isHospital;
  final String? phoneNo;
  final String? doctorId;
  final List<String> allAppointmentIds;

  AppointmentCardWithTimer({
    super.key,
    required this.appointmentId,
    required this.imgPath,
    required this.name,
    required this.category,
    required this.location,
    required this.time,
    required this.buttonColor,
    required this.bgColor,
    this.isHospital = false,
    this.phoneNo,
    this.doctorId,
    required this.allAppointmentIds,
  });

  @override
  State<AppointmentCardWithTimer> createState() => _AppointmentCardWithTimerState();
}

class _AppointmentCardWithTimerState extends State<AppointmentCardWithTimer> {
  String? _appointmentStatus;
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;
  Timer? _timer;
  Timer? _statusCheckTimer;
  bool _shouldDisableStart = false;

  @override
  void initState() {
    super.initState();
    _checkAppointmentStatus();
    // Periodically check status to update UI immediately
    _statusCheckTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        _checkAppointmentStatus();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _checkAppointmentStatus() async {
    if (widget.appointmentId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getString('appointment_status_${widget.appointmentId}');
      final startTimeString = prefs.getString('appointment_start_time_${widget.appointmentId}');
      
      // Check if any other appointment is in progress
      String? inProgressId;
      for (var id in widget.allAppointmentIds) {
        if (id != widget.appointmentId && id.isNotEmpty) {
          final otherStatus = prefs.getString('appointment_status_$id');
          if (otherStatus == 'IN_PROGRESS') {
            inProgressId = id;
            break;
          }
        }
      }
      
      setState(() {
        _appointmentStatus = status;
        _shouldDisableStart = inProgressId != null && status != 'IN_PROGRESS';
        if (startTimeString != null && status == 'IN_PROGRESS') {
          _startTime = DateTime.parse(startTimeString);
          _calculateElapsedTime();
        }
      });
      
      // Start timer if appointment is in progress
      if (_appointmentStatus == 'IN_PROGRESS' && _startTime != null) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (_startTime != null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted && _startTime != null) {
          _calculateElapsedTime();
        } else {
          timer.cancel();
        }
      });
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
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      String hours = twoDigits(duration.inHours);
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInProgress = _appointmentStatus == 'IN_PROGRESS';
    final timerText = isInProgress ? _formatDuration(_elapsedTime) : null;
    
    // Ensure timer is running if appointment is in progress
    if (isInProgress && _startTime != null && (_timer == null || !_timer!.isActive)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startTimer();
        }
      });
    }
    
    return Column(
      children: [
        MeetingCallScheduler(
          bgColor: widget.bgColor,
          isHospital: widget.isHospital,
          nextMeeting: true,
          imgPath: widget.imgPath,
          name: widget.name,
          time: widget.time,
          location: widget.location,
          category: widget.category,
          buttonColor: widget.buttonColor,
          isInProgress: isInProgress,
          timerText: timerText,
          shouldDisableStart: _shouldDisableStart && !isInProgress,
          onPressed: (_shouldDisableStart && !isInProgress) 
              ? () {
                  // Show error message when trying to start while another is in progress
                  showErrorMessage(context, 'Another appointment is already in progress. Please complete it first.');
                }
              : () async {
                  // Double-check before navigating
                  if (!isInProgress) {
                    final prefs = await SharedPreferences.getInstance();
                    bool hasOtherInProgress = false;
                    for (var id in widget.allAppointmentIds) {
                      if (id != widget.appointmentId && id.isNotEmpty) {
                        final otherStatus = prefs.getString('appointment_status_$id');
                        if (otherStatus == 'IN_PROGRESS') {
                          hasOtherInProgress = true;
                          break;
                        }
                      }
                    }
                    if (hasOtherInProgress) {
                      showErrorMessage(context, 'Another appointment is already in progress. Please complete it first.');
                      return;
                    }
                  }
                  // Navigate and refresh status when returning
                  await Get.to(
                      ManageAppointment(
                          phoneNo: widget.phoneNo,
                          appointmentId: widget.appointmentId,
                          doctorId: widget.doctorId ?? ''),
                      transition: Transition.native);
                  // Refresh status when returning from ManageAppointment
                  _checkAppointmentStatus();
                },
        ),
        SizedBox(
          height: 1.h,
        )
      ],
    );
  }
}

class MeetingCallScheduler extends StatelessWidget {
  final String imgPath;
  final String name;
  final String category;
  final String location;
  final String time;
  final Color buttonColor;
  final Color bgColor;
  final String? pharmacyButtonText;
  bool nextMeeting;
  VoidCallback? onPressed;
  bool isActive;
  bool isPharmacy;
  bool? isDeliverd;
  bool? isHospital;
  bool? isInProgress;
  String? timerText;
  bool shouldDisableStart;

  MeetingCallScheduler(
      {super.key,
      required this.imgPath,
      required this.name,
      required this.category,
      required this.location,
      required this.time,
      this.onPressed,
      this.nextMeeting = false,
      this.isActive = true,
      this.isHospital = false,
      required this.buttonColor,
      required this.bgColor,
      this.isPharmacy = false,
      this.pharmacyButtonText = '',
      this.isDeliverd = false,
      this.isInProgress = false,
      this.timerText,
      this.shouldDisableStart = false});

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
          borderRadius: BorderRadius.circular(12), color: bgColor),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isPharmacy
                ? Text(
                    time,
                    style: CustomTextStyles.darkHeadingTextStyle(size: 14),
                  )
                : Container(),
            !isPharmacy
                ? Divider(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    thickness: 0.3,
                  )
                : Container(),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: _buildPatientAvatar(imgPath, context),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            category,
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
                              Expanded(
                                child: Text(location,
                                    style: CustomTextStyles.lightTextStyle(
                                        color: Color(0xff4B5563), size: 14)),
                              )
                            ],
                          ),
                          // Show timer if appointment is in progress
                          if (isInProgress == true && timerText != null) ...[
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: AppColors.darkBlueColor,
                                ),
                                SizedBox(
                                  width: 0.5.w,
                                ),
                                Text(
                                  timerText!,
                                  style: CustomTextStyles.w600TextStyle(
                                      size: 14, color: AppColors.darkBlueColor),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: 1.h,
                          ),
                          isDeliverd == true
                              ? Text(
                                  'Delivered',
                                  style: CustomTextStyles.w600TextStyle(
                                      size: 14,
                                      color: ThemeUtil.isDarkMode(context)
                                          ? AppColors.lightGreenColoreb1
                                          : AppColors.darkGreenColor),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isActive
                ? Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 0.2,
                  )
                : Container(),
            isActive
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                            text: isPharmacy
                                ? pharmacyButtonText.toString()
                                : (isInProgress == true)
                                    ? "Complete"
                                    : nextMeeting
                                        ? "Start"
                                        : "Starts In 15 Mins",
                            // onPressed: () {
                            //   //      showPaymentBottomSheet(context, true);
                            // },
                            onPressed: (shouldDisableStart && (isInProgress != true)) 
                                ? () {} 
                                : (onPressed ?? () {}),
                            backgroundColor: isPharmacy
                                ? buttonColor
                                : (shouldDisableStart && (isInProgress != true))
                                    ? ThemeUtil.isDarkMode(context)
                                        ? Color(0xff00143D)
                                        : Color(0xffE5E7EB)
                                    : (isInProgress == true || nextMeeting)
                                        ? ThemeUtil.isDarkMode(context)
                                            ? buttonColor
                                            : AppColors.darkBlueColor
                                        : ThemeUtil.isDarkMode(context)
                                            ? Color(0xff00143D)
                                            : Color(0xffE5E7EB),
                            textColor: (ThemeUtil.isDarkMode(context) &&
                                    (isHospital != null && isHospital == true))
                                ? AppColors.whiteColor
                                : ThemeUtil.isDarkMode(context)
                                    ? AppColors.blackColor
                                    : (shouldDisableStart && (isInProgress != true))
                                        ? AppColors.darkBlueColor.withOpacity(0.5)
                                        : (isInProgress == true || nextMeeting)
                                            ? AppColors.whiteColor
                                            : AppColors.darkBlueColor),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class HeaderMenu extends StatelessWidget {
  final String imagepath;
  final String title;
  final String subTitle;
  final Color bgColor;
  final Color imgbgColor;
  Color? iconColor;

  HeaderMenu(
      {super.key,
      required this.imagepath,
      required this.title,
      required this.bgColor,
      required this.imgbgColor,
      required this.subTitle,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(22.31)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 10.2.w,
                height: 10.2.w,
                decoration: BoxDecoration(
                    color: imgbgColor, borderRadius: BorderRadius.circular(50)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    imagepath,
                    color: iconColor,
                  ),
                ))),
            SizedBox(
              height: 2.h,
            ),
            Text(
              title,
              style: CustomTextStyles.w600TextStyle(
                  size: 18.87, color: AppColors.blackColor),
            ),
            Text(
              subTitle,
              style: CustomTextStyles.lightTextStyle(
                  size: 11, color: AppColors.blackColor393),
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
