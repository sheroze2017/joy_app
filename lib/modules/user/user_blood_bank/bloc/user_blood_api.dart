import 'package:dio/dio.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';

import '../model/all_bloodbank_model.dart';

class UserBloodBankApi {
  final DioClient _dioClient;

  UserBloodBankApi(this._dioClient);

  Future<Map<String, dynamic>> CreateDonor(String name, String bloodGroup, String location,
      String gender, String city, String userId, String type) async {
    try {
      print('🩸 [UserBloodBankApi] CreateDonor() called');
      print('🩸 [UserBloodBankApi] Name: $name, BloodGroup: $bloodGroup, Location: $location');
      print('🩸 [UserBloodBankApi] Gender: $gender, City: $city, UserId: $userId, Type: $type');
      
      final result = await _dioClient.post(Endpoints.createBloodDonor, data: {
        "name": name,
        "blood_group": bloodGroup,
        "location": location,
        "gender": gender,
        "city": city,
        "user_id": userId,
        "type": type
      });
      
      print('📥 [UserBloodBankApi] CreateDonor() response: $result');
      
      // Check if response indicates success or failure
      final isSuccess = result['sucess'] == true || result['success'] == true;
      final message = result['message']?.toString() ?? '';
      final code = result['code'];
      
      print('📥 [UserBloodBankApi] Success: $isSuccess, Code: $code, Message: $message');
      
      // Return the full result so we can access the message
      return {
        'success': isSuccess,
        'message': message,
        'code': code,
        'data': result['data']
      };
    } catch (e) {
      print('❌ [UserBloodBankApi] CreateDonor error: $e');
      // If it's a DioException, try to extract the error message from response
      if (e is DioException && e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['message']?.toString() ?? 'Error creating donor';
        print('❌ [UserBloodBankApi] Error message from response: $errorMessage');
        throw Exception(errorMessage);
      }
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
