import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/doctor_register_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/blood_bank/model/blood_bank_details_model.dart';

class BloodBankApi {
  final DioClient _dioClient;

  BloodBankApi(this._dioClient);

  Future<AllDonor> getAllDonor() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllDonors);
      return AllDonor.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<BloodBankDetails> getBloodBankDetail(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getBloodBankDetails + '?user_id=${userId}');
      return BloodBankDetails.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<AllBloodRequest> getAllBloodRequest() async {
    try {
      print('🩸 [BloodBankApi] getAllBloodRequest() - Calling: ${Endpoints.baseUrl}${Endpoints.getAllBloodRequest}');
      final result = await _dioClient.get(Endpoints.getAllBloodRequest);
      print('🩸 [BloodBankApi] getAllBloodRequest() - Response received');
      print('🩸 [BloodBankApi] Response structure: ${result.keys.toList()}');
      if (result['data'] != null && result['data'].isNotEmpty) {
        print('🩸 [BloodBankApi] First request sample: ${result['data'][0]}');
        print('🩸 [BloodBankApi] First request keys: ${result['data'][0].keys.toList()}');
      }
      return AllBloodRequest.fromJson(result);
    } catch (e) {
      print('❌ [BloodBankApi] getAllBloodRequest() error: $e');
      throw e;
    }
  }

  Future<bool> deleteBloodRequest(String bloodId) async {
    try {
      // Using GET to match the curl command provided
      final result = await _dioClient.get(
        '${Endpoints.deleteBloodRequest}?blood_id=$bloodId',
      );
      if (result['sucess'] == true || result['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> attachDonorToBloodRequest(String bloodRequestId, String donorUserId) async {
    try {
      final result = await _dioClient.post(Endpoints.attachDonorToBloodRequest, data: {
        'blood_request_id': bloodRequestId,
        'donor_user_id': donorUserId,
      });
      if (result['sucess'] == true || result['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> detachDonorFromBloodRequest(String bloodRequestId, String userId) async {
    try {
      final result = await _dioClient.post(Endpoints.detachDonorFromBloodRequest, data: {
        'blood_request_id': bloodRequestId,
        'user_id': userId,
      });
      if (result['sucess'] == true || result['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> updateDoctor(
    String userId,
    String name,
    String email,
    String password,
    String location,
    String deviceToken,
    String gender,
    String userRole,
    String authType,
    String phone,
    String expertise,
    String consultationFee,
    String qualifications,
    String document,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.updateDoctor, data: {
        "user_id": userId,
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "gender": gender,
        "user_role": "DOCTOR",
        "auth_type": "SOCIAL",
        "phone": phone,
        "expertise": expertise,
        "consultation_fee": consultationFee,
        "qualifications": qualifications,
        "document": document
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

  Future<bool> updateAppointmentStatus(
      String appointmentId, String status, String remarks) async {
    try {
      final result =
          await _dioClient.post(Endpoints.updateAppointmentStatus, data: {
        "appointment_id": appointmentId,
        "status": status,
        "remarks": remarks,
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

  Future<DoctorRegisterModel> EditDoctor(
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
      String userId) async {
    try {
      final result = await _dioClient.post(Endpoints.updateDoctor, data: {
        "user_id": userId,
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "gender": gender,
        "user_role": "DOCTOR",
        "auth_type": "EMAIL",
        "phone": phoneNo,
        "expertise": expertise,
        "consultation_fee": consultationFees,
        "qualifications": qualification,
        "document": documentUrl
      });
      return DoctorRegisterModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> updateAbout(String userId, String about) async {
    try {
      final result = await _dioClient.post(Endpoints.updateAbout, data: {
        'user_id': userId,
        'about': about,
      });
      if (result['sucess'] == true || result['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> updateTimings(String userId, String timings) async {
    try {
      final result = await _dioClient.post(Endpoints.updateTimings, data: {
        'user_id': userId,
        'timings': timings,
      });
      if (result['sucess'] == true || result['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
