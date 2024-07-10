import 'package:hive/hive.dart';

import '../models/user.dart';

void saveUser(UserHive user) async {
  final userBox = await Hive.openBox<UserHive>('users');
  await userBox.put('current_user', user);
}

Future<UserHive?> getCurrentUser() async {
  final userBox = await Hive.openBox<UserHive>('users');
  return userBox.get('current_user');
}

void closeHiveBox() async {
  await Hive.close();
}

void clearUserInformation() async {
  final userBox = await Hive.openBox<UserHive>('users');
  await userBox.clear();
}
