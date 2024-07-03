import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_doctor/model/all_doctor_model.dart';
import 'package:joy_app/modules/user/user_hospital/model/all_hospital_model.dart';

class UserHospitalApi {
  final DioClient _dioClient;

  UserHospitalApi(this._dioClient);

  Future<AllHospital> getAllHospitals() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllHospital);
      return AllHospital.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
