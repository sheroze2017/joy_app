import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/custom_message/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  bool showBackIcon;
  NotificationScreen({this.showBackIcon = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = [];

  Future<void> _handleNotification(RemoteMessage message) async {
    // Handle notification data here
    print('Notification received: ${message.notification?.title}');
    print('Notification message: ${message.notification?.body}');
    // Update your app's state to display the notification
    _showNotificationInApp(message);
  }

  void _showNotificationInApp(RemoteMessage message) {
    // Create a notification widget
    NotificationItem notificationWidget = NotificationItem(
        iconPath: 'Assets/icons/calendar-tick.svg',
        title: message.notification!.title.toString(),
        description: message.notification!.body.toString(),
        time: '');

    // Add the notification widget to your app's screen
    setState(() {
      _notifications.add(notificationWidget);
    });
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen(_handleNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        showIcon: widget.showBackIcon,
        title: 'Notification',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ThemeUtil.isDarkMode(context)
                      ? Color(0xffC5D3E3)
                      : Color(0xff4B5563),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  '${_notifications.length} New',
                  style: CustomTextStyles.w600TextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? AppColors.blackColor
                          : AppColors.whiteColor,
                      size: 14),
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
            child: ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 5);
                },
                itemBuilder: (context, index) {
                  final data = _notifications[index];
                  return NotificationItem(
                      iconPath: data.iconPath,
                      title: data.title,
                      description: data.description,
                      time: 'Just now');
                })),
      ),
    );
  }
}
