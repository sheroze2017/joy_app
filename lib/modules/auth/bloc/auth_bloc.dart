import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/auth/models/blood_bank_register_model.dart';
import 'package:joy_app/modules/auth/models/doctor_register_model.dart';
import 'package:joy_app/modules/auth/models/hospital_resgister_model.dart';
import 'package:joy_app/modules/auth/models/user_register_model.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/view/home/navbar.dart';

import '../../../core/network/request.dart';
import '../models/pharmacy_register_model.dart';
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

  saveUserDetailInLocal(
      int userId,
      String firstName,
      String email,
      String password,
      String image,
      String userRole,
      String authType,
      String phone,
      String lastName,
      String deviceToken) async {
    var user = User(
        userId: userId,
        firstName: firstName,
        email: email,
        password: password,
        userRole: userRole,
        authType: authType,
        phone: phone,
        lastName: lastName,
        deviceToken: deviceToken);
    await Hive.openBox<User>('users');
    final userBox = await Hive.openBox<User>('users');
    await userBox.put('current_user', user);
  }

  Future<LoginModel> login(
      String email, String password, BuildContext context) async {
    loginLoader.value = true;
    try {
      LoginModel response = await authApi.login(email, password);
      if (response.data != null) {
        showSuccessMessage(context, 'Login Successfully');
        saveUserDetailInLocal(
            response.data!.userId!,
            response.data!.name.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());

        handleUserRoleNavigation(response.data!.userRole!);
      } else {
        showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      loginLoader.value = false;

      throw (error);
    } finally {
      loginLoader.value = false;
    }
  }

  Future<bool> isValidMail(String email, BuildContext context) async {
    try {
      registerLoader.value = true;
      var response = await authApi.isValidEmail(
        email,
      );
      if (response == 400) {
        return true;
        // showSuccessMessage(context, 'Register Successfully');
      } else {
        showErrorMessage(context, 'User Already Exist');
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }

  Future<bool> userRegister(
      firstName,
      location,
      phoneNo,
      deviceToken,
      authType,
      userRole,
      String email,
      String password,
      dob,
      gender,
      BuildContext context) async {
    try {
      registerLoader.value = true;
      UserRegisterModel response = await authApi.userRegister(
          firstName,
          email,
          password,
          location,
          deviceToken,
          dob,
          gender,
          phoneNo,
          authType,
          userRole);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!,
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        showErrorMessage(context, response.message.toString());
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }

  Future<bool> doctorRegister(
      firstName,
      location,
      phoneNo,
      deviceToken,
      authType,
      userRole,
      String email,
      String password,
      gender,
      expertise,
      qualification,
      documentUrl,
      consultationFees,
      BuildContext context) async {
    try {
      registerLoader.value = true;
      DoctorRegisterModel response = await authApi.doctorRegister(
          firstName,
          email,
          password,
          location,
          deviceToken,
          gender,
          phoneNo,
          authType,
          userRole,
          expertise,
          consultationFees,
          qualification,
          documentUrl);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!,
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        showErrorMessage(context, response.message.toString());
        return false;
      }

      // return response;
    } catch (error) {
      registerLoader.value = false;

      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }

  Future<bool> bloodBankRegister(
      name,
      email,
      password,
      location,
      deviceToken,
      phoneNo,
      authType,
      userRole,
      lat,
      long,
      placeId,
      BuildContext context) async {
    try {
      registerLoader.value = true;

      BloodBankRegisterModel response = await authApi.bloodBankRegister(
          name,
          email,
          password,
          location,
          deviceToken,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!,
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        showErrorMessage(context, response.message.toString());
        return false;
      }
    } catch (error) {
      registerLoader.value = false;

      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }

  Future<bool> PharmacyRegister(
      name,
      email,
      password,
      location,
      deviceToken,
      phoneNo,
      authType,
      userRole,
      lat,
      long,
      placeId,
      BuildContext context) async {
    try {
      registerLoader.value = true;

      PharmacyRegisterModel response = await authApi.PharmacyRegister(
          name,
          email,
          password,
          location,
          deviceToken,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!,
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());

        showSuccessMessage(context, 'Register Successfully');

        return true;
      } else {
        showErrorMessage(context, response.message.toString());
        return false;
      }
    } catch (error) {
      registerLoader.value = false;

      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }

  Future<List<dynamic>> HospitalRegister(
      name,
      email,
      password,
      location,
      deviceToken,
      phoneNo,
      authType,
      userRole,
      lat,
      long,
      placeId,
      instituteType,
      about,
      checkupFee,
      BuildContext context) async {
    try {
      registerLoader.value = true;

      HospitalRegisterModel response = await authApi.hospitalRegister(
          name,
          email,
          password,
          location,
          deviceToken,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId,
          instituteType,
          about,
          checkupFee);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!,
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Register Successfully');
        return [true, response.data!.hospitalDetailId];
      } else {
        showErrorMessage(context, response.message.toString());
        return [false];
      }
    } catch (error) {
      registerLoader.value = false;

      throw (error);
    } finally {
      registerLoader.value = false;
    }
  }
}
