import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';

class HospitalDetailsApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  HospitalDetailsApi(this._dioClient);

  Future<PharmacyModel> getAllHospitalPharmacy(String hospitalId) async {
    try {
      final result = await _dioClient.get(
          Endpoints.getAllHospitalPharmacies + '?hospital_id=${hospitalId}');
      return PharmacyModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<PharmacyModel> getAllHospitalDoctors(String hospitalId) async {
    try {
      final result = await _dioClient.get(
          Endpoints.getAllHospitalDoctors + '?hospital_id=${hospitalId}');
      return PharmacyModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
