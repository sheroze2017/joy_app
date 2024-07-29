import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class NotificationItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final String time;

  NotificationItem({
    required this.iconPath,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 15.38.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTextStyles.darkHeadingTextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : null),
                ),
                Text(
                  description,
                  style: CustomTextStyles.lightTextStyle(
                      size: 13,
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffAAAAAA)
                          : null),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class NotificationDate extends StatelessWidget {
  final String date;

  NotificationDate({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            date,
            style: CustomTextStyles.lightTextStyle(size: 16),
          ),
          Spacer(),
          Text('Mark all as read',
              style: CustomTextStyles.darkHeadingTextStyle(
                  color:
                      ThemeUtil.isDarkMode(context) ? Color(0xffC5D3E3) : null,
                  size: 14))
        ],
      ),
    );
  }
}
