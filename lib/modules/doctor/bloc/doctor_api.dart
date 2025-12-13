import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/doctor_register_model.dart';
import 'package:joy_app/modules/doctor/models/doctor_appointment_model.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_model.dart';

class DoctorApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  DoctorApi(this._dioClient);

  Future<DoctorAppointment> getAllAppointments(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getAllAppointment + '?user_id=${userId}');
      return DoctorAppointment.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<DoctorDetail> getDoctorDetail(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getDoctorDetail + '?user_id=${userId}');
      print(result);
      return DoctorDetail.fromJson(result);
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
      String image,
      String aboutMe,
      {bool profileCompleted = false,
      List<Map<String, dynamic>>? availability}) async {
    try {
      print('👨‍⚕️ [DoctorApi] updateDoctor() called - Step 2: Complete Doctor Profile');
      print('👨‍⚕️ [DoctorApi] UserId: $userId, ProfileCompleted: $profileCompleted');
      print('👨‍⚕️ [DoctorApi] Expertise: $expertise, ConsultationFee: $consultationFee');
      if (availability != null && availability.isNotEmpty) {
        print('👨‍⚕️ [DoctorApi] Availability slots: ${availability.length} days');
      }
      Map<String, dynamic> data = {
        "user_id": userId,
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "gender": gender,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phone,
        "expertise": expertise,
        "consultation_fee": consultationFee,
        "qualifications": qualifications,
        "document": document,
        "about_me": aboutMe,
        "image": image,
        "profile_completed": profileCompleted
      };
      if (availability != null && availability.isNotEmpty) {
        data["availability"] = availability;
      }
      final result = await _dioClient.post(Endpoints.updateDoctor, data: data);
      print('✅ [DoctorApi] updateDoctor() response received');
      if (result['sucess'] == true) {
        print('✅ [DoctorApi] updateDoctor() success - ProfileCompleted: $profileCompleted');
        return true;
      } else {
        print('⚠️ [DoctorApi] updateDoctor() returned false - Success: ${result['sucess']}');
        return false;
      }
    } catch (e) {
      print('❌ [DoctorApi] updateDoctor() error: $e');
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

  Future<bool> giveMedication(
      String appointmentId, String diagnosis, String medication) async {
    try {
      final result = await _dioClient.post(Endpoints.giveMedication, data: {
        "appointment_id": appointmentId,
        "diagnosis": diagnosis,
        "medications": medication,
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
