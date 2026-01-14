import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_doctor/model/all_doctor_model.dart';
import 'package:joy_app/modules/user/user_doctor/model/doctor_categories_model.dart';

import '../model/all_user_appointment.dart';

class UserDoctorApi {
  final DioClient _dioClient;

  UserDoctorApi(this._dioClient);

  Future<bool> CreateReview(
    String appointmentId,
    String rating,
    String review,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.giveReview, data: {
        "appointment_id": appointmentId,
        "rating": rating,
        "review": review
      });
      if (result['sucess'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {}
  }

  Future<AllDoctor> getAllDoctors() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllDoctors);
      print('📋 [UserDoctorApi] getAllDoctors response: ${result.toString()}');
      // Check if data is nested
      if (result['data'] != null && result['data'] is Map && result['data'].containsKey('doctors')) {
        print('📋 [UserDoctorApi] Found nested doctors structure');
        // Extract first doctor to check reviews
        final doctors = result['data']['doctors'];
        if (doctors is List && doctors.isNotEmpty) {
          print('📋 [UserDoctorApi] First doctor reviews: ${doctors[0]['reviews']}');
        }
      }
      return AllDoctor.fromJson(result);
    } catch (e) {
      print('❌ [UserDoctorApi] Error: ${e.toString()}');
      throw e;
    }
  }

  Future<DoctorCategoriesWithDoctors> getDoctorCategoriesWithDoctors() async {
    try {
      print('📋 [UserDoctorApi] getDoctorCategoriesWithDoctors - Calling: ${Endpoints.baseUrl}${Endpoints.getDoctorCategoriesWithDoctors}');
      final result = await _dioClient.get(Endpoints.getDoctorCategoriesWithDoctors);
      print('📋 [UserDoctorApi] getDoctorCategoriesWithDoctors response received');
      return DoctorCategoriesWithDoctors.fromJson(result);
    } catch (e) {
      print('❌ [UserDoctorApi] getDoctorCategoriesWithDoctors Error: ${e.toString()}');
      throw e;
    }
  }

  Future<AllUserAppointment> getAllUserAppointment(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getAllUserAppointment + '?user_id=${userId}');
      return AllUserAppointment.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<AllUserAppointment> getUserAppointmentsByStatus(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getUserAppointmentsByStatus + '?user_id=${userId}');
      return AllUserAppointment.fromJson(result);
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

  Future<bool> createAppointment(
      String userId,
      String doctorId,
      String date,
      String time,
      String complain,
      String symptoms,
      String location,
      String status,
      String age,
      String gender,
      String patientName,
      String certificateUrl) async {
    try {
      final payload = {
        "user_id": userId,
        "doctor_id": doctorId,
        "date": date,
        "time": time,
        "complain": complain,
        "symptoms": symptoms,
        "location": location,
        "status": status,
        "age": age,
        "gender": gender,
        "patient_name": patientName,
        "certificate": certificateUrl
      };
      print('📡 [UserDoctorApi] POST ${Endpoints.createAppointment}');
      print('📤 [UserDoctorApi] Payload: $payload');
      final result = await _dioClient.post(Endpoints.createAppointment, data: payload);
      print('📥 [UserDoctorApi] Response: $result');
      if (result['sucess'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {}
  }
}
