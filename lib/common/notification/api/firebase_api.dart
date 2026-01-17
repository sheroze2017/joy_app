import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      // Request permission with provisional: true (as per Firebase guide)
      await _firebaseMessaging.requestPermission(provisional: true);
    } catch (error) {
      debugPrint('FCM permission error: $error');
    }

    String? fcmToken;
    try {
      // For iOS: Check APNS token first before getting FCM token
      if (Platform.isIOS) {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          // APNS token is available, make FCM plugin API requests
          fcmToken = await _firebaseMessaging.getToken();
        }
      } else {
        fcmToken = await _firebaseMessaging.getToken();
      }
    } catch (error) {
      debugPrint('FCM token error: $error');
    }

    if (fcmToken != null && fcmToken.isNotEmpty) {
      setToken(fcmToken);
    }

    await initLocalNotification();
    await initPushNotification();
  }
}

Future<void> _handleNotification(RemoteMessage message) async {
  // Handle notification data here
  print('');
  print('📬 [FirebaseApi] ========== BACKGROUND NOTIFICATION RECEIVED ==========');
  print('📬 [FirebaseApi] Notification Details:');
  print('   - Title: ${message.notification?.title ?? "null"}');
  print('   - Body: ${message.notification?.body ?? "null"}');
  print('   - Message ID: ${message.messageId ?? "null"}');
  print('   - Sent Time: ${message.sentTime}');
  print('   - From: ${message.from ?? "null"}');
  print('   - Collapse Key: ${message.collapseKey ?? "null"}');
  print('');
  print('📬 [FirebaseApi] Notification Data Payload:');
  if (message.data.isNotEmpty) {
    message.data.forEach((key, value) {
      print('   - $key: $value');
    });
  } else {
    print('   - No data payload');
  }
  print('');
  print('📬 [FirebaseApi] Full Message Structure:');
  print('   - Has Notification: ${message.notification != null}');
  print('   - Has Data: ${message.data.isNotEmpty}');
  print('   - Message Type: ${message.messageType ?? "null"}');
  print('📬 [FirebaseApi] ========================================================');
  print('');
}

void handleMessage(RemoteMessage? message) async {
  if (message == null) {
    print('⚠️ [FirebaseApi] handleMessage() called with null message');
    return;
  }
  
  print('');
  print('🔔 [FirebaseApi] ========== NOTIFICATION TAPPED/OPENED ==========');
  print('🔔 [FirebaseApi] Notification Details:');
  print('   - Title: ${message.notification?.title ?? "null"}');
  print('   - Body: ${message.notification?.body ?? "null"}');
  print('   - Message ID: ${message.messageId ?? "null"}');
  print('   - Sent Time: ${message.sentTime}');
  print('   - From: ${message.from ?? "null"}');
  print('');
  print('🔔 [FirebaseApi] Notification Data Payload:');
  if (message.data.isNotEmpty) {
    message.data.forEach((key, value) {
      print('   - $key: $value');
    });
  } else {
    print('   - No data payload');
  }
  print('');
  print('🔔 [FirebaseApi] Full Message JSON:');
  print('   ${jsonEncode(message.toMap())}');
  print('🔔 [FirebaseApi] ================================================');
  print('');
  
  UserHive? currentUser = await getCurrentUser();
  if (currentUser != null) {
    print('✅ [FirebaseApi] User found, navigating to: ${currentUser.userRole}');
    handleUserRoleNavigation(currentUser.userRole);
  } else {
    print('⚠️ [FirebaseApi] No user found, navigating to onboarding');
    Get.offAll(OnboardingScreen());
  }
}

// Top-level function for background notification tap handler
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  print('');
  print('👆 [FirebaseApi] ========== LOCAL NOTIFICATION TAPPED ==========');
  print('👆 [FirebaseApi] Notification Response:');
  print('   - ID: ${notificationResponse.id}');
  print('   - Action ID: ${notificationResponse.actionId ?? "null"}');
  print('   - Payload: ${notificationResponse.payload ?? "null"}');
  print('   - Input: ${notificationResponse.input ?? "null"}');
  print('👆 [FirebaseApi] ===============================================');
  print('');
  
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    try {
      final Map<String, dynamic>? payloadData = jsonDecode(payload);
      if (payloadData != null) {
        print('📦 [FirebaseApi] Parsed Payload Data:');
        payloadData.forEach((key, value) {
          print('   - $key: $value');
        });
      }
    } catch (e) {
      print('⚠️ [FirebaseApi] Failed to parse payload JSON: $e');
    }
  }
}

