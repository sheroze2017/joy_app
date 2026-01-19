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
      List<Map<String, dynamic>>? availability,
      Map<String, dynamic>? originalValues}) async {
    try {
      print('👨‍⚕️ [DoctorApi] updateDoctor() called - Step 2: Complete Doctor Profile');
      print('👨‍⚕️ [DoctorApi] UserId: $userId, ProfileCompleted: $profileCompleted');
      print('👨‍⚕️ [DoctorApi] Expertise: $expertise, ConsultationFee: $consultationFee');
      if (availability != null && availability.isNotEmpty) {
        print('👨‍⚕️ [DoctorApi] Availability slots: ${availability.length} days');
      }
      Map<String, dynamic> data = {
        "user_id": userId,
      };
      
      // Only include fields that have changed
      if (originalValues == null || name != originalValues['name']) {
        data["name"] = name;
      }
      if (originalValues == null || email != originalValues['email']) {
        data["email"] = email;
      }
      if (originalValues == null || password != originalValues['password']) {
        data["password"] = password;
      }
      if (originalValues == null || location != originalValues['location']) {
        data["location"] = location;
      }
      if (originalValues == null || gender != originalValues['gender']) {
        data["gender"] = gender;
      }
      if (originalValues == null || phone != originalValues['phone']) {
        data["phone"] = phone;
      }
      if (originalValues == null || expertise != originalValues['expertise']) {
        data["expertise"] = expertise;
      }
      if (originalValues == null || consultationFee != originalValues['consultation_fee']) {
        data["consultation_fee"] = consultationFee;
      }
      if (originalValues == null || qualifications != originalValues['qualifications']) {
        data["qualifications"] = qualifications;
      }
      if (originalValues == null || document != originalValues['document']) {
        data["document"] = document;
      }
      if (originalValues == null || aboutMe != originalValues['about_me']) {
        data["about_me"] = aboutMe;
      }
      if (originalValues == null || image != originalValues['image']) {
        data["image"] = image;
      }
      
      // Always send required fields
      data["device_token"] = deviceToken;
      data["user_role"] = userRole;
      data["auth_type"] = authType;
      data["profile_completed"] = profileCompleted;
      
      // Add availability if provided
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

  Future<bool> rescheduleAppointment(
      String appointmentId, String date, String time) async {
    try {
      final result =
          await _dioClient.post(Endpoints.rescheduleAppointment, data: {
        "appointment_id": appointmentId,
        "date": date,
        "time": time,
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

  Future<bool> giveMedicationWithTime(
      String appointmentId, String diagnosis, String medication, String timeTaken) async {
    try {
      final result = await _dioClient.post(Endpoints.giveMedication, data: {
        "appointment_id": appointmentId,
        "diagnosis": diagnosis,
        "medications": medication,
        "time_taken": "$timeTaken minutes",
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
