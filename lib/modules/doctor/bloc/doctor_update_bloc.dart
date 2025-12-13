import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_api.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';

class updateDotorController extends GetxController {
  late DioClient dioClient;

  var editLoader = false.obs;
  late DoctorApi doctorApi;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    doctorApi = DoctorApi(dioClient);
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
      image,
      {bool profileCompleted = false,
      List<Map<String, dynamic>>? availability}) async {
    editLoader.value = true;
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
          image,
          profileCompleted: profileCompleted,
          availability: availability);

      if (response == true) {
        editLoader.value = false;
        showSuccessMessage(context, 'Profile Updated');
      } else {
        showErrorMessage(context, 'Error updating Profile');
        editLoader.value = false;
      }
    } catch (error) {
      editLoader.value = false;

      throw (error);
    } finally {
      editLoader.value = false;
    }
  }
}
