import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
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
import 'package:joy_app/modules/splash/view/splash_screen.dart';
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
    if (_isFirebaseReady()) {
      _listenForDeviceTokenRefresh();
    } else {
      print('⚠️ [AuthController] Firebase not initialized, skip FCM listener');
    }
  }

  bool _isFirebaseReady() {
    return Firebase.apps.isNotEmpty;
  }

  settoken() async {
    // Silently get token, no logs here
    if (_isFirebaseReady()) {
      try {
        if (Platform.isIOS) {
          // Request permission with provisional: true (as per Firebase guide)
          await FirebaseMessaging.instance.requestPermission(provisional: true);
          
          // Check APNS token first (as per Firebase guide)
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken == null) {
            // APNS token not available, wait a bit and try again
            await Future.delayed(Duration(seconds: 2));
          }
        }
        
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) {
          fcmToken = token;
          await setToken(token);
          return;
        }
      } catch (error) {
        // Silent error handling
      }
    }
    
    // Fallback to SharedPreferences
    fcmToken = await getToken();
  }

  void _listenForDeviceTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (newToken.isEmpty) {
        return;
      }
      
      fcmToken = newToken;
      await setToken(newToken);
      
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return;
      }
      
      final updated = await authApi.updateDeviceToken(
          currentUser.userId.toString(), newToken);
      
      if (updated && currentUser.deviceToken != newToken) {
        currentUser.deviceToken = newToken;
        await currentUser.save();
      }
    });
  }

  // Helper method to ensure FCM token is fetched from Firebase Messaging
  Future<String> _ensureFcmToken() async {
    // If already have a token, return it
    if (fcmToken.isNotEmpty) {
      return fcmToken;
    }

    // Try to get FCM token from Firebase Messaging
    if (_isFirebaseReady()) {
      try {
        if (Platform.isIOS) {
          // Request permission with provisional: true (as per Firebase guide)
          await FirebaseMessaging.instance.requestPermission(provisional: true);
          
          // Check APNS token first (as per Firebase guide)
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken == null) {
            // APNS token not available, wait a bit and try again
            await Future.delayed(Duration(seconds: 2));
          }
        }
        
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) {
          fcmToken = token;
          await setToken(token);
          return fcmToken;
        }
      } catch (error) {
        // Silent error handling
      }
    }

    // Fallback to SharedPreferences if Firebase not ready
    fcmToken = await getToken();
    return fcmToken;
  }

  Future<bool> fetchAndUpdateUserProfile(String userId) async {
    try {
      print('');
      print('🔄 [AuthController] ========== FETCHING USER PROFILE ==========');
      print('🔄 [AuthController] User ID: $userId');
      print('🔄 [AuthController] ===========================================');
      print('');
      
      UserRegisterModel response = await authApi.getProfile(userId);
      
      if (response.data != null && response.code == 200) {
        final userData = response.data!;
        final currentUser = await getCurrentUser();
        
        // Preserve the existing token when updating profile
        final existingToken = currentUser?.token;
        
        // Extract name parts (assuming name is "FirstName LastName" or just "FirstName")
        String firstName = userData.name ?? '';
        String lastName = '';
        if (firstName.contains(' ')) {
          final nameParts = firstName.split(' ');
          firstName = nameParts.first;
          lastName = nameParts.skip(1).join(' ');
        }
        
        // Save updated user data to Hive
        await saveUserDetailInLocal(
          userData.userId.toString(),
          firstName,
          userData.email ?? '',
          userData.password ?? '',
          userData.image ?? '',
          userData.userRole ?? '',
          userData.authType ?? '',
          userData.phone ?? '',
          lastName,
          userData.deviceToken ?? '',
          existingToken, // Preserve existing token
          gender: userData.gender,
        );
        
        print('');
        print('✅ [AuthController] ========== USER PROFILE UPDATED ==========');
        print('✅ [AuthController] Profile fetched and saved successfully');
        print('✅ [AuthController] =========================================');
        print('');
        
        return true;
      } else {
        print('');
        print('⚠️ [AuthController] ========== PROFILE FETCH FAILED ==========');
        print('⚠️ [AuthController] Response code: ${response.code}');
        print('⚠️ [AuthController] Message: ${response.message}');
        print('⚠️ [AuthController] ==========================================');
        print('');
        return false;
      }
    } catch (error) {
      print('');
      print('❌ [AuthController] ========== PROFILE FETCH ERROR ==========');
      print('❌ [AuthController] Error: $error');
      print('❌ [AuthController] =========================================');
      print('');
      return false;
    }
  }

  Future<void> updateDeviceTokenForUser(String userId) async {
    String token = '';
    
    // Fetch FCM token following Firebase guide
    if (_isFirebaseReady()) {
      try {
        // For iOS: Request permission with provisional: true and check APNS token first (as per Firebase guide)
        if (Platform.isIOS) {
          await FirebaseMessaging.instance.requestPermission(provisional: true);
          
          // For apple platforms, make sure the APNS token is available before making any FCM plugin API calls
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) {
            // APNS token is available, make FCM plugin API requests
            token = await FirebaseMessaging.instance.getToken() ?? '';
          } else {
            // APNS token not available - this is expected on iOS Simulator
            // On simulator, try to get token anyway (may fail, that's OK)
            try {
              await Future.delayed(Duration(seconds: 2));
              token = await FirebaseMessaging.instance.getToken() ?? '';
            } catch (e) {
              // Simulator doesn't support FCM tokens - this is expected
              print('⚠️ [AuthController] FCM token not available on iOS Simulator (this is normal)');
              token = '';
            }
          }
        } else {
          // For Android/Web, directly get FCM token
          token = await FirebaseMessaging.instance.getToken() ?? '';
        }
        
        // Log device token if fetched successfully
        if (token.isNotEmpty) {
          print('');
          print('═══════════════════════════════════════════════════════════════════════════');
          print('📱 [AuthController] ✅✅✅ DEVICE TOKEN FETCHED FROM FIREBASE ✅✅✅');
          print('═══════════════════════════════════════════════════════════════════════════');
          print('📱 [AuthController] FULL DEVICE TOKEN:');
          print('📱 [AuthController] $token');
          print('═══════════════════════════════════════════════════════════════════════════');
          print('');
        }
      } catch (error) {
        print('');
        print('❌ [AuthController] Error fetching FCM token: $error');
        print('');
      }
    }
    
    // Fallback to SharedPreferences if Firebase token not available
    if (token.isEmpty) {
      token = await getToken();
    }
    
    if (token.isEmpty) {
      print('');
      print('❌ [AuthController] Device token is empty, cannot update on backend');
      print('');
      return;
    }
    
    // Save token locally
    fcmToken = token;
    await setToken(token);
    
    // Update device token on backend
    print('');
    print('📤 [AuthController] ========== UPDATING DEVICE TOKEN ON BACKEND ==========');
    print('📤 [AuthController] User ID: $userId');
    print('📤 [AuthController] Device Token: $token');
    print('📤 [AuthController] =======================================================');
    print('');
    
    final updated = await authApi.updateDeviceToken(userId, token);
    
    print('');
    if (updated) {
      print('✅ [AuthController] ✅✅✅ DEVICE TOKEN UPDATED SUCCESSFULLY ✅✅✅');
      final currentUser = await getCurrentUser();
      if (currentUser != null && currentUser.deviceToken != token) {
        currentUser.deviceToken = token;
        await currentUser.save();
      }
    } else {
      print('❌ [AuthController] ❌❌❌ DEVICE TOKEN UPDATE FAILED ❌❌❌');
      print('❌ [AuthController] User ID: $userId');
      print('❌ [AuthController] Device Token: $token');
    }
    print('');
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
      String deviceToken,
      String? token,
      {String? gender}) async {
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
        deviceToken: deviceToken,
        token: token,
        gender: gender);
    // Use the safe box opening function from auth_hive_utils
    final userBox = await Hive.openBox<UserHive>('users');
    await userBox.put('current_user', user);
    print(
        '✅ [saveUserDetailInLocal] User saved - userId: $userId, token: ${token != null ? (token.length > 20 ? "${token.substring(0, 20)}..." : token) : "null"}, gender: $gender');
    
    // Verify token was saved correctly
    final savedUser = userBox.get('current_user');
    if (savedUser != null) {
      print(
          '✅ [saveUserDetailInLocal] Verification - Token in saved user: ${savedUser.token != null ? (savedUser.token!.length > 20 ? "${savedUser.token!.substring(0, 20)}..." : savedUser.token) : "null"}');
    } else {
      print(
          '❌ [saveUserDetailInLocal] Verification failed - User not found in box after save!');
    }
    
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
      image, {
      String? aboutMe,
      Map<String, dynamic>? originalValues,
      }) async {
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
          image,
          aboutMe: aboutMe,
          originalValues: originalValues);
      if (response.data != null) {
        // Preserve the existing token when editing profile
        final existingToken = currentUser.token;
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
          existingToken, // Preserve existing token for profile edit
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
      UserRegisterModel response = await authApi.editUser(userId, firstName,
          email, password, location, fcmToken, dob, gender, phoneNo, image,
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
          null, // No token for user signup
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
            response.data!.deviceToken.toString(),
            null); // No token for registration
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
            response.data!.deviceToken.toString(),
            null); // No token for registration
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
            response.data!.deviceToken.toString(),
            null); // No token for registration
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
      image, {
      List<Map<String, dynamic>>? availability,
      Map<String, dynamic>? originalValues,
    }) async {
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
          image,
          availability: availability,
          originalValues: originalValues);
      if (response.data != null) {
        // Preserve the existing token when editing profile
        final existingToken = currentUser.token;
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
            existingToken); // Preserve existing token for profile edit
        showSuccessMessage(context, 'Profile Edit Successfully');
        
        // Redirect to splash screen after successful edit
        Timer(Duration(milliseconds: 1500), () {
          Get.offAll(() => SplashScreen());
        });
        
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
      image,
      {List<Map<String, dynamic>>? availability,
      Map<String, dynamic>? originalValues}) async {
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
          image,
          availability: availability,
          originalValues: originalValues);
      if (response.data != null) {
        // Preserve the existing token when editing profile
        final existingToken = currentUser.token;
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
            existingToken); // Preserve existing token for profile edit

        showSuccessMessage(context, 'Profile Edit Successfully');
        
        // Redirect to splash screen after successful edit
        Timer(Duration(milliseconds: 1500), () {
          Get.offAll(() => SplashScreen());
        });

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
      image, {
      List<Map<String, dynamic>>? availability,
      Map<String, dynamic>? originalValues,
      }) async {
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
          image,
          availability: availability,
          originalValues: originalValues);
      if (response.data != null) {
        // Preserve the existing token when editing profile
        final existingToken = currentUser.token;
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
            existingToken); // Preserve existing token for profile edit
        _hospitalDetailController.getHospitalDetails(
            true, response.data!.userId.toString(), context);
        showSuccessMessage(context, 'Edit successfully');
        
        // Navigate to splash screen to reload user object
        Future.delayed(Duration(milliseconds: 1500), () {
          Get.offAll(() => SplashScreen());
        });
        
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
    print('🔐 [AuthController] login() called');
    print('   - Email: $email');
    print('   - Password: ${password.isNotEmpty ? "***" : "empty"}');
    print('   - Auth Type: $authType');
    loginLoader.value = true;
    try {
      print('🔐 [AuthController] Calling authApi.login()...');
      LoginModel response = await authApi.login(email, password, authType);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage = response.message ?? 'Login failed';
        print('❌ [AuthController] login() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return response;
      }
      
      // Debug: Check response structure
      print('🔍 [AuthController] Response structure check:');
      print('   - response.data: ${response.data != null ? "exists" : "null"}');
      print(
          '   - response.data?.token: ${response.data?.token != null ? "exists" : "null"}');
      print(
          '   - response.data?.user: ${response.data?.user != null ? "exists" : "null"}');
      if (response.data?.user != null) {
        print('   - response.data.user.userId: ${response.data!.user!.userId}');
        print('   - response.data.user.name: ${response.data!.user!.name}');
        print(
            '   - response.data.user.userRole: ${response.data!.user!.userRole}');
        print(
            '   - response.data.user.location: ${response.data!.user!.location}');
        print('   - response.data.user.status: ${response.data!.user!.status}');
      }
      
      if (response.data != null &&
          response.data!.user != null &&
          response.data!.user!.userId != null) {
        String userIdString =
            response.data!.user!.userId.toString(); // Ensure it's a string
        String? token = response.data!.token;
        String? gender = response.data!.user!.gender;
        print('✅ [AuthController] login() Saving user with ID: $userIdString');
        print(
            '✅ [AuthController] login() Token: ${token != null ? (token.length > 20 ? "${token.substring(0, 20)}..." : token) : "null"}');
        print('✅ [AuthController] login() Gender: ${gender ?? "null"}');
        print(
            '✅ [AuthController] login() User location: ${response.data!.user!.location}');
        print(
            '✅ [AuthController] login() User status: ${response.data!.user!.status}');
        
        // Validate token exists before saving
        if (token == null || token.isEmpty) {
          print(
              '❌ [AuthController] login() ERROR: Token is null or empty! Cannot save user.');
          showErrorMessage(
              context, 'Login failed: No authentication token received');
          return response;
        }
        
        saveUserDetailInLocal(
            userIdString,
            response.data!.user!.name?.toString() ?? '',
            email,
            password,
            response.data!.user!.image?.toString() ?? '',
            response.data!.user!.userRole?.toString() ?? 'USER',
            response.data!.user!.authType?.toString() ?? 'EMAIL',
            response.data!.user!.phone?.toString() ?? '',
            '',
            response.data!.user!.deviceToken?.toString() ?? '',
            token,
            gender: gender);
        await updateDeviceTokenForUser(userIdString);

        showSuccessMessage(context, 'Login Successfully');

        // Navigate to dashboard after successful login
        print('✅ [AuthController] login() Navigating to dashboard');
        Future.delayed(Duration(milliseconds: 500), () {
          handleUserRoleNavigation(response.data!.user!.userRole ?? 'USER');
        });
      } else {
        String errorMessage = 'Login failed - invalid response structure';
        if (response.data == null) {
          errorMessage = 'Login failed - no data in response';
        } else if (response.data!.user == null) {
          errorMessage = 'Login failed - no user data in response';
        } else if (response.data!.user!.userId == null) {
          errorMessage = 'Login failed - no user ID in response';
        }
        print('❌ [AuthController] login() Error: $errorMessage');
        print('❌ [AuthController] Full response: ${response.toJson()}');
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
        showErrorMessage(
            context, response['message'] ?? 'Email already registered');
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
        showErrorMessage(
            context, response.message?.toString() ?? 'Signup failed');
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

      // Ensure FCM token is fetched before API call
      final tokenToSend = await _ensureFcmToken();
      final preview = tokenToSend.isNotEmpty && tokenToSend.length > 30
          ? tokenToSend.substring(0, 30)
          : tokenToSend;
      print(
          '📤 [AuthController] userRegister() Sending FCM token: ${tokenToSend.isNotEmpty ? "$preview..." : "empty"}');

      UserRegisterModel response = await authApi.userRegister(
          firstName,
          email,
          password,
          location,
          tokenToSend,
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
        
        // Get FCM token if not already set
        if (fcmToken.isEmpty && _isFirebaseReady()) {
          try {
            final token = await FirebaseMessaging.instance.getToken();
            if (token != null && token.isNotEmpty) {
              fcmToken = token;
              await setToken(token);
            }
          } catch (error) {
            print('⚠️ [AuthController] userRegister() FCM token error: $error');
          }
        }

        // Use FCM token from Firebase Messaging, fallback to response token
        final deviceTokenToSave = fcmToken.isNotEmpty
            ? fcmToken
            : (response.data!.deviceToken?.toString() ?? '');

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
          deviceTokenToSave,
          null, // No auth token for user register (only for login)
        );

        // Update device token on server if we have a fresh FCM token
        if (fcmToken.isNotEmpty) {
          await updateDeviceTokenForUser(userIdString);
        }
        
        // Navigate to dashboard after successful registration
        print('✅ [AuthController] userRegister() Navigating to dashboard');
        Future.delayed(Duration(milliseconds: 500), () {
          handleUserRoleNavigation(response.data!.userRole ?? 'USER');
        });
        
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        String errorMessage =
            response.message ?? 'Registration failed - no user data returned';
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

      // Ensure FCM token is fetched before API call
      final tokenToSend = await _ensureFcmToken();
      final preview = tokenToSend.isNotEmpty && tokenToSend.length > 30
          ? tokenToSend.substring(0, 30)
          : tokenToSend;
      print(
          '📤 [AuthController] doctorRegister() Sending FCM token: ${tokenToSend.isNotEmpty ? "$preview..." : "empty"}');

      DoctorRegisterModel response = await authApi.doctorRegister(
          firstName,
          email,
          password,
          location,
          tokenToSend,
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
        // Get userId - handle both _id (MongoDB) and user_id (legacy)
        String? userIdString = response.data!.userId?.toString();
        if (userIdString == null || userIdString.isEmpty) {
          String errorMessage =
              'Doctor registration failed - user ID not found in response';
          print('❌ [AuthController] doctorRegister() Error: $errorMessage');
          showErrorMessage(context, errorMessage);
          registerLoader.value = false;
          return false;
        }
        
        print('✅ [AuthController] doctorRegister() Saving user:');
        print('   - UserId: $userIdString');
        print('   - Name: ${response.data!.name}');
        print('   - Email: $email');
        print('   - Role: ${response.data!.userRole}');
        
        await saveUserDetailInLocal(
            userIdString,
            response.data!.name?.toString() ?? '',
            email,
            password,
            response.data!.image?.toString() ?? '',
            response.data!.userRole?.toString() ?? 'DOCTOR',
            response.data!.authType?.toString() ?? 'EMAIL',
            response.data!.phone?.toString() ?? '',
            '',
            response.data!.deviceToken?.toString() ?? '',
            null); // No token for doctor registration

        List<String> monday = dateAvail[0].toList();
        List<String> tuesday = dateAvail[1].toList();
        List<String> wednesday = dateAvail[2].toList();
        List<String> thursday = dateAvail[3].toList();
        List<String> friday = dateAvail[4].toList();
        List<String> saturday = dateAvail[5].toList();
        List<String> sunday = dateAvail[6].toList();

        await authApi.AddDoctorAvailability(userIdString, monday, tuesday,
            wednesday, thursday, friday, saturday, sunday);
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        String errorMessage = response.message ??
            'Doctor registration failed - no user data returned';
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

      // Ensure FCM token is fetched before API call
      final tokenToSend = await _ensureFcmToken();
      final preview = tokenToSend.isNotEmpty && tokenToSend.length > 30
          ? tokenToSend.substring(0, 30)
          : tokenToSend;
      print(
          '📤 [AuthController] bloodBankRegister() Sending FCM token: ${tokenToSend.isNotEmpty ? "$preview..." : "empty"}');

      BloodBankRegisterModel response = await authApi.bloodBankRegister(
          name,
          email,
          password,
          location,
          tokenToSend,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId,
          image);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage =
            response.message ?? 'Blood bank registration failed';
        print('❌ [AuthController] bloodBankRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
      
      if (response.data != null) {
        // Get userId - handle both _id (MongoDB) and user_id (legacy)
        String? userIdString = response.data!.userId?.toString();
        if (userIdString == null || userIdString.isEmpty) {
          String errorMessage =
              'Blood bank registration failed - user ID not found in response';
          print('❌ [AuthController] bloodBankRegister() Error: $errorMessage');
          showErrorMessage(context, errorMessage);
          registerLoader.value = false;
          return false;
        }
        
        print('✅ [AuthController] bloodBankRegister() Saving user:');
        print('   - UserId: $userIdString');
        print('   - Name: ${response.data!.name}');
        print('   - Email: $email');
        print('   - Role: ${response.data!.userRole}');
        
        saveUserDetailInLocal(
            userIdString,
            response.data!.name?.toString() ?? '',
            email,
            password,
            response.data!.image?.toString() ?? '',
            response.data!.userRole?.toString() ?? 'BLOODBANK',
            response.data!.authType?.toString() ?? 'EMAIL',
            response.data!.phone?.toString() ?? '',
            '',
            response.data!.deviceToken?.toString() ?? '',
            null); // No token for blood bank registration
        showSuccessMessage(context, 'Register Successfully');
        return true;
      } else {
        String errorMessage = response.message ??
            'Blood bank registration failed - no user data returned';
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

      // Ensure FCM token is fetched before API call
      final tokenToSend = await _ensureFcmToken();
      final preview = tokenToSend.isNotEmpty && tokenToSend.length > 30
          ? tokenToSend.substring(0, 30)
          : tokenToSend;
      print(
          '📤 [AuthController] PharmacyRegister() Sending FCM token: ${tokenToSend.isNotEmpty ? "$preview..." : "empty"}');

      PharmacyRegisterModel response = await authApi.PharmacyRegister(
          name,
          email,
          password,
          location,
          tokenToSend,
          phoneNo,
          authType,
          userRole,
          lat,
          long,
          placeId,
          image);
      
      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        String errorMessage =
            response.message ?? 'Pharmacy registration failed';
        print('❌ [AuthController] PharmacyRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
      
      if (response.data != null) {
        // Get userId - handle both _id (MongoDB) and user_id (legacy)
        String? userIdString = response.data!.userId?.toString();
        if (userIdString == null || userIdString.isEmpty) {
          String errorMessage =
              'Pharmacy registration failed - user ID not found in response';
          print('❌ [AuthController] PharmacyRegister() Error: $errorMessage');
          showErrorMessage(context, errorMessage);
          registerLoader.value = false;
          return false;
        }
        
        print('✅ [AuthController] PharmacyRegister() Saving user:');
        print('   - UserId: $userIdString');
        print('   - Name: ${response.data!.name}');
        print('   - Email: $email');
        print('   - Role: ${response.data!.userRole}');
        
        saveUserDetailInLocal(
            userIdString,
            response.data!.name?.toString() ?? '',
            email,
            password,
            response.data!.image?.toString() ?? '',
            response.data!.userRole?.toString() ?? 'PHARMACY',
            response.data!.authType?.toString() ?? 'EMAIL',
            response.data!.phone?.toString() ?? '',
            '',
            response.data!.deviceToken?.toString() ?? '',
            null); // No token for pharmacy registration

        showSuccessMessage(context, 'Register Successfully');

        return true;
      } else {
        String errorMessage = response.message ??
            'Pharmacy registration failed - no user data returned';
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

      // Ensure FCM token is fetched before API call
      final tokenToSend = await _ensureFcmToken();
      final preview = tokenToSend.isNotEmpty && tokenToSend.length > 30
          ? tokenToSend.substring(0, 30)
          : tokenToSend;
      print(
          '📤 [AuthController] HospitalRegister() Sending FCM token: ${tokenToSend.isNotEmpty ? "$preview..." : "empty"}');

      HospitalRegisterModel response = await authApi.hospitalRegister(
          name,
          email,
          password,
          location,
          tokenToSend,
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
        String errorMessage =
            response.message ?? 'Hospital registration failed';
        print('❌ [AuthController] HospitalRegister() Error: $errorMessage');
        showErrorMessage(context, errorMessage);
        return [false];
      }
      
      if (response.data != null) {
        // Get userId - handle both _id (MongoDB) and user_id (legacy)
        String? userIdString = response.data!.userId?.toString();
        if (userIdString == null || userIdString.isEmpty) {
          String errorMessage =
              'Hospital registration failed - user ID not found in response';
          print('❌ [AuthController] HospitalRegister() Error: $errorMessage');
          showErrorMessage(context, errorMessage);
          registerLoader.value = false;
          return [false];
        }
        
        print('✅ [AuthController] HospitalRegister() Saving user:');
        print('   - UserId: $userIdString');
        print('   - Name: ${response.data!.name}');
        print('   - Email: $email');
        print('   - Role: ${response.data!.userRole}');
        
        saveUserDetailInLocal(
            userIdString,
            response.data!.name?.toString() ?? '',
            email,
            password,
            response.data!.image?.toString() ?? '',
            response.data!.userRole?.toString() ?? 'HOSPITAL',
            response.data!.authType?.toString() ?? 'EMAIL',
            response.data!.phone?.toString() ?? '',
            '',
            response.data!.deviceToken?.toString() ?? '',
            null); // No token for hospital registration
        showSuccessMessage(context, 'Register Successfully');
        return [true, response.data!.hospitalDetailId];
      } else {
        String errorMessage = response.message ??
            'Hospital registration failed - no user data returned';
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

      if (googleUser == null) {
        loginLoader.value = false;
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        loginLoader.value = false;
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Log Google Sign-In Response Data
      print('');
      print(
          '📋 [AuthController] ========== GOOGLE SIGN-IN RESPONSE ==========');
      print('📋 [AuthController] Google Account:');
      print('   - User ID: ${googleUser.id}');
      print('   - Email: ${googleUser.email}');
      print('   - Display Name: ${googleUser.displayName ?? "N/A"}');
      print('   - Photo URL: ${googleUser.photoUrl ?? "N/A"}');
      print('   - Server Auth Code: ${googleUser.serverAuthCode ?? "N/A"}');
      print('');
      print('📋 [AuthController] Google Authentication:');
      print('   - Access Token: ${googleAuth.accessToken ?? "null"}');
      print('   - ID Token: ${googleAuth.idToken ?? "null"}');
      print('');
      print('📋 [AuthController] Firebase User:');
      print('   - UID: ${user.user?.uid}');
      print('   - Email: ${user.user?.email}');
      print('   - Display Name: ${user.user?.displayName ?? "N/A"}');
      print('   - Photo URL: ${user.user?.photoURL ?? "N/A"}');
      print('   - Email Verified: ${user.user?.emailVerified}');
      print('   - Creation Time: ${user.user?.metadata.creationTime}');
      print('   - Last Sign In: ${user.user?.metadata.lastSignInTime}');
      print(
          '   - Provider Data: ${user.user?.providerData.map((p) => '${p.providerId}: ${p.uid}').join(', ')}');
      print('   - Additional User Info: ${user.additionalUserInfo?.profile}');
      print('   - Is New User: ${user.additionalUserInfo?.isNewUser}');
      print('📋 [AuthController] ============================================');
      print('');

      // Get FCM token before calling API
      final deviceToken = await _ensureFcmToken();

      // Call social auth API
      LoginModel response = await authApi.socialAuth(
        isGoogle: true,
        email: googleUser.email,
        name: googleUser.displayName,
        image: googleUser.photoUrl,
        deviceToken: deviceToken,
      );

      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        print('❌ [AuthController] signInWithGoogle() API Error:');
        print('   - Success: ${response.sucess}');
        print('   - Code: ${response.code}');
        print('   - Message: ${response.message}');
        loginLoader.value = false;
        showErrorMessage(context, response.message ?? 'Google sign-in failed');
        return;
      }

      // Save user data if successful
      if (response.data != null &&
          response.data!.user != null &&
          response.data!.user!.userId != null) {
        String userIdString = response.data!.user!.userId.toString();
        String? token = response.data!.token;
        String? gender = response.data!.user!.gender;

        if (token == null || token.isEmpty) {
          print(
              '❌ [AuthController] signInWithGoogle() ERROR: Token is null or empty!');
          loginLoader.value = false;
          showErrorMessage(
              context, 'Google sign-in failed: No authentication token received');
          return;
        }

        saveUserDetailInLocal(
          userIdString,
          response.data!.user!.name?.toString() ?? googleUser.displayName ?? '',
          response.data!.user!.email ?? googleUser.email ?? '',
          '', // password - not needed for social login
          response.data!.user!.image?.toString() ?? googleUser.photoUrl ?? '',
          response.data!.user!.userRole?.toString() ?? 'USER',
          'GOOGLE', // authType
          response.data!.user!.phone?.toString() ?? '',
          '', // lastName
          response.data!.user!.deviceToken?.toString() ?? deviceToken,
          token,
          gender: gender,
        );

        // Update device token on server if we have a fresh FCM token
        if (deviceToken.isNotEmpty) {
          await updateDeviceTokenForUser(userIdString);
        }

        // Navigate based on user role
        handleUserRoleNavigation(response.data!.user!.userRole ?? 'USER');
      }

      loginLoader.value = false;
    } catch (e) {
      loginLoader.value = false;
      print('❌ [AuthController] Google Sign-In Error: $e');
      showErrorMessage(
          context, 'Error signing in with Google: ${e.toString()}');
      return Future.error(e);
    }
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
      print('google: $credential');

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      registerLoader.value = false;
      print('Error signing in with Google: $e');
      return Future.error(e);
    } finally {
      registerLoader.value = false;
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  Future<void> signInWithApple(context) async {
    loginLoader.value = true;

    try {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      if (appleCredential.identityToken == null ||
          appleCredential.identityToken!.isEmpty) {
        loginLoader.value = false;
        showErrorMessage(context, 'Failed to get identity token from Apple');
        return;
      }

      // Log Apple Sign-In Response Data (before Firebase auth attempt)
      print('');
      print('📋 [AuthController] ========== APPLE SIGN-IN RESPONSE ==========');
      print('📋 [AuthController] Apple ID Credential:');
      print('   - User Identifier: ${appleCredential.userIdentifier}');
      print(
          '   - Email: ${appleCredential.email ?? "null (may be null on subsequent sign-ins)"}');
      print('   - Given Name: ${appleCredential.givenName ?? "null"}');
      print('   - Family Name: ${appleCredential.familyName ?? "null"}');
      print('   - State: ${appleCredential.state ?? "null"}');
      print('   - Identity Token: ${appleCredential.identityToken ?? "null"}');
      print(
          '   - Authorization Code: ${appleCredential.authorizationCode ?? "null"}');
      print('');
      print('📋 [AuthController] Nonce:');
      print('   - Raw Nonce: $rawNonce');
      print('   - SHA256 Nonce: $nonce');
      print('');

      // Attempt Firebase authentication (optional - continue even if it fails)
      UserCredential? user;
      try {
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

        user = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

        print('📋 [AuthController] Firebase User:');
        print('   - UID: ${user.user?.uid}');
        print('   - Email: ${user.user?.email ?? "null"}');
        print('   - Display Name: ${user.user?.displayName ?? "null"}');
        print('   - Email Verified: ${user.user?.emailVerified}');
        print('   - Creation Time: ${user.user?.metadata.creationTime}');
        print('   - Last Sign In: ${user.user?.metadata.lastSignInTime}');
        print(
            '   - Provider Data: ${user.user?.providerData.map((p) => '${p.providerId}: ${p.uid}').join(', ')}');
        print('   - Additional User Info: ${user.additionalUserInfo?.profile}');
        print('   - Is New User: ${user.additionalUserInfo?.isNewUser}');
      } catch (firebaseError) {
        print('⚠️ [AuthController] Firebase authentication failed (continuing anyway): $firebaseError');
        print('⚠️ [AuthController] This is OK - we will use the identity token for backend API');
      }
      print('📋 [AuthController] ============================================');
      print('');

      // Get FCM token before calling API
      final deviceToken = await _ensureFcmToken();

      // Call social auth API with Apple identity token
      LoginModel response = await authApi.socialAuth(
        isGoogle: false,
        appleToken: appleCredential.identityToken,
        deviceToken: deviceToken,
      );

      // Check for errors first
      if (response.sucess == false || response.code != 200) {
        print('❌ [AuthController] signInWithApple() API Error:');
        print('   - Success: ${response.sucess}');
        print('   - Code: ${response.code}');
        print('   - Message: ${response.message}');
        loginLoader.value = false;
        showErrorMessage(context, response.message ?? 'Apple sign-in failed');
        return;
      }

      // Save user data if successful
      if (response.data != null &&
          response.data!.user != null &&
          response.data!.user!.userId != null) {
        String userIdString = response.data!.user!.userId.toString();
        String? token = response.data!.token;
        String? gender = response.data!.user!.gender;

        if (token == null || token.isEmpty) {
          print(
              '❌ [AuthController] signInWithApple() ERROR: Token is null or empty!');
          loginLoader.value = false;
          showErrorMessage(
              context, 'Apple sign-in failed: No authentication token received');
          return;
        }

        saveUserDetailInLocal(
          userIdString,
          response.data!.user!.name?.toString() ?? '',
          response.data!.user!.email ?? appleCredential.email ?? '',
          '', // password - not needed for social login
          response.data!.user!.image?.toString() ?? '',
          response.data!.user!.userRole?.toString() ?? 'USER',
          'APPLE', // authType
          response.data!.user!.phone?.toString() ?? '',
          '', // lastName
          response.data!.user!.deviceToken?.toString() ?? deviceToken,
          token,
          gender: gender,
        );

        // Update device token on server if we have a fresh FCM token
        if (deviceToken.isNotEmpty) {
          await updateDeviceTokenForUser(userIdString);
        }

        // Navigate based on user role
        handleUserRoleNavigation(response.data!.user!.userRole ?? 'USER');
      }

      loginLoader.value = false;
    } catch (e) {
      loginLoader.value = false;
      if (e.toString().contains('cancelled') ||
          e.toString().contains('canceled')) {
        return;
      }
      print('❌ [AuthController] Apple Sign-In Error: $e');
      showErrorMessage(context, 'Error signing in with Apple: ${e.toString()}');
      return Future.error(e);
    }
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
