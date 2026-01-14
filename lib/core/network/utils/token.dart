import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';

Future<String?> getToken() async {
  try {
    final user = await getCurrentUser();
    if (user != null) {
      if (user.token != null && user.token!.isNotEmpty) {
        print('✅ [getToken] Token retrieved successfully: ${user.token!.substring(0, 20)}...');
        return user.token;
      } else {
        print('⚠️ [getToken] User exists but token is null or empty');
        print('⚠️ [getToken] User ID: ${user.userId}, Name: ${user.firstName}');
      }
    } else {
      print('⚠️ [getToken] No user found in storage');
    }
    return null;
  } catch (e) {
    print('❌ [getToken] Error retrieving token: $e');
    print('❌ [getToken] Stack trace: ${StackTrace.current}');
    return null;
  }
}
