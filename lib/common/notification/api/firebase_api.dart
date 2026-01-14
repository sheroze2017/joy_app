import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/onboarding/onboarding_screen.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/utils/route.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (error) {
      debugPrint('FCM permission error: $error');
    }

    String? fcmToken;
    try {
      fcmToken = await _firebaseMessaging.getToken();
    } catch (error) {
      debugPrint('FCM token error: $error');
    }

    if (fcmToken != null && fcmToken.isNotEmpty) {
      setToken(fcmToken);
      debugPrint('fcmtoken $fcmToken');
    } else {
      debugPrint('FCM token unavailable, continuing without it.');
    }

    await initLocalNotification();
    await initPushNotification();
  }
}

Future<void> _handleNotification(RemoteMessage message) async {
  // Handle notification data here
  print('Notification received: ${message.notification?.title}');
  print('Notification message: ${message.notification?.body}');
  // Update your app's state to display the notification
}

void handleMessage(RemoteMessage? message) async {
  if (message == null) return;
  UserHive? currentUser = await getCurrentUser();
  if (currentUser != null) {
    handleUserRoleNavigation(currentUser.userRole);
  } else {
    Get.offAll(OnboardingScreen());
  }
}

// Top-level function for background notification tap handler
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    debugPrint('notification payload: $payload');
    // Handle the notification tap here
    // You can navigate or process the payload as needed
  }
}

Future initPushNotification() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  final _localNotification = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'This channel is use for important notifications',
      importance: Importance.defaultImportance);

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(_handleNotification);
  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_launcher')),
        payload: jsonEncode(message.toMap()));
  });
}

Future initLocalNotification() async {
  final _localNotification = FlutterLocalNotificationsPlugin();

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  const android = AndroidInitializationSettings('@drawable/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: android,
    iOS: initializationSettingsDarwin,
  );

  // Create notification channel for Android
  final androidPlatform = _localNotification.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlatform?.createNotificationChannel(androidChannel);

  await _localNotification.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is use for important notifications',
    importance: Importance.defaultImportance);
