import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';

import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/flutter_toast_message.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../../../Widgets/rounded_button.dart';
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
  String? timeSelection;
  List<DateTime> _availableDates = [];
  List<DateTime> _blackoutDates = [];

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {
        _date = DateFormat('MMMM dd, yyyy').format(args.value).toString();
      });
    });
  }

  UserDoctorController _doctorController = Get.find<UserDoctorController>();

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  void _initializeDates() async {
    List<DateTime> allDates = await _getAllDates();
    _availableDates = await _getAvailableDates();
    setState(() {
      _blackoutDates = allDates
          .where((date) => !_availableDates
              .any((availableDate) => date.day == availableDate.day))
          .toList();
    });
  }

  List<DateTime> _getAllDates() {
    DateTime now = DateTime.now();
    DateTime endDate = DateTime(
        now.year, now.month + 12, now.day); // Example range: current month
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
      if (availability.times.toString().contains('AM') ||
          availability.times.toString().contains('PM')) {
        print('dd');
        availableDates.addAll(_parseDates(availability.day.toString()));
      } else {}
    }
    return availableDates;
  }

  List<DateTime> _parseDates(String day) {
    List<DateTime> dates = [];
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    int dayOffset = _getDayOffset(day);

    for (int i = 0; i < 4; i++) {
      // Example range: 4 weeks
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
                maxDate: DateTime(DateTime.now().year, DateTime.now().month + 1,
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
                      color: AppColors.redLightColor,
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
                times: [
                  '08:00 AM',
                  '09:00 AM',
                  '10:00 AM',
                  '11:00 AM',
                  '12:00 PM',
                  '01:00 PM',
                  '02:00 PM',
                  '03:00 PM',
                  '04:00 PM',
                  '05:00 PM',
                  '06:00 PM',
                  '07:00 PM',
                  '08:00 PM',
                ],
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
      bottomNavigationBar: Stack(
        alignment: new FractionalOffset(.5, 1.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                    () => RoundedButtonSmall(
                        showLoader:
                            _doctorController.createAppointmentLoader.value,
                        text: "Confirm",
                        onPressed: () {
                          if (timeSelection == null || _date.isEmpty) {
                            showErrorMessage(
                                context, 'Please select date and time');
                          } else {
                            _doctorController.createAppoinemntWithDoctor(
                                '',
                                widget.doctorDetail.data!.userId.toString(),
                                _date,
                                timeSelection,
                                widget.complain,
                                widget.symptoms,
                                widget.location,
                                'Pending',
                                widget.age,
                                widget.gender,
                                widget.patientName,
                                widget.certificateUrl,
                                widget.doctorDetail.data!.name.toString(),
                                context);
                          }

                          // // showPaymentBottomSheet(context, true, false);
                        },
                        backgroundColor: AppColors.darkBlueColor,
                        textColor: AppColors.whiteColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final List<String> times;
  final Function(String) onTimeSelected; // Callback function to notify parent

  const TimeSelector(
      {Key? key, required this.times, required this.onTimeSelected})
      : super(key: key);

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  late String _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.times.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Wrap(
          spacing: 20,
          runSpacing: 15,
          children: List.generate(widget.times.length, (index) {
            String time = widget.times[index];
            bool isSelected = _selectedTime == time;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
                widget.onTimeSelected(time); // Notify parent of selected time
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.darkBlueColor
                      : AppColors.whiteColorf9f,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(time,
                    style: CustomTextStyles.w600TextStyle(
                        size: 14,
                        color: isSelected
                            ? AppColors.whiteColor
                            : Color(0xff6b7280))),
              ),
            );
          }),
        ),
      ),
    );
  }
}
