import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class RescheduleAppointment extends StatefulWidget {
  final String appointmentId;
  final DoctorDetail doctorDetail;

  RescheduleAppointment({
    required this.appointmentId,
    required this.doctorDetail,
  });

  @override
  State<RescheduleAppointment> createState() => _RescheduleAppointmentState();
}

class _RescheduleAppointmentState extends State<RescheduleAppointment> {
  String _date = '';
  DateTime? selectedDate;
  String? timeSelection;
  List<DateTime> _blackoutDates = [];

  final DoctorController _doctorController = Get.find<DoctorController>();

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  void _initializeDates() async {
    List<DateTime> allDates = await _getAllDates();
    List<DateTime> availableDates = await _getAvailableDates();
    List<DateTime> allDateOnly =
        allDates.map((dt) => DateTime(dt.year, dt.month, dt.day)).toList();
    List<DateTime> allavailableDate = availableDates
        .map((dt) => DateTime(dt.year, dt.month, dt.day))
        .toList();
    List<DateTime> difference =
        allDateOnly.toSet().difference(allavailableDate.toSet()).toList();
    setState(() {
      _blackoutDates = difference;
    });
  }

  List<DateTime> _getAllDates() {
    DateTime now = DateTime.now();
    DateTime endDate = DateTime(now.year, now.month + 4, now.day);
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

    int weeksInFourMonths = (DateTime.now()
                .add(Duration(days: 120))
                .difference(DateTime.now())
                .inDays /
            7)
        .ceil();
    for (int i = 0; i < weeksInFourMonths; i++) {
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

    for (var availability in widget.doctorDetail.data!.availability!) {
      if (availability.day != null &&
          availability.day!.toLowerCase() == dayName.toLowerCase()) {
        if (availability.times != null && availability.times!.isNotEmpty) {
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

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(args.value).toString();
        selectedDate = args.value;
        timeSelection = null; // Reset time selection when date changes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Reschedule Appointment',
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
                      color: Color(0xff4B5563)),
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
          () => RoundedButton(
            showLoader: _doctorController.rescheduleLoader.value,
            text: "Confirm",
            onPressed: () {
              if (timeSelection == null || _date.isEmpty) {
                showErrorMessage(context, 'Please select date and time');
              } else {
                _showConfirmationDialog();
              }
            },
            backgroundColor: AppColors.darkBlueColor,
            textColor: AppColors.whiteColor),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Reschedule'),
          content: Text(
              'Are you sure you want to reschedule this appointment to ${DateFormat('MMMM dd, yyyy').format(selectedDate!)} at $timeSelection?'),
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
                _rescheduleAppointment();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _rescheduleAppointment() async {
    if (timeSelection == null || _date.isEmpty) {
      return;
    }

    // Convert time format from "9:00 AM - 9:30 AM" to "09:00-09:30"
    String timeForApi = _convertTimeToApiFormat(timeSelection!);

    final success = await _doctorController.rescheduleAppointment(
      widget.appointmentId,
      _date,
      timeForApi,
      context,
    );

    if (success) {
      Get.back(); // Go back to appointments screen
    }
  }

  String _convertTimeToApiFormat(String timeDisplay) {
    // Convert from "9:00 AM - 9:30 AM" to "09:00-09:30"
    try {
      final parts = timeDisplay.split(' - ');
      if (parts.length == 2) {
        final startTime = _parseTimeTo24Hour(parts[0].trim());
        final endTime = _parseTimeTo24Hour(parts[1].trim());
        return '$startTime-$endTime';
      }
    } catch (e) {
      print('Error converting time: $e');
    }
    return timeDisplay;
  }

  String _parseTimeTo24Hour(String time12) {
    // Parse "9:00 AM" to "09:00"
    try {
      final parts = time12.split(' ');
      if (parts.length == 2) {
        final timePart = parts[0];
        final period = parts[1].toUpperCase();
        final timeComponents = timePart.split(':');
        if (timeComponents.length == 2) {
          int hour = int.parse(timeComponents[0]);
          int minute = int.parse(timeComponents[1]);
          if (period == 'PM' && hour != 12) {
            hour += 12;
          } else if (period == 'AM' && hour == 12) {
            hour = 0;
          }
          return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        }
      }
    } catch (e) {
      print('Error parsing time: $e');
    }
    return time12;
  }
}

// TimeSelector widget (same as in book_appointment_screen.dart)
class TimeSelector extends StatefulWidget {
  final List<String> times;
  final Set<String> bookedTimes;
  final Function(String) onTimeSelected;

  const TimeSelector({
    Key? key,
    required this.times,
    required this.bookedTimes,
    required this.onTimeSelected,
  }) : super(key: key);

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
                            widget.onTimeSelected(time);
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

