import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/checkout/checkout_detail.dart';
import 'package:intl/intl.dart';

import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectTimingScreen extends StatefulWidget {
  SelectTimingScreen({super.key});

  @override
  State<SelectTimingScreen> createState() => _SelectTimingScreenState();
}

class _SelectTimingScreenState extends State<SelectTimingScreen> {
  String _date = DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
  String? timeSelection;

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {
        _date = DateFormat('dd, MMMM yyyy').format(args.value).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Request Blood',
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
                      color: AppColors.redColor, size: 20)),
              SizedBox(
                height: 2.h,
              ),
              SfDateRangePicker(
                onSelectionChanged: selectionChanged,
                showNavigationArrow: true,
                backgroundColor: ThemeUtil.isDarkMode(context)
                    ? Color(0xff161616)
                    : AppColors.redLightColor,
                todayHighlightColor: Colors.transparent,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4B5563)),
                  textStyle: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4B5563)),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  dayFormat: 'EEE',
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                          fontSize: 12,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4B5563))),
                ),
                selectionColor: AppColors.redColor,
                selectionShape: DateRangePickerSelectionShape.rectangle,
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.left,
                  textStyle: TextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffD7DFEE)
                          : Color(0xff111928),
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  backgroundColor: ThemeUtil.isDarkMode(context)
                      ? Color(0xff161616)
                      : AppColors.redLightColor,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text('Select Hour',
                  style: CustomTextStyles.w600TextStyle(
                      color: AppColors.redColor, size: 20)),
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
                  child: RoundedButton(
                      text: "Confirm",
                      onPressed: () {
                        DateTimeSelection selection = DateTimeSelection(
                          _date,
                          timeSelection!,
                        );

                        Navigator.pop(context, selection);
                      },
                      backgroundColor: AppColors.redColor,
                      textColor: AppColors.whiteColor),
                ),
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
                      ? AppColors.redColor
                      : ThemeUtil.isDarkMode(context)
                          ? Color(0xff121212)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(time,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isSelected ? Colors.white : Color(0xff6b7280))),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DateTimeSelection {
  final String date;
  final String time;

  DateTimeSelection(this.date, this.time);
}
