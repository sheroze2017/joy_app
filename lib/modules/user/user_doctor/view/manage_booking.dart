import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/pharmacy/view/review_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/models/user.dart';

import '../bloc/user_doctor_bloc.dart';
import '../model/all_user_appointment.dart';
import '../../../../common/profile/view/my_profile.dart';
import 'doctor_daignosis.dart';
import 'reschedule_appointment_user.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';

class ManageAllAppointmentUser extends StatefulWidget {
  const ManageAllAppointmentUser({super.key});

  @override
  State<ManageAllAppointmentUser> createState() =>
      _ManageAllAppointmentUserState();
}

class _ManageAllAppointmentUserState extends State<ManageAllAppointmentUser>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Call API when tab changes to Upcoming (index 0)
        if (_tabController.index == 0) {
          _userdoctorController.getUserAppointmentsByStatus();
        }
      }
    });
    // Call API initially for Upcoming tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userdoctorController.getUserAppointmentsByStatus();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _userdoctorController = Get.find<UserDoctorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.whiteColor
                  : Color(0xff374151)),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.darkBlueColor,
          labelColor: AppColors.darkBlueColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: CustomTextStyles.w600TextStyle(size: 16),
          tabs: [
            Tab(
              text: 'Upcoming',
            ),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Obx(() {
                      // Filter appointments: show all (CONFIRMED and PENDING) under Upcoming, exclude CANCELLED
                      final upcomingAppointments = _userdoctorController.userAppointment
                          .where((element) {
                            final status = element.status?.toUpperCase() ?? '';
                            return (status == 'CONFIRMED' || status == 'PENDING') && status != 'CANCELLED';
                          })
                          .toList();
                      
                      return upcomingAppointments.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Center(
                                child: SubHeading(
                                  title: 'No upcoming appointments',
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: upcomingAppointments.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        AppointmentCardUser(
                                          bookingDetail: upcomingAppointments[index],
                                        ),
                                      ],
                                    );
                                  }),
                            );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Obx(() {
                      // Filter appointments: show only COMPLETED status under Completed tab
                      final completedAppointments = _userdoctorController.userAppointment
                          .where((element) => 
                              element.status?.toUpperCase() == 'COMPLETED')
                          .toList();
                      
                      return completedAppointments.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Center(
                                child: SubHeading(
                                  title: 'No appointments yet completed',
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: completedAppointments.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                DoctorDaginosis(
                                                  details: completedAppointments[index],
                                                  prescription:
                                                      completedAppointments[index]
                                                          .medications,
                                                  patName: completedAppointments[index]
                                                      .patientName,
                                                  daignosis:
                                                      completedAppointments[index]
                                                          .diagnosis,
                                                ),
                                                transition: Transition.native);
                                          },
                                          child: AppointmentCardUser(
                                            bookingDetail: completedAppointments[index],
                                            isCompleted: true,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            );
                    }),
                  ],
                ),
              ),
            ],
          ),
          Obx(() => _userdoctorController.appointmentLoader.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ))
              : Container())
        ],
      ),
    );
  }
}

class AppointmentCardUser extends StatefulWidget {
  bool isCompleted;
  UserAppointment bookingDetail;
  AppointmentCardUser({required this.bookingDetail, this.isCompleted = false});

  @override
  State<AppointmentCardUser> createState() => _AppointmentCardUserState();
}

class _AppointmentCardUserState extends State<AppointmentCardUser> {
  final _userdoctorController = Get.find<UserDoctorController>();
  AppointmentReview? _userReview;
  bool _reviewChecked = false;

  @override
  void initState() {
    super.initState();
    _checkUserReview();
  }

