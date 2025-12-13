import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_api.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_model.dart';
import 'package:joy_app/modules/doctor/view/all_appointment.dart';
import 'package:joy_app/modules/doctor/view/home_screen.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';

import '../../auth/models/user.dart';
import '../models/doctor_appointment_model.dart';
import '../models/doctor_detail_hive_model.dart';

class DoctorController extends GetxController {
  late DioClient dioClient;
  late DoctorApi doctorApi;
  RxList<Appointment> doctorAppointment = <Appointment>[].obs;
  final _doctorDetail = Rxn<DoctorDetail>();
  var appointmentLoader = false.obs;
  var editLoader = false.obs;
  var fetchAppointmentLoader = false.obs;
  var val = 0.0.obs;
  var doctorAvailabilityText = ''.obs;
  DoctorDetail? get doctorDetail => _doctorDetail.value;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    doctorApi = DoctorApi(dioClient);
    AllAppointments();
    UserHive? currentUser = await getCurrentUser();
    getDoctorDetail();
  }

  avgrating() async {
    doctorDetail!.data!.reviews!.forEach((element) {
      val.value = val.value +
          (double.parse(element.rating!) / doctorDetail!.data!.reviews!.length);
    });
  }

  Future<DoctorAppointment> AllAppointments() async {
    fetchAppointmentLoader.value = true;
    UserHive? currentUser = await getCurrentUser();

    doctorAppointment.clear();
    try {
      DoctorAppointment response =
          await doctorApi.getAllAppointments(currentUser!.userId);

      if (response.data != null) {
        response.data!.forEach((element) {
          doctorAppointment.add(element);
        });
      } else {}
      fetchAppointmentLoader.value = false;
      return response;
    } catch (error) {
      fetchAppointmentLoader.value = false;

      throw (error);
    } finally {
      fetchAppointmentLoader.value = false;
    }
  }

  Future<DoctorDetail> getDoctorDetail() async {
    UserHive? currentUser = await getCurrentUser();

    try {
      DoctorDetail response =
          await doctorApi.getDoctorDetail(currentUser!.userId);
      // await Hive.openBox<DoctorDetailModelAdapter>('doctor_details');

      if (response.data != null) {
        // Box<DoctorDetailModelAdapter> box =
        //     Hive.box<DoctorDetailModelAdapter>('doctor_details');
        // await box.clear();
        // box.add(response);
        _doctorDetail.value = response;
        _setAvailabilityText();
      } else {
        //   Box<DoctorDetail> box = Hive.box<DoctorDetail>('doctor_details');
        // _doctorDetail.value = box.get(0);
      }
      return response;
    } catch (error) {
      throw (error);
    } finally {
      avgrating();
    }
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

  List<List<String>> storeAvailabilityTimes() {
    List<List<String>> availabilityTimes = [];

    _doctorDetail.value!.data!.availability!.forEach((availability) {
      if (availability.times!.isNotEmpty) {
        List<String> timesList =
            availability.times!.split(',').map((time) => time.trim()).toList();
        availabilityTimes.add(timesList);
      } else {
        availabilityTimes
            .add([]); // add an empty list for days with no available times
      }
    });
    return availabilityTimes;
  }

  updateDoctor(
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
      String aboutMe,
      BuildContext context,
      image) async {
    try {
      bool response = await doctorApi.updateDoctor(
          userId,
          name,
          email,
          password,
          location,
          deviceToken,
          gender,
          userRole,
          authType,
          phone,
          expertise,
          consultationFee,
          qualifications,
          document,
          aboutMe,
          image);

      if (response == true) {
        showSuccessMessage(context, 'Profile Updated');
      } else {
        showErrorMessage(context, 'Error updating Profile');
      }
    } catch (error) {
      throw (error);
    } finally {}
  }

  updateAppointment(String appointmentId, String status, String remarks,
      BuildContext context, doctorId) async {
    appointmentLoader.value = true;
    try {
      bool response = await doctorApi.updateAppointmentStatus(
          appointmentId, status, remarks);

      if (response == true) {
        showSuccessMessage(context, 'Appointment ${status}');
        Get.offAll(NavBarScreen(
          isDoctor: true,
        ));
        AllAppointments();
      } else {
        showErrorMessage(context, 'Error updating Profile');
      }
    } catch (error) {
      appointmentLoader.value = false;
      throw (error);
    } finally {
      appointmentLoader.value = false;
    }
  }

  giveMedication(String appointmentId, String daignosis, String prescription,
      BuildContext context) async {
    appointmentLoader.value = true;
    try {
      bool response = await doctorApi.giveMedication(
          appointmentId, daignosis, prescription);

      if (response == true) {
      } else {}
    } catch (error) {
      appointmentLoader.value = false;
      throw (error);
    } finally {
      appointmentLoader.value = false;
    }
  }

  Future<bool> doctorRegister(
      firstName,
      location,
      phoneNo,
      deviceToken,
      authType,
      userRole,
      String email,
      String password,
      gender,
      expertise,
      qualification,
      documentUrl,
      consultationFees,
      BuildContext context) async {
    try {
      UserHive? currentUser = await getCurrentUser();

      editLoader.value = true;
      final response = await doctorApi.EditDoctor(
          firstName,
          email,
          password,
          location,
          deviceToken,
          gender,
          phoneNo,
          authType,
          userRole,
          expertise,
          consultationFees,
          qualification,
          documentUrl,
          currentUser!.userId);
      if (response.data != null) {
        saveUserDetailInLocal(
            response.data!.userId!.toString(),
            response.data!.name!.toString(),
            email,
            password,
            response.data!.image.toString(),
            response.data!.userRole.toString(),
            response.data!.authType.toString(),
            response.data!.phone.toString(),
            '',
            response.data!.deviceToken.toString());
        showSuccessMessage(context, 'Profile Edit Successfully');
        return true;
      } else {
        showErrorMessage(context, response.message.toString());
        return false;
      }

      // return response;
    } catch (error) {
      editLoader.value = false;

      throw (error);
    } finally {
      editLoader.value = false;
    }
  }

  saveUserDetailInLocal(
      String userId,
      String firstName,
      String email,
      String password,
      String image,
      String userRole,
      String authType,
      String phone,
      String lastName,
      String deviceToken) async {
    var user = UserHive(
        userId: userId,
        firstName: firstName,
        email: email,
        password: password,
        userRole: userRole,
        authType: authType,
        phone: phone,
        lastName: lastName,
        deviceToken: deviceToken);
    await Hive.openBox<UserHive>('users');
    final userBox = await Hive.openBox<UserHive>('users');
    await userBox.put('current_user', user);
  }
}
