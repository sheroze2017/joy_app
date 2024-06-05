import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../styles/custom_textstyle.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                  style: CustomTextStyles.darkHeadingTextStyle(),
                ),
                Text(
                  description,
                  style: CustomTextStyles.lightTextStyle(),
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
              style: CustomTextStyles.darkHeadingTextStyle(size: 14))
        ],
      ),
    );
  }
}
