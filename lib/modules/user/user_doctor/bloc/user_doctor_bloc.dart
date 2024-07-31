import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_api.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_model.dart';
import '../../../../Widgets/success_dailog.dart';
import '../model/all_doctor_model.dart';
import '../model/all_user_appointment.dart';
import 'user_doctor_api.dart';
// ignore: depend_on_referenced_packages

class UserDoctorController extends GetxController {
  late DioClient dioClient;
  late UserDoctorApi userDoctorApi;
  late DoctorApi doctorApi;
  var showLoader = false.obs;
  var reviewLoader = false.obs;
  var createAppointmentLoader = false.obs;
  var appointmentLoader = false.obs;
  var detailLoader = false.obs;
  final _doctorDetail = Rxn<DoctorDetail>();
  var val = 0.0.obs;

  DoctorDetail? get doctorDetail => _doctorDetail.value;
  RxList<Doctor> doctorsList = <Doctor>[].obs;
  RxList<Doctor> searchDoctorsList = <Doctor>[].obs;
  var doctorAvailabilityText = 'No dates available'.obs;
  RxList<UserAppointment> userAppointment = <UserAppointment>[].obs;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    userDoctorApi = UserDoctorApi(dioClient);
    doctorApi = DoctorApi(dioClient);
  }

  void _setAvailabilityText() {
    doctorAvailabilityText.value =
        _doctorDetail.value!.data!.availability!.map((availability) {
      if (availability.times!.isEmpty) {
        return '${availability.day}:\nNo available times';
      } else {
        return '${availability.day}:\n${availability.times!.replaceAll(',', ', ')}';
      }
    }).join('\n\n');
  }

  Future<AllDoctor> getAllDoctors() async {
    try {
      doctorsList.clear();
      AllDoctor response = await userDoctorApi.getAllDoctors();
      if (response.data != null) {
        response.data!.forEach((element) {
          doctorsList.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {
      searchDoctorsList.value = doctorsList;
    }
  }

  Future<AllUserAppointment> getAllUserAppointment() async {
    UserHive? currentUser = await getCurrentUser();
    userAppointment.clear();
    try {
      AllUserAppointment response = await userDoctorApi
          .getAllUserAppointment(currentUser!.userId.toString());
      if (response.data != null) {
        response.data!.forEach((element) {
          userAppointment.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<bool> createReview(String given_to, String given_by, String rating,
      String review, context) async {
    reviewLoader.value = true;
    UserHive? currentUser = await getCurrentUser();
    try {
      bool response = await userDoctorApi.CreateReview(
          given_to, currentUser!.userId.toString(), rating, review);
      if (response == true) {
        showSuccessMessage(context, 'Review created sucessfully !');
        Get.offAll(NavBarScreen(
          isUser: true,
        ));
        reviewLoader.value = false;
      } else {
        showErrorMessage(context, 'Error creating review !');
        reviewLoader.value = false;
      }
      return response;
    } catch (error) {
      reviewLoader.value = false;
      throw (error);
    } finally {
      reviewLoader.value = false;
    }
  }

  updateAppointment(String appointmentId, String status, String remarks,
      BuildContext context, doctorId) async {
    appointmentLoader.value = true;
    try {
      bool response = await userDoctorApi.updateAppointmentStatus(
          appointmentId, status, remarks);

      if (response == true) {
        showSuccessMessage(context, 'Appointment ${status}');
        getAllUserAppointment();
      } else {
        showErrorMessage(context, 'Error updating appointment');
      }
    } catch (error) {
      appointmentLoader.value = false;
      throw (error);
    } finally {
      appointmentLoader.value = false;
    }
  }

  Future<DoctorDetail> getDoctorDetail(userId) async {
    detailLoader.value = true;
    _doctorDetail.value = null;
    try {
      DoctorDetail response = await doctorApi.getDoctorDetail(userId);

      if (response.data != null) {
        _doctorDetail.value = response;
        _setAvailabilityText();
        detailLoader.value = false;
      } else {
        //   Box<DoctorDetail> box = Hive.box<DoctorDetail>('doctor_details');
        // _doctorDetail.value = box.get(0);
        detailLoader.value = false;
      }
      return response;
    } catch (error) {
      detailLoader.value = false;

      throw (error);
    } finally {
      avgrating();
      detailLoader.value = false;
    }
  }

  Future<bool> createAppoinemntWithDoctor(
      userId,
      doctorId,
      date,
      time,
      complain,
      symptoms,
      location,
      status,
      age,
      gender,
      patientName,
      certificateUrl,
      doctorName,
      context) async {
    createAppointmentLoader.value = true;
    UserHive? currentUser = await getCurrentUser();
    try {
      bool response = await userDoctorApi.createAppointment(
          currentUser!.userId.toString(),
          doctorId,
          date,
          time,
          complain,
          symptoms,
          location,
          status,
          age,
          gender,
          patientName,
          certificateUrl);
      if (response == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: 'Congratulations!',
              content:
                  'Your appointment with ${doctorName} is confirmed for ${date} at ${time}.',
              showButton: true,
              isBookAppointment: true,
            );
          },
        );

        createAppointmentLoader.value = false;
      } else {
        showErrorMessage(context, 'Error booking doctor !');
        createAppointmentLoader.value = false;
      }
      return response;
    } catch (error) {
      createAppointmentLoader.value = false;
      throw (error);
    } finally {
      createAppointmentLoader.value = false;
    }
  }

  avgrating() async {
    doctorDetail!.data!.reviews!.forEach((element) {
      val.value = val.value +
          (double.parse(element.rating!) / doctorDetail!.data!.reviews!.length);
    });
  }

  void searchByName(String docName) {
    if (docName.isEmpty) {
      searchDoctorsList.value = doctorsList;
    }
    searchDoctorsList.value = doctorsList
        .where((doctor) =>
            doctor.name!.toLowerCase().contains(docName.toLowerCase()))
        .toList();
  }
}
