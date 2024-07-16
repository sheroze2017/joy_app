import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:joy_app/core/network/utils/extra.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    setToken(fcmToken.toString());
    print('fcmtoken ${fcmToken}');
  }
}
