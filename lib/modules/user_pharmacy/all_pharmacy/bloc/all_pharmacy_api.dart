import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';

import '../models/all_pharmacy_model.dart';

class PharmacyApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  PharmacyApi(this._dioClient);

  Future<PharmacyModel> getAllPharmacy() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllPharmacy);
      return PharmacyModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<PharmacyProductModel> getAllPharmacyProducts(String userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getPharmacyProduct + '?user_id=$userId');
      return PharmacyProductModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

   Future<PharmacyProductModel> getPhamracyProductDetails(String productId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getPharmacyProductDetails + '?product_id=$productId');
      return PharmacyProductModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<LoginModel> register(
    String firstName,
    String lastName,
    String about,
    String location,
    String phoneNo,
    String associatedHospital,
    String deviceToken,
    String email,
    String password,
    String authType,
    String userRole,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.signUpApi, data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "associated_hospital": associatedHospital,
        "about": about,
        "location": location,
        "device_token": deviceToken
      });
      return LoginModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
