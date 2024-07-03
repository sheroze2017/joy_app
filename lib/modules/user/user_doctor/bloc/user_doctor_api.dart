import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_doctor/model/all_doctor_model.dart';

import '../model/all_user_appointment.dart';

class UserDoctorApi {
  final DioClient _dioClient;

  UserDoctorApi(this._dioClient);

  Future<bool> CreateReview(
    String given_to,
    String given_by,
    String rating,
    String review,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.giveReview, data: {
        "given_to": given_to,
        "given_by": given_by,
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
      return AllDoctor.fromJson(result);
    } catch (e) {
      print(e.toString());
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
      final result = await _dioClient.post(Endpoints.createAppointment, data: {
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
}
