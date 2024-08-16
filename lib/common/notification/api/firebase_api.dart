import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:joy_app/core/network/utils/extra.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final fcmToken = await _firebaseMessaging.getToken();
    FirebaseMessaging.onBackgroundMessage(_handleNotification);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    setToken(fcmToken.toString());
    print('fcmtoken ${fcmToken}');
  }
}

Future<void> _handleNotification(RemoteMessage message) async {
  // Handle notification data here
  print('Notification received: ${message.notification?.title}');
  print('Notification message: ${message.notification?.body}');
  // Update your app's state to display the notification
}
