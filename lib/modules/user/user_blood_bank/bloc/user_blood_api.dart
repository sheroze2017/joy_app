import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';

import '../model/all_bloodbank_model.dart';

class UserBloodBankApi {
  final DioClient _dioClient;

  UserBloodBankApi(this._dioClient);

  Future<bool> CreateDonor(String name, String bloodGroup, String location,
      String gender, String city, String userId, String type) async {
    try {
      final result = await _dioClient.post(Endpoints.createBloodDonor, data: {
        "name": name,
        "blood_group": bloodGroup,
        "location": location,
        "gender": gender,
        "city": city,
        "user_id": userId,
        "type": type
      });
      if (result['sucess'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> CreateBloodRequest(
      String name,
      String date,
      String time,
      String units,
      String bloodGroup,
      String gender,
      String city,
      String location,
      String userId,
      String bloodType) async {
    try {
      final result = await _dioClient.post(Endpoints.createBloodAppeal, data: {
        "patient_name": name,
        "date": date,
        "time": time,
        "units_of_blood": units,
        "blood_group": bloodGroup,
        "gender": gender,
        "city": city,
        "location": location,
        "user_id": userId,
        "type": bloodType
      });
      if (result['sucess'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<AllBloodBank> getAllBloodBank() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllBloodBanks);
      return AllBloodBank.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
