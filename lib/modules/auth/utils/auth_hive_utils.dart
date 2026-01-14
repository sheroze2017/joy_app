import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/user.dart';

Future<void> _clearCorruptedHiveBox() async {
  try {
    print('⚠️ [HiveUtils] Clearing corrupted Hive box...');
    final directory = await getApplicationDocumentsDirectory();
    final boxPath = '${directory.path}/users.hive';
    final lockPath = '${directory.path}/users.lock';
    
    // Delete the box file and lock file
    final boxFile = File(boxPath);
    final lockFile = File(lockPath);
    
    if (await boxFile.exists()) {
      await boxFile.delete();
      print('✅ [HiveUtils] Deleted corrupted box file');
    }
    if (await lockFile.exists()) {
      await lockFile.delete();
      print('✅ [HiveUtils] Deleted lock file');
    }
    
    // Also try to close and delete the box if it's already open
    try {
      if (Hive.isBoxOpen('users')) {
        await Hive.box('users').close();
      }
      await Hive.deleteBoxFromDisk('users');
      print('✅ [HiveUtils] Deleted box from Hive');
    } catch (e) {
      print('⚠️ [HiveUtils] Could not delete box from Hive (may not exist): $e');
    }
  } catch (e) {
    print('❌ [HiveUtils] Error clearing corrupted box: $e');
  }
}

Future<Box<UserHive>> _openUserBoxSafely() async {
  try {
    return await Hive.openBox<UserHive>('users');
  } catch (e) {
    // If there's a type mismatch error, clear the corrupted box
    if (e.toString().contains('is not a subtype') || 
        e.toString().contains('type cast') ||
        e.toString().contains('subtype')) {
      print('❌ [HiveUtils] Type mismatch detected: $e');
      await _clearCorruptedHiveBox();
      // Wait a bit for file system operations
      await Future.delayed(Duration(milliseconds: 100));
      // Try opening again after clearing
      return await Hive.openBox<UserHive>('users');
    }
    rethrow;
  }
}

Future<void> saveUser(UserHive user) async {
  final userBox = await _openUserBoxSafely();
  await userBox.put('current_user', user);
}

Future<UserHive?> getCurrentUser() async {
  try {
    final userBox = await _openUserBoxSafely();
    final user = userBox.get('current_user');
    
    // Log stored user details
    if (user != null) {
      print('👤 [getCurrentUser] Retrieved User from Hive:');
      print('   - UserId: ${user.userId} (type: ${user.userId.runtimeType})');
      print('   - Name: ${user.firstName}');
      print('   - Email: ${user.email}');
      print('   - Role: ${user.userRole}');
      print('   - Token: ${user.token != null ? (user.token!.length > 20 ? "${user.token!.substring(0, 20)}..." : user.token) : "null"}');
      print('   - Gender: ${user.gender ?? "null"}');
      
      // If user exists but token is null, this might be an old schema issue
      // Clear the box to force fresh login with new schema
      if (user.token == null || user.token!.isEmpty) {
        print('⚠️ [getCurrentUser] User exists but token is null - this might be an old schema. Clearing box to force fresh login.');
        await userBox.clear();
        print('✅ [getCurrentUser] Cleared Hive box - user needs to login again');
        return null;
      }
    } else {
      print('⚠️ [getCurrentUser] No user found in Hive');
    }
    
    return user;
  } catch (e) {
    print('❌ [getCurrentUser] Error reading user from Hive: $e');
    // Try to clear corrupted box one more time
    if (e.toString().contains('is not a subtype') || 
        e.toString().contains('type cast') ||
        e.toString().contains('subtype')) {
      await _clearCorruptedHiveBox();
    }
    return null;
  }
}

void closeHiveBox() async {
  await Hive.close();
}

void clearUserInformation() async {
  try {
    final userBox = await _openUserBoxSafely();
    await userBox.clear();
    print('✅ [clearUserInformation] User information cleared');
  } catch (e) {
    print('❌ [clearUserInformation] Error clearing user info: $e');
    await _clearCorruptedHiveBox();
  }
}
