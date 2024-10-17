import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class DoctorAvailDailog extends StatefulWidget {
  final void Function(List<Set<String>>) onConfirm;
  final List<Set<String>> initialSelectedTimes; // Pass initial selected times

  const DoctorAvailDailog({
    Key? key,
    required this.onConfirm,
    required this.initialSelectedTimes, // Initialize from parent
  }) : super(key: key);

  @override
  _DoctorAvailDailogState createState() => _DoctorAvailDailogState();
}

class _DoctorAvailDailogState extends State<DoctorAvailDailog> {
  late List<Set<String>> selectedTimesPerDay; // Initialize with the passed list
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> times = [
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
    '09:00 PM'
  ];

  int selectedDayIndex = 0; //

  @override
  void initState() {
    super.initState();
    // Initialize selectedTimesPerDay from the parent or empty if none is passed
    selectedTimesPerDay = widget.initialSelectedTimes.isNotEmpty
        ? widget.initialSelectedTimes
        : List.generate(7, (_) => <String>{});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Day',
                style: CustomTextStyles.w600TextStyle(
                    color: Theme.of(context).primaryColorDark),
              ),
              SizedBox(width: 3.w),
              SvgPicture.asset('Assets/icons/dropdown.svg'),
            ],
          ),
          SizedBox(height: 3.h),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(daysOfWeek.length, (index) {
              final isSelected = index == selectedDayIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDayIndex = index;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColorDark
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6.17),
                    border: Border.all(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  child: Text(
                    daysOfWeek[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.7,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Hour',
                style: CustomTextStyles.w600TextStyle(
                    color: Theme.of(context).primaryColorDark),
              ),
              SizedBox(width: 3.w),
              SvgPicture.asset('Assets/icons/dropdown.svg'),
            ],
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10.0,
              runSpacing: 10.0,
              children: times.map((time) {
                final isSelected =
                    selectedTimesPerDay[selectedDayIndex].contains(time);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedTimesPerDay[selectedDayIndex].remove(time);
                      } else {
                        selectedTimesPerDay[selectedDayIndex].add(time);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColorDark
                          : Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(6.17),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.7,
                        color: isSelected
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Color(0xff6B7280),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RoundedButtonSmall(
                text: "Confirm",
                onPressed: () {
                  // Pass selected times to the callback function
                  widget.onConfirm(selectedTimesPerDay);
                  Navigator.pop(context);
                },
                backgroundColor: ThemeUtil.isDarkMode(context)
                    ? Color(0xffC5D3E3)
                    : Color(0xff1C2A3A),
                textColor: ThemeUtil.isDarkMode(context)
                    ? Color(0xff121212)
                    : Color(0xffFFFFFF),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
