import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/notification_item.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

import '../../Widgets/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        showIcon: true,
        title: 'Notification',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff4B5563),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  '1 New',
                  style: CustomTextStyles.w600TextStyle(
                      color: Color(0xffFFFFFF), size: 14),
                ),
              ),
            ),
          )
        ],
        leading: Icon(Icons.arrow_back),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              NotificationDate(
                date: 'Today',
              ),
              NotificationItem(
                  iconPath: 'Assets/icons/calendar-edit.svg',
                  title: 'Alexa texted you',
                  description:
                      'You have successfully booked your appointment with Dr. Emily Walker.',
                  time: '2h'),
              NotificationItem(
                  iconPath: 'Assets/icons/calendar-edit.svg',
                  title: 'Alexa texted you',
                  description:
                      'You have successfully booked your appointment with Dr. Emily Walker.',
                  time: '2h'),
              NotificationItem(
                  iconPath: 'Assets/icons/calendar-edit.svg',
                  title: 'Alexa texted you',
                  description:
                      'You have successfully booked your appointment with Dr. Emily Walker.',
                  time: '2h'),
            ],
          ),
        ),
      ),
    );
  }
}
