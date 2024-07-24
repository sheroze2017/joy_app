import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
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
import 'package:joy_app/view/home/navbar.dart';
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
    await Hive.openBox<UserHive>('users');
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
          deviceToken,
          dob,
          gender,
          phoneNo,
          image);
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
          deviceToken,
          phoneNo,
          placeId,
          lat,
          long,
          image);
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
          await getToken(),
          phoneNo,
          lat,
          long,
          placeId,
          image);
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
          await getToken(),
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
      if (response.data != null) {
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

        showSuccessMessage(context, 'Login Successfully');

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
      BuildContext context,
      image) async {
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
          image);
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
          response.data!.deviceToken.toString(),
        );
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
      BuildContext context,
      image) async {
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
          image);
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
    try {
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
      print('Error signing in with Google: $e');
      return Future.error(e);
    } finally {}
  }

  Future<UserCredential> registerWithGoogle() async {
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
