import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_bloc.dart';
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
  DateTime? selectedDate;
  String? timeSelection;

  //List<DateTime> _availableDates = [];
  List<DateTime> _blackoutDates = [];
  List<List<String>> availabilityTimes = [];
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {
        _date = DateFormat('MMMM dd, yyyy').format(args.value).toString();
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
                times: selectedDate == null
                    ? []
                    : _doctorController
                        .daysAvailable.value[selectedDate!.weekday - 1],
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
                            if (availabilityTimes[selectedDate!.weekday - 1]
                                .contains(timeSelection)) {
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
                            } else {
                              showErrorMessage(context, 'Doctor not available');
                            }
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
    _selectedTime = '';
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
