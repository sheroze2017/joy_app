import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';

import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../../doctor/models/doctor_detail_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  DoctorDetail doctorDetail;
  String complain;
  String symptoms;
  String location;
  String age;
  String gender;
  String patientName;
  String certificateUrl;

  BookAppointmentScreen(
      {super.key,
      required this.doctorDetail,
      required this.complain,
      required this.age,
      required this.certificateUrl,
      required this.gender,
      required this.location,
      required this.patientName,
      required this.symptoms});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String _date = '';
  DateTime? selectedDate;
  String? timeSelection;

  //List<DateTime> _availableDates = [];
  List<DateTime> _blackoutDates = [];
  List<List<String>> availabilityTimes = [];
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        // Format date as YYYY-MM-DD for API
        _date = DateFormat('yyyy-MM-dd').format(args.value).toString();
        selectedDate = args.value;
      });
      setState(() {});
    });
  }

  UserDoctorController _doctorController = Get.find<UserDoctorController>();
  @override
  void initState() {
    super.initState();
    _initializeDates();
    setTime();
  }

  void setTime() async {
    availabilityTimes = await _doctorController.storeAvailabilityTimes();
  }

  void _initializeDates() async {
    List<DateTime> allDates = await _getAllDates();
    List<DateTime> _availableDates = await _getAvailableDates();
    List<DateTime> allDateOnly =
        allDates.map((dt) => DateTime(dt.year, dt.month, dt.day)).toList();
    List<DateTime> allavailableDate = _availableDates
        .map((dt) => DateTime(dt.year, dt.month, dt.day))
        .toList();
    List<DateTime> difference =
        await allDateOnly.toSet().difference(allavailableDate.toSet()).toList();
    difference.forEach((element) {
      print(element);
    });
    setState(() {
      _blackoutDates = difference;
    });
    setState(() {});
  }

  List<DateTime> _getAllDates() {
    DateTime now = DateTime.now();
    DateTime endDate = DateTime(
        now.year, now.month + 6, now.day); // Example range: current month
    List<DateTime> dates = [];
    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(Duration(days: 1))) {
      dates.add(date);
    }
    return dates;
  }

  List<DateTime> _getAvailableDates() {
    List<DateTime> availableDates = [];
    for (var availability in widget.doctorDetail.data!.availability!.toList()) {
      if (availability.times != null && availability.times!.isNotEmpty) {
        availableDates.addAll(_parseDates(availability.day.toString()));
      }
    }
    return availableDates;
  }

  List<DateTime> _parseDates(String day) {
    List<DateTime> dates = [];
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    int dayOffset = _getDayOffset(day);

    int weeksInSixMonths = (DateTime.now()
                .add(Duration(days: 183))
                .difference(DateTime.now())
                .inDays /
            7)
        .ceil();
    for (int i = 0; i < weeksInSixMonths; i++) {
      dates.add(startOfWeek.add(Duration(days: dayOffset + (i * 7))));
    }
    return dates;
  }

  int _getDayOffset(String day) {
    switch (day) {
      case 'Monday':
        return 0;
      case 'Tuesday':
        return 1;
      case 'Wednesday':
        return 2;
      case 'Thursday':
        return 3;
      case 'Friday':
        return 4;
      case 'Saturday':
        return 5;
      case 'Sunday':
        return 6;
      default:
        return 0;
    }
  }

  List<String> _getTimeSlotsForDate(DateTime date) {
    List<String> timeSlots = [];
    final dayName = DateFormat('EEEE').format(date);

    // Find availability for the selected day
    for (var availability in widget.doctorDetail.data!.availability!) {
      if (availability.day != null &&
          availability.day!.toLowerCase() == dayName.toLowerCase()) {
        if (availability.times != null && availability.times!.isNotEmpty) {
          // Parse times like "09:00-12:00" or "14:00-17:00"
          final times =
              availability.times!.split(',').map((t) => t.trim()).toList();
          for (var timeRange in times) {
            if (timeRange.contains('-')) {
              final parts = timeRange.split('-');
              if (parts.length == 2) {
                final startTime = _formatTime(parts[0].trim());
                final endTime = _formatTime(parts[1].trim());
                timeSlots.add('$startTime - $endTime');
              }
            }
          }
        }
        break;
      }
    }
    return timeSlots;
  }

  Set<String> _getBookedTimeSlotsForDate(DateTime date) {
    final bookedTimes = <String>{};
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final bookings = widget.doctorDetail.data?.bookings ?? [];
    for (final booking in bookings) {
      if (booking.date == dateKey && booking.times != null) {
        for (final time in booking.times!) {
          bookedTimes.add(_formatTimeRange(time));
        }
      }
    }
    return bookedTimes;
  }

  String _formatTimeRange(String timeRange) {
    if (!timeRange.contains('-')) {
      return timeRange;
    }
    final parts = timeRange.split('-');
    if (parts.length != 2) {
      return timeRange;
    }
    final startTime = _formatTime(parts[0].trim());
    final endTime = _formatTime(parts[1].trim());
    return '$startTime - $endTime';
  }

  String _formatTime(String time24) {
    try {
      // Parse 24-hour format (e.g., "09:00" or "14:00")
      final parts = time24.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        String period = hour >= 12 ? 'PM' : 'AM';
        int hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$hour12:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      // If parsing fails, return as is
    }
    return time24;
  }

  // void selectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   // Handle selection change
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Book Appointment',
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date',
                  style: CustomTextStyles.w600TextStyle(
                      color: AppColors.darkBlueColor, size: 20)),
              SizedBox(
                height: 2.h,
              ),
              SfDateRangePicker(
                minDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                maxDate: DateTime(DateTime.now().year, DateTime.now().month + 4,
                    DateTime.now().day),
                enablePastDates: false,
                onSelectionChanged: selectionChanged,
                showNavigationArrow: true,
                backgroundColor: AppColors.lightishBlueColorebf,
                todayHighlightColor: Colors.transparent,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4B5563)),
                  blackoutDateTextStyle: TextStyle(
                      color: AppColors.redColor,
                      decoration: TextDecoration.lineThrough),

                  textStyle: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4B5563)), // Style for the day numbers
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  blackoutDates: _blackoutDates,
                  dayFormat: 'EEE',
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4B5563))),
                ),
                selectionColor: AppColors.darkBlueColor,
                selectionTextStyle: TextStyle(color: Colors.white),
                selectionShape: DateRangePickerSelectionShape.rectangle,
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.left,
                  textStyle: TextStyle(
                      color: Color(0xff111928),
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  backgroundColor: AppColors.lightishBlueColorebf,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text('Select Hour',
                  style: CustomTextStyles.w600TextStyle(
                      color: AppColors.darkBlueColor, size: 20)),
              SizedBox(
                height: 2.h,
              ),
              TimeSelector(
                times: selectedDate == null
                    ? []
                    : _getTimeSlotsForDate(selectedDate!),
                bookedTimes: selectedDate == null
                    ? <String>{}
                    : _getBookedTimeSlotsForDate(selectedDate!),
                onTimeSelected: (value) {
                  setState(() {
                    timeSelection = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 24.0, top: 8.0, left: 16.0, right: 16.0),
        child: Obx(
          () => RoundedButtonSmall(
            showLoader: _doctorController.createAppointmentLoader.value,
            text: "Confirm",
            onPressed: () {
              if (timeSelection == null || _date.isEmpty) {
                showErrorMessage(context, 'Please select date and time');
              } else {
                final selectedTimeSlots = _getTimeSlotsForDate(selectedDate!);
                if (selectedTimeSlots.contains(timeSelection)) {
                  // Extract just the time part (e.g., "9:00 AM" from "9:00 AM - 12:00 PM")
                  String timeForApi = timeSelection!.split(' - ')[0];
                  
                  // Convert gender to uppercase (Male -> MALE, Female -> FEMALE)
                  String genderForApi = widget.gender;
                  if (genderForApi.toLowerCase() == 'male') {
                    genderForApi = 'MALE';
                  } else if (genderForApi.toLowerCase() == 'female') {
                    genderForApi = 'FEMALE';
                  }
                  
                  // Get doctor ID - use _id from API response
                  final doctorId = widget.doctorDetail.data!.userId?.toString() ?? '';
                  if (doctorId.isEmpty || doctorId == 'null') {
                    showErrorMessage(context, 'Doctor ID is missing');
                    return;
                  }
                  
                  _doctorController.createAppoinemntWithDoctor(
                    '',
                    doctorId,
                    _date, // Already in YYYY-MM-DD format
                    timeForApi, // Just the start time
                    widget.complain,
                    widget.symptoms,
                    widget.location,
                    'PENDING', // Use uppercase as per API
                    widget.age,
                    genderForApi, // Uppercase format (MALE/FEMALE)
                    widget.patientName,
                    widget.certificateUrl,
                    widget.doctorDetail.data!.name.toString(),
                    context);
                } else {
                  showErrorMessage(context, 'Doctor not available');
                }
              }
            },
            backgroundColor: AppColors.darkBlueColor,
            textColor: AppColors.whiteColor),
        ),
      ),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final List<String> times;
  final Set<String> bookedTimes;
  final Function(String) onTimeSelected; // Callback function to notify parent

  const TimeSelector(
      {Key? key,
      required this.times,
      required this.bookedTimes,
      required this.onTimeSelected})
      : super(key: key);

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  late String _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.times.isEmpty
          ? Container(
              child: Text(
                'No Times Available',
                style: CustomTextStyles.darkTextStyle(color: Colors.white),
              ),
            )
          : Container(
              child: Wrap(
                spacing: 20,
                runSpacing: 15,
                children: List.generate(widget.times.length, (index) {
                  String time = widget.times[index];
                  bool isSelected = _selectedTime == time;
                  final isBooked = widget.bookedTimes.contains(time);

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () {
                      setState(() {
                        _selectedTime = time;
                      });
                      widget.onTimeSelected(
                          time); // Notify parent of selected time
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 10),
                          decoration: BoxDecoration(
                            color: isBooked
                                ? AppColors.lightGreyColor
                                : isSelected
                                    ? AppColors.darkBlueColor
                                    : AppColors.whiteColorf9f,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(time,
                              style: CustomTextStyles.w600TextStyle(
                                  size: 14,
                                  color: isBooked
                                      ? AppColors.borderColor
                                      : isSelected
                                          ? AppColors.whiteColor
                                          : Color(0xff6b7280))),
                        ),
                        if (isBooked)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 10,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
