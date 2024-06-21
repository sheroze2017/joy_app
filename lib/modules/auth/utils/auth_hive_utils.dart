import 'package:hive/hive.dart';

import '../models/user.dart';

void saveUser(User user) async {
  final userBox = await Hive.openBox<User>('users');
  await userBox.put('current_user', user);
}

Future<User?> getCurrentUser() async {
  final userBox = await Hive.openBox<User>('users');
  return userBox.get('current_user');
}

void closeHiveBox() async {
  await Hive.close();
}

void clearUserInformation() async {
  final userBox = await Hive.openBox<User>('users');
  await userBox.clear();
}
