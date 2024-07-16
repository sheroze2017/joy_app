import 'package:shared_preferences/shared_preferences.dart';

String getElapsedTime(String createdTimeString) {
  DateTime createdTime;
  if (createdTimeString.isEmpty) {
    createdTime = DateTime.now();
  } else {
    createdTime = DateTime.parse(createdTimeString) ?? DateTime.now();
  }

  DateTime now = DateTime.now();
  Duration difference = now.difference(createdTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} day(s) ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour(s) ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute(s) ago';
  } else {
    return 'Just now';
  }
}

setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('deviceToken', token);
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('deviceToken') ?? '';
}
