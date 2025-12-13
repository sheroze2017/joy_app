import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/auth/models/blood_bank_register_model.dart';
import 'package:joy_app/modules/auth/models/doctor_register_model.dart';
import 'package:joy_app/modules/auth/models/hospital_resgister_model.dart';
import 'package:joy_app/modules/auth/models/user_register_model.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/network/request.dart';
import '../models/pharmacy_register_model.dart';
import '../models/user.dart';
import '../utils/route.dart';

class AuthController extends GetxController {
  late DioClient dioClient;
  late AuthApi authApi;
  var isLoading = false.obs;
  var city = ''.obs;
  var area = ''.obs;
  String fcmToken = '';

  var loginLoader = false.obs;
  var registerLoader = false.obs;

  final _profileController = Get.put(ProfileController());
  final _hospitalDetailController = Get.find<HospitalDetailController>();

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    authApi = AuthApi(dioClient);
    settoken();
  }

  settoken() async {
    fcmToken = await getToken();
    print(fcmToken);
  }

  saveUserDetailInLocal(
      String userId, // Changed to String to store MongoDB ObjectId
      String firstName,
      String email,
      String password,
      String image,
      String userRole,
      String authType,
      String phone,
      String lastName,
      String deviceToken) async {
    var user = UserHive(
        userId: userId,
        firstName: firstName,
        email: email,
        image: image,
        password: password,
        userRole: userRole,
        authType: authType,
        phone: phone,
        lastName: lastName,
        deviceToken: deviceToken);
    // Use the safe box opening function from auth_hive_utils
    final userBox = await Hive.openBox<UserHive>('users');
    await userBox.put('current_user', user);
    _profileController.updateUserDetal();
  }

  Future<bool> editUser(
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
      BuildContext context,
      image) async {
    UserHive? currentUser = await getCurrentUser();

    try {
      registerLoader.value = true;
      UserRegisterModel response = await authApi.editUser(
          currentUser!.userId.toString(),
          firstName,
          email,
          password,
          location,
          fcmToken,
          dob,
          gender,
          phoneNo,
          image);
      if (response.data != null) {
        saveUserDetailInLocal(
          response.data!.userId!.toString(),
          response.data!.name!.toString(),
          email,
          password,
          response.data!.image.toString(),
          response.data!.userRole.toString(),
          response.data!.authType.toString(),
          response.data!.phone.toString(),
          '',
          response.data!.deviceToken.toString(),
        );
        showSuccessMessage(context, 'Edit Successfully');
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

  // Step 2: Complete user profile (for new signups)
  Future<bool> completeUserProfile(
      String userId,
      firstName,
      location,
      phoneNo,
      authType,
      String email,
      String password,
      dob,
      gender,
      BuildContext context,
      image,
      aboutMe) async {
    try {
      registerLoader.value = true;
      UserRegisterModel response = await authApi.editUser(
          userId,
          firstName,
          email,
          password,
          location,
          fcmToken,
          dob,
          gender,
          phoneNo,
          image,
          profileCompleted: true);
      if (response.data != null) {
        saveUserDetailInLocal(
          response.data!.userId!.toString(),
          response.data!.name!.toString(),
          email,
          password,
          response.data!.image.toString(),
          response.data!.userRole.toString(),
          response.data!.authType.toString(),
          response.data!.phone.toString(),
          '',
          response.data!.deviceToken.toString(),
        );
        showSuccessMessage(context, 'Profile Completed Successfully');
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

  // Step 2: Complete pharmacy profile (for new signups)
  Future<bool> completePharmacyProfile(
      String userId,
      name,
      email,
      password,
      location,
      phoneNo,
      authType,
      lat,
      long,
      placeId,
      BuildContext context,
      image) async {
    try {
      registerLoader.value = true;
      PharmacyRegisterModel response = await authApi.editPharmacy(
          userId,
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          lat,
          long,
          placeId,
          image,
          profileCompleted: true);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Profile Completed Successfully');
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

  // Step 2: Complete blood bank profile (for new signups)
  Future<bool> completeBloodBankProfile(
      String userId,
      name,
      email,
      password,
      location,
      phoneNo,
      authType,
      lat,
      long,
      placeId,
      BuildContext context,
      image) async {
    try {
      registerLoader.value = true;
      BloodBankRegisterModel response = await authApi.editBloodBank(
          userId,
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          placeId,
          lat,
          long,
          image,
          profileCompleted: true);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Profile Completed Successfully');
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

  // Step 2: Complete hospital profile (for new signups)
  Future<bool> completeHospitalProfile(
      String userId,
      name,
      email,
      password,
      location,
      phoneNo,
      authType,
      lat,
      long,
      placeId,
      instituteType,
      about,
      checkupFee,
      BuildContext context,
      image) async {
    try {
      registerLoader.value = true;
      HospitalRegisterModel response = await authApi.editHospital(
          userId,
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          lat,
          long,
          placeId,
          instituteType,
          about,
          checkupFee,
          image,
          profileCompleted: true);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Profile Completed Successfully');
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

  Future<bool> editBloodBank(
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
      BuildContext context,
      image) async {
    UserHive? currentUser = await getCurrentUser();

    try {
      registerLoader.value = true;

      BloodBankRegisterModel response = await authApi.editBloodBank(
          currentUser!.userId.toString(),
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          placeId,
          lat,
          long,
          image);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Profile Edit Successfully');
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

  Future<bool> editPharmacy(
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
      BuildContext context,
      image) async {
    UserHive? currentUser = await getCurrentUser();

    try {
      registerLoader.value = true;

      PharmacyRegisterModel response = await authApi.editPharmacy(
          currentUser!.userId.toString(),
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          lat,
          long,
          placeId,
          image);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());

        showSuccessMessage(context, 'Profile Edit Successfully');

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

  Future<List<dynamic>> editHospital(
      name,
      email,
      password,
      location,
      deviceToken,
      phoneNo,
      placeId,
      lat,
      long,
      checkupFee,
      about,
      instituteType,
      BuildContext context,
      image) async {
    UserHive? currentUser = await getCurrentUser();

    try {
      registerLoader.value = true;

      HospitalRegisterModel response = await authApi.editHospital(
          currentUser!.userId.toString(),
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          lat,
          long,
          placeId,
          instituteType,
          about,
          checkupFee,
          image);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        _hospitalDetailController.getHospitalDetails(
            true, response.data!.userId.toString(), context);
        showSuccessMessage(context, 'Edit successfully');
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

  Future<LoginModel> login(
      String email, String password, BuildContext context, authType) async {
    loginLoader.value = true;
    try {
      LoginModel response = await authApi.login(email, password, authType);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Login failed';
        print('❌ [AuthController] login() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return response;
      }
      
      if (response.data != null && response.data!.userId != null) {
        String userIdString = response.data!.userId.toString(); // Ensure it's a string
        print('✅ [AuthController] login() Saving user with ID: $userIdString');
        saveUserDetailInLocal(
            userIdString,
            response.data!.name?.toString() ?? '',
            email,
            password,
            response.data!.image?.toString() ?? '',
            response.data!.userRole?.toString() ?? 'USER',
            response.data!.authType?.toString() ?? 'EMAIL',
            response.data!.phone?.toString() ?? '',
            '',
            response.data!.deviceToken?.toString() ?? '');

        showSuccessMessage(context, 'Login Successfully');

        // Navigate to dashboard after successful login
        print('✅ [AuthController] login() Navigating to dashboard');
        Future.delayed(Duration(milliseconds: 500), () {
          handleUserRoleNavigation(response.data!.userRole ?? 'USER');
        });
      } else {
        String errorMessage = response.message ?? 'Login failed - no user data returned';
        print('❌ [AuthController] login() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
      }
      return response;
    } catch (error) {
      loginLoader.value = false;
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      print('❌ [AuthController] login() Exception: $errorMessage');
      showErrorMessage(context, errorMessage);
      rethrow;
    } finally {
      loginLoader.value = false;
    }
  }

  Future<bool> checkEmailAvailable(String email, BuildContext context) async {
    try {
      registerLoader.value = true;
      var response = await authApi.checkEmail(email);
      bool isAvailable = response['data']?['available'] ?? false;
      if (isAvailable) {
        print('✅ [AuthController] Email is available');
        return true;
      } else {
        showErrorMessage(context, response['message'] ?? 'Email already registered');
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      showErrorMessage(context, 'Error checking email availability');
      return false;
    } finally {
      registerLoader.value = false;
    }
  }

  // Legacy method for backward compatibility
  Future<bool> isValidMail(String email, BuildContext context) async {
    return await checkEmailAvailable(email, context);
  }

  // Step 1: Create base user with minimal fields
  Future<String?> userSignupStep1(
    String name,
    String email,
    String password,
    String userRole,
    String authType,
    BuildContext context,
  ) async {
    try {
      registerLoader.value = true;
      UserRegisterModel response = await authApi.userSignup(
        name,
        email,
        password,
        userRole,
        authType,
      );
      if (response.data != null) {
        // Return the user_id (backend may return _id or user_id)
        String userId = response.data!.userId?.toString() ?? '';
        if (userId.isEmpty && response.data != null) {
          // Try to get _id from response if user_id is not available
          // This handles backend returning _id instead of user_id
          userId = response.data!.userId?.toString() ?? '';
        }
        return userId;
      } else {
        showErrorMessage(context, response.message?.toString() ?? 'Signup failed');
        return null;
      }
    } catch (error) {
      registerLoader.value = false;
      showErrorMessage(context, 'Signup failed: ${error.toString()}');
      return null;
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
      BuildContext context,
      image,
      aboutMe) async {
    try {
      registerLoader.value = true;
      UserRegisterModel response = await authApi.userRegister(
          firstName,
          email,
          password,
          location,
          fcmToken,
          dob,
          gender,
          phoneNo,
          authType,
          userRole,
          image,
          aboutMe);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Registration failed';
        print('❌ [AuthController] userRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
      
      if (response.data != null && response.data!.userId != null) {
        // Store MongoDB ObjectId as string (don't convert to int)
        String userIdString = response.data!.userId.toString();
        
        print('✅ [AuthController] userRegister() Saving user:');
        print('   - MongoDB ObjectId: $userIdString');
        print('   - Name: ${response.data!.name}');
        print('   - Email: $email');
        print('   - Role: ${response.data!.userRole}');
        
        saveUserDetailInLocal(
          userIdString,
          response.data!.name!.toString(),
          email,
          password,
          response.data!.image?.toString() ?? '',
          response.data!.userRole?.toString() ?? 'USER',
          response.data!.authType?.toString() ?? 'EMAIL',
          response.data!.phone?.toString() ?? '',
          '',
          response.data!.deviceToken?.toString() ?? '',
        );
        
        // Navigate to dashboard after successful registration
        print('✅ [AuthController] userRegister() Navigating to dashboard');
        Future.delayed(Duration(milliseconds: 500), () {
          handleUserRoleNavigation(response.data!.userRole ?? 'USER');
        });
        
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        String errorMessage = response.message ?? 'Registration failed - no user data returned';
        print('❌ [AuthController] userRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      print('❌ [AuthController] userRegister() Exception: $errorMessage');
      showErrorMessage(context, errorMessage);
      return false;
    } finally {
      registerLoader.value = false;
    }
  }

  Future<bool> doctorRegister(
      dateAvail,
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
      BuildContext context,
      image,
      aboutMe) async {
    try {
      registerLoader.value = true;
      DoctorRegisterModel response = await authApi.doctorRegister(
          firstName,
          email,
          password,
          location,
          fcmToken,
          gender,
          phoneNo,
          authType,
          userRole,
          expertise,
          consultationFees,
          qualification,
          documentUrl,
          image,
          aboutMe);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Doctor registration failed';
        print('❌ [AuthController] doctorRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
      
      if (response.data != null) {
        await saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());

        List<String> monday = dateAvail[0].toList();
        List<String> tuesday = dateAvail[1].toList();
        List<String> wednesday = dateAvail[2].toList();
        List<String> thursday = dateAvail[3].toList();
        List<String> friday = dateAvail[4].toList();
        List<String> saturday = dateAvail[5].toList();
        List<String> sunday = dateAvail[6].toList();

        await authApi.AddDoctorAvailability(response.data!.userId.toString(),
            monday, tuesday, wednesday, thursday, friday, saturday, sunday);
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        String errorMessage = response.message ?? 'Doctor registration failed - no user data returned';
        print('❌ [AuthController] doctorRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      print('❌ [AuthController] doctorRegister() Exception: $errorMessage');
      showErrorMessage(context, errorMessage);
      return false;
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
      BuildContext context,
      image) async {
    try {
      registerLoader.value = true;

      BloodBankRegisterModel response = await authApi.bloodBankRegister(
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId,
          image);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Blood bank registration failed';
        print('❌ [AuthController] bloodBankRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
      
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
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
        String errorMessage = response.message ?? 'Blood bank registration failed - no user data returned';
        print('❌ [AuthController] bloodBankRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      print('❌ [AuthController] bloodBankRegister() Exception: $errorMessage');
      showErrorMessage(context, errorMessage);
      return false;
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
      BuildContext context,
      image) async {
    try {
      registerLoader.value = true;

      PharmacyRegisterModel response = await authApi.PharmacyRegister(
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId,
          image);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Pharmacy registration failed';
        print('❌ [AuthController] PharmacyRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
      
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
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
        String errorMessage = response.message ?? 'Pharmacy registration failed - no user data returned';
        print('❌ [AuthController] PharmacyRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
    } catch (error) {
      registerLoader.value = false;
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      print('❌ [AuthController] PharmacyRegister() Exception: $errorMessage');
      showErrorMessage(context, errorMessage);
      return false;
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
      BuildContext context,
      image) async {
    try {
      registerLoader.value = true;

      HospitalRegisterModel response = await authApi.hospitalRegister(
          name,
          email,
          password,
          location,
          fcmToken,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId,
          instituteType,
          about,
          checkupFee,
          image);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Hospital registration failed';
        print('❌ [AuthController] HospitalRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return [false];
      }
      
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
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
        String errorMessage = response.message ?? 'Hospital registration failed - no user data returned';
        print('❌ [AuthController] HospitalRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return [false];
      }
    } catch (error) {
      registerLoader.value = false;
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      print('❌ [AuthController] HospitalRegister() Exception: $errorMessage');
      showErrorMessage(context, errorMessage);
      return [false];
    } finally {
      registerLoader.value = false;
    }
  }

  // Future<String> getCurrentLocation() async {
  // isLoading(true);
  // city.value = '';
  // area.value = '';
  // bool serviceEnabled;
  // LocationPermission permission;

  // serviceEnabled = await Geolocator.isLocationServiceEnabled();
  // if (!serviceEnabled) {
  //   Get.snackbar('Location Error', 'Location services are disabled.');
  //   isLoading(false);
  //   return '';
  // }

  // permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.deniedForever) {
  //   Get.snackbar(
  //       'Location Error', 'Location permissions are permanently denied.');
  //   isLoading(false);
  //   return '';
  // }

  // if (permission == LocationPermission.denied) {
  //   permission = await Geolocator.requestPermission();
  //   if (permission != LocationPermission.whileInUse &&
  //       permission != LocationPermission.always) {
  //     Get.snackbar('Location Error', 'Location permissions are denied.');
  //     isLoading(false);
  //     return '';
  //   }
  // }

  // try {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);

  //   Placemark placemark = placemarks[0];
  //   city.value = placemark.locality ?? '';
  //   area.value = placemark.subLocality ?? '';

  //   return area.value + ', ' + city.value;
  // } catch (e) {
  //   Get.snackbar('Location Error', 'Failed to get location: $e');
  // } finally {
  //   isLoading(false);
  //   return city.value + ' ' + area.value;
  // }
  // }

  Future signInWithGoogle(context) async {
    loginLoader.value = true;

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      login(user.user!.email.toString(), '', context, 'SOCIAL');
    } catch (e) {
      loginLoader.value = false;
      print('Error signing in with Google: $e');
      return Future.error(e);
    } finally {}
  }

  Future<UserCredential> registerWithGoogle() async {
    registerLoader.value = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      registerLoader.value = false;
      print('Error signing in with Google: $e');
      return Future.error(e);
    } finally {}
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple(context) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      login(user.user!.email.toString(), '', context, 'SOCIAL');
    } catch (e) {
      showErrorMessage(context, 'Error signing in with Apple');
      return Future.error(e);
    } finally {}
  }

  Future signInWithFacebook(context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      UserCredential user = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      login(user.user!.email.toString(), '', context, 'SOCIAL');
    } catch (e) {
      print('Error signing in with Google: $e');
      return Future.error(e);
    } finally {}
  }

  Future<UserCredential> registerWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> registerWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      print('Error signing in with Apple: $e');
      return Future.error(e);
    } finally {}
  }
}