Future initPushNotification() async {
  // Configure foreground notification presentation for iOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  
  final _localNotification = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'This channel is use for important notifications',
      importance: Importance.defaultImportance);

  // Handle notifications when app is opened from terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print('');
      print('🚀 [FirebaseApi] ========== APP OPENED FROM TERMINATED STATE ==========');
      print('🚀 [FirebaseApi] Initial message found - app was opened via notification');
      print('🚀 [FirebaseApi] ======================================================');
      print('');
      handleMessage(message);
    } else {
      print('ℹ️ [FirebaseApi] No initial message - app opened normally');
    }
  });
  
  // Handle notifications when app is opened from background
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('');
    print('🔄 [FirebaseApi] ========== APP OPENED FROM BACKGROUND ==========');
    print('🔄 [FirebaseApi] App was in background and opened via notification');
    print('🔄 [FirebaseApi] ================================================');
    print('');
    handleMessage(message);
  });
  
  // Handle background notifications
  FirebaseMessaging.onBackgroundMessage(_handleNotification);
  
  // Handle foreground notifications - show local notification for both iOS and Android
  FirebaseMessaging.onMessage.listen((message) async {
    print('');
    print('📱 [FirebaseApi] ========== FOREGROUND NOTIFICATION RECEIVED ==========');
    print('📱 [FirebaseApi] App is in foreground - notification received');
    print('📱 [FirebaseApi] Notification Details:');
    print('   - Title: ${message.notification?.title ?? "null"}');
    print('   - Body: ${message.notification?.body ?? "null"}');
    print('   - Message ID: ${message.messageId ?? "null"}');
    print('   - Sent Time: ${message.sentTime}');
    print('   - From: ${message.from ?? "null"}');
    print('');
    print('📱 [FirebaseApi] Notification Data Payload:');
    if (message.data.isNotEmpty) {
      message.data.forEach((key, value) {
        print('   - $key: $value');
      });
    } else {
      print('   - No data payload');
    }
    print('');
    print('📱 [FirebaseApi] Full Message JSON:');
    print('   ${jsonEncode(message.toMap())}');
    print('📱 [FirebaseApi] ====================================================');
    print('');
    
    final notification = message.notification;
    if (notification == null) {
      print('⚠️ [FirebaseApi] Notification object is null, skipping local notification');
      return;
    }

    print('📲 [FirebaseApi] Displaying local notification:');
    print('   - Title: ${notification.title}');
    print('   - Body: ${notification.body}');
    print('   - Notification ID: ${notification.hashCode}');

    // Show local notification for foreground messages
    // This ensures notifications are visible on both iOS and Android when app is in foreground
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_launcher',
        playSound: true,
        enableVibration: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotification.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(message.toMap()),
    );
    
    print('✅ [FirebaseApi] Local notification displayed successfully');
  });
}

Future initLocalNotification() async {
  final _localNotification = FlutterLocalNotificationsPlugin();

  // iOS notification settings with proper permissions
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      print('');
      print('🔔 [FirebaseApi] ========== LOCAL NOTIFICATION RECEIVED (iOS) ==========');
      print('🔔 [FirebaseApi] Local Notification Details:');
      print('   - ID: $id');
      print('   - Title: $title');
      print('   - Body: $body');
      print('   - Payload: ${payload ?? "null"}');
      print('🔔 [FirebaseApi] =======================================================');
      print('');
    },
  );
  
  const android = AndroidInitializationSettings('@drawable/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: android,
    iOS: initializationSettingsDarwin,
  );

  // Create notification channel for Android
  final androidPlatform = _localNotification.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlatform?.createNotificationChannel(androidChannel);

  // Request iOS notification permissions
  final iosPlatform = _localNotification.resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>();
  if (iosPlatform != null) {
    await iosPlatform.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  await _localNotification.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is use for important notifications',
    importance: Importance.defaultImportance);
