import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/view/home/navbar.dart';

import '../../../core/network/request.dart';
import '../models/user.dart';
import '../utils/route.dart';

class AuthController extends GetxController {
  late DioClient dioClient;
  late AuthApi authApi;
  var loginLoader = false.obs;
  var registerLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    authApi = AuthApi(dioClient);
  }

  Future<LoginModel> login(
      String email, String password, BuildContext context) async {
    loginLoader.value = true;
    try {
      LoginModel response = await authApi.login(email, password, '4', '1');
      if (response.data != null) {
        showSuccessMessage(context, 'Login Successfully');
        var user = User(
          userId: response.data!.userId!.toInt(),
          firstName: response.data!.firstName.toString(),
          email: response.data!.email.toString(),
          password: response.data!.password.toString(),
          image: response.data!.image.toString(),
          userRole: response.data!.userRole!.toInt(),
          authType: response.data!.authType!.toInt(),
          phone: response.data!.phone.toString(),
          lastName: response.data!.lastName.toString(),
          deviceToken: response.data!.deviceToken.toString(),
        );
        await Hive.openBox<User>('users');

        final userBox = await Hive.openBox<User>('users');
        await userBox.put('current_user', user);

        handleUserRoleNavigation(response.data!.userRole!);
      } else {
        showSuccessMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      loginLoader.value = false;

      throw (error);
    } finally {
      loginLoader.value = false;
    }
  }

  Future<LoginModel> register(
      firstName,
      lastName,
      about,
      location,
      phoneNo,
      associatedHospital,
      deviceToken,
      authType,
      userRole,
      String email,
      String password,
      BuildContext context) async {
    try {
      registerLoader.value = true;
      LoginModel response = await authApi.register(
          firstName,
          lastName,
          about,
          location,
          phoneNo,
          associatedHospital,
          deviceToken,
          email,
          password,
          authType,
          userRole);
      if (response.data != null) {
        showSuccessMessage(context, 'Register Successfully');
      } else {
        showErrorMessage(context, response.message.toString());
      }
      registerLoader.value = false;

      return response;
    } catch (error) {
      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }
}
