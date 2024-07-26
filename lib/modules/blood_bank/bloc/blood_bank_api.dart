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
      final result = await _dioClient.get(Endpoints.getAllBloodRequest);
      return AllBloodRequest.fromJson(result);
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
}
