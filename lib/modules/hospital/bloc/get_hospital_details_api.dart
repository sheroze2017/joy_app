import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';

import '../model/hospital_detail_model.dart';

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
      final result = await _dioClient
          .get(Endpoints.getAllHospitalDoctors + '?hospital_id=${hospitalId}');
      return PharmacyModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<HospitalDetail> getHospitalDetails(String hospitalId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getHospitalDetail + '?hospital_id=${hospitalId}');
      return HospitalDetail.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Map<String, dynamic>> linkHospital(
      String link_user_id, String link_to_user_id) async {
    try {
      final result = await _dioClient.post(Endpoints.linkHospital, data: {
        "linked_user": link_user_id,
        "linked_to_user": link_to_user_id
      });
      return result;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Map<String, dynamic>> linkOrDelinkHospital(
      String userId, String? hospitalId) async {
    try {
      final requestData = <String, dynamic>{
        "user_id": userId,
      };
      if (hospitalId != null) {
        requestData["hospital_id"] = hospitalId;
      }
      final result = await _dioClient.post(
          Endpoints.linkOrDelinkHospital,
          data: requestData);
      return result;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
