import 'package:flutter/material.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/checkout/checkout_detail.dart';

import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../Widgets/rounded_button.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Book Appointment',
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: Padding(
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
              showNavigationArrow: true,
              backgroundColor: AppColors.lightishBlueColorebf,
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
                    color: Color(0xff4B5563)), // Style for the day numbers
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
              ],
            ),
          ],
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
                        showPaymentBottomSheet(context, true, false);
                      },
                      backgroundColor: AppColors.darkBlueColor,
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

  const TimeSelector({Key? key, required this.times}) : super(key: key);

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

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Time Selector Example'),
      ),
      body: Center(
        child: TimeSelector(
          times: [
            '8:00 AM',
            '9:00 AM',
            '10:00 AM',
            '11:00 AM',
            '12:00 PM',
            '1:00 PM',
            '2:00 PM',
            '3:00 PM',
            '4:00 PM',
          ],
        ),
      ),
    ),
  ));
}
