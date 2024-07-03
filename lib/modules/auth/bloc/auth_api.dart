import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/auth/models/blood_bank_register_model.dart';
import 'package:joy_app/modules/auth/models/doctor_register_model.dart';
import 'package:joy_app/modules/auth/models/hospital_resgister_model.dart';
import 'package:joy_app/modules/auth/models/pharmacy_register_model.dart';
import 'package:joy_app/modules/auth/models/user_register_model.dart';

class AuthApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  AuthApi(this._dioClient);

  Future<LoginModel> login(
    String email,
    String password,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.loginApi,
          data: {"email": email, "password": password, "auth_type": "EMAIL"});
      return LoginModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<int> isValidEmail(
    String email,
  ) async {
    try {
      final result =
          await _dioClient.get(Endpoints.isValidEmail + '?email=${email}');
      return result['code'];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<UserRegisterModel> userRegister(
      String firstName,
      String email,
      String password,
      String location,
      String deviceToken,
      String dob,
      String gender,
      String phoneNo,
      String authType,
      String userRole,
      String image) async {
    try {
      final result = await _dioClient.post(Endpoints.userSignUpApi, data: {
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "date_of_birth": dob,
        "gender": gender,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "image": image
      });
      return UserRegisterModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<DoctorRegisterModel> doctorRegister(
      String firstName,
      String email,
      String password,
      String location,
      String deviceToken,
      String gender,
      String phoneNo,
      String authType,
      String userRole,
      String expertise,
      String consultationFees,
      String qualification,
      String documentUrl,
      String image) async {
    try {
      final result = await _dioClient.post(Endpoints.doctorSignUpApi, data: {
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "gender": gender,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "expertise": expertise,
        "consultation_fee": consultationFees,
        "qualifications": qualification,
        "document": documentUrl,
        "image": image
      });
      return DoctorRegisterModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<BloodBankRegisterModel> bloodBankRegister(
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String authType,
      String userRole,
      String lat,
      String long,
      String placeId,
      String image) async {
    try {
      final result = await _dioClient.post(Endpoints.bloodBankSignUpApi, data: {
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "image": image
      });
      return BloodBankRegisterModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<PharmacyRegisterModel> PharmacyRegister(
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String authType,
      String userRole,
      String lat,
      String long,
      String placeId,
      String image) async {
    try {
      final result = await _dioClient.post(Endpoints.pharmacySignUpApi, data: {
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "image": image
      });
      return PharmacyRegisterModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<HospitalRegisterModel> hospitalRegister(
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String authType,
      String userRole,
      String lat,
      String long,
      String placeId,
      String instituteType,
      String about,
      String checkupFee,
      String image) async {
    try {
      final result = await _dioClient.post(Endpoints.hospitalSignUpApi, data: {
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "checkup_fee": checkupFee,
        "about": about,
        "institute": instituteType,
        "image": image
      });
      return HospitalRegisterModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