  @override
  void didUpdateWidget(covariant AppointmentCardUser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookingDetail.appointmentId !=
            widget.bookingDetail.appointmentId ||
        oldWidget.bookingDetail.rating != widget.bookingDetail.rating ||
        oldWidget.bookingDetail.review != widget.bookingDetail.review ||
        oldWidget.bookingDetail.reviewCreatedAt !=
            widget.bookingDetail.reviewCreatedAt) {
      _checkUserReview();
    }
  }

  bool _hasDirectReview(UserAppointment appointment) {
    final ratingValue = _ratingToDouble(appointment.rating);
    if (ratingValue != null && ratingValue > 0) {
      return true;
    }
    final review = appointment.review;
    return review != null && review.trim().isNotEmpty;
  }

  double? _ratingToDouble(dynamic rating) {
    if (rating is int) {
      return rating.toDouble();
    }
    if (rating is double) {
      return rating;
    }
    if (rating is String) {
      return double.tryParse(rating);
    }
    return null;
  }

  dynamic _normalizeRating(dynamic rating) {
    final normalized = _ratingToDouble(rating);
    if (normalized != null) {
      return normalized;
    }
    return rating ?? 0;
  }

  // Check if current user has already given a review
  Future<void> _checkUserReview() async {
    if (_hasDirectReview(widget.bookingDetail)) {
      setState(() {
        _userReview = AppointmentReview(
          rating: _normalizeRating(widget.bookingDetail.rating),
          review: widget.bookingDetail.review ?? '',
          createdAt: widget.bookingDetail.reviewCreatedAt,
        );
        _reviewChecked = true;
      });
      return;
    }
    UserHive? currentUser = await getCurrentUser();
    if (currentUser == null || widget.bookingDetail.doctorDetails?.reviews == null) {
      setState(() {
        _reviewChecked = true;
      });
      return;
    }
    
    String currentUserId = currentUser.userId.toString();
    for (var review in widget.bookingDetail.doctorDetails!.reviews!) {
      if (review.givenBy?.toString() == currentUserId) {
        setState(() {
          _userReview = review;
          _reviewChecked = true;
        });
        return;
      }
    }
    setState(() {
      _reviewChecked = true;
    });
  }

  Widget _buildDoctorAvatar(String? imageUrl, BuildContext context) {
    final isValidUrl = imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab') &&
        !imageUrl.contains('194.233.69.219');
    
    if (isValidUrl) {
      return Image.network(
        imageUrl.trim(),
        width: 27.9.w,
        height: 27.9.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
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
    final hasDirectReview = _hasDirectReview(widget.bookingDetail);
    final hasAnyReview = hasDirectReview || _userReview != null;
    final reviewText = hasDirectReview
        ? (widget.bookingDetail.review ?? '')
        : (_userReview?.review ?? '');
    final reviewRating = hasDirectReview
        ? _normalizeRating(widget.bookingDetail.rating)
        : _normalizeRating(_userReview?.rating);
    final ratingValue = _ratingToDouble(reviewRating) ?? 0;
    final ratingStars = ratingValue.floor();

    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.bookingDetail.date.toString() +
                      ' - ' +
                      widget.bookingDetail.time.toString(),
                  style: CustomTextStyles.darkHeadingTextStyle(size: 14),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.bookingDetail.status?.toUpperCase() == 'CONFIRMED'
                        ? Color(0xff10B981) // Green for confirmed
                        : widget.bookingDetail.status?.toUpperCase() == 'PENDING'
                            ? Color(0xffF59E0B) // Orange/Amber for pending
                            : Color(0xff6B7280), // Gray for other statuses
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.bookingDetail.status?.toUpperCase() ?? 'UNKNOWN',
                    style: CustomTextStyles.w600TextStyle(
                      size: 12,
                      color: Colors.white,
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
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: _buildDoctorAvatar(
                    widget.bookingDetail.doctorDetails?.doctorImage,
                    context,
                  ),
                ),
                SizedBox(
                  width: 2.w,
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
                            widget.bookingDetail.doctorDetails!.doctorName.toString(),
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            widget.bookingDetail
                                .doctorDetails!.doctorDetails!.qualification
                                .toString(),
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
                              Text(widget.bookingDetail.location.toString(),
                                  style: CustomTextStyles.lightTextStyle(
                                      color: Color(0xff4B5563), size: 14))
                            ],
                          ),
                        ],
                      ),
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
            // Show review if exists, otherwise show Add Review button for completed appointments
            if (widget.isCompleted && _reviewChecked) ...[
              if (hasAnyReview) ...[
                // Show existing review
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff1f2228)
                        : Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Review',
                            style: CustomTextStyles.w600TextStyle(
                              size: 14,
                              color: ThemeUtil.isDarkMode(context)
                                  ? AppColors.whiteColor
                                  : Color(0xff111928),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: index < ratingStars
                                    ? Colors.amber
                                    : Colors.grey,
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        reviewText,
                        style: CustomTextStyles.lightTextStyle(
                          size: 14,
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffAAAAAA)
                              : Color(0xff4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Show Add Review button if no review exists
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedButtonSmall(
                          text: 'Add Review',
                          onPressed: () {
                            Get.to(
                                ReviewScreen(
                                  details: widget.bookingDetail,
                                  buttonBgColor: Color(0xff033890),
                                ),
                                transition: Transition.native);
                          },
                          backgroundColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xff0443A9)
                              : AppColors.darkBlueColor,
                          textColor: AppColors.whiteColor),
                    ),
                  ],
                ),
              ],
            ] else if (!widget.isCompleted) ...[
              // For non-completed appointments, show Reschedule and Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RoundedButtonSmall(
                        isSmall: true,
                        isBold: true,
                        text: 'Reschedule',
                        onPressed: () {
                          _handleReschedule(context);
                        },
                        backgroundColor: ThemeUtil.isDarkMode(context)
                            ? Color(0xff00143D)
                            : AppColors.lightGreyColor,
                        textColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : Color(0xff033890)),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: RoundedButtonSmall(
                        isSmall: true,
                        isBold: true,
                        text: 'Cancel',
                        onPressed: () {
                          _handleCancel(context);
                        },
                        backgroundColor: ThemeUtil.isDarkMode(context)
                            ? Color(0xff00143D)
                            : AppColors.lightGreyColor,
                        textColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : Color(0xff033890)),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _handleReschedule(BuildContext context) async {
    try {
      // Get doctor_user_id from appointment
      // Try doctor_user_id first, then fall back to doctor_details._id
      String? doctorUserId;
      
      // First try: use doctorUserId (now supports both String and int)
      if (widget.bookingDetail.doctorUserId != null) {
        final doctorUserIdValue = widget.bookingDetail.doctorUserId;
        if (doctorUserIdValue is String && doctorUserIdValue.isNotEmpty) {
          doctorUserId = doctorUserIdValue;
        } else if (doctorUserIdValue is int && doctorUserIdValue != 0) {
          doctorUserId = doctorUserIdValue.toString();
        }
      }
      
      // Second try: use doctor_details._id if doctorUserId is invalid
      if ((doctorUserId == null || doctorUserId.isEmpty || doctorUserId == '0') && 
          widget.bookingDetail.doctorDetails?.doctorId != null) {
        final doctorIdValue = widget.bookingDetail.doctorDetails!.doctorId;
        if (doctorIdValue is String && doctorIdValue.isNotEmpty) {
          doctorUserId = doctorIdValue;
        } else if (doctorIdValue is int && doctorIdValue != 0) {
          doctorUserId = doctorIdValue.toString();
        }
      }
      
      // If still no valid ID, show error
      if (doctorUserId == null || doctorUserId.isEmpty || doctorUserId == '0') {
        showErrorMessage(context, 'Doctor ID not found. Please try again.');
        return;
      }

      // Call getDoctorDetails API
      final doctorDetail = await _userdoctorController.getDoctorDetail(doctorUserId);
      if (doctorDetail.data == null) {
        showErrorMessage(context, 'Error loading doctor details');
        return;
      }

      // Navigate to reschedule screen
      Get.to(
        RescheduleAppointmentUser(
          appointmentId: widget.bookingDetail.appointmentId?.toString() ?? '',
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
                _userdoctorController.cancelAppointment(
                  widget.bookingDetail.appointmentId?.toString() ?? '',
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
}
