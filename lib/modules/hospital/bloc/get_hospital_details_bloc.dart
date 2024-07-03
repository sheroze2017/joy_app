import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_api.dart';
import 'package:joy_app/modules/pharmacy/models/create_product_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/view/home/navbar.dart';

import '../../../core/network/request.dart';

class HospitalDetailController extends GetxController {
  late DioClient dioClient;
  RxList<PharmacyModelData> hospitalPharmacies = <PharmacyModelData>[].obs;
  RxList<PharmacyModelData> hospitalDoctors = <PharmacyModelData>[].obs;
  RxList<PharmacyModelData> hospitalBloodBank = <PharmacyModelData>[].obs;

  late HospitalDetailsApi hospitalDetailsApi;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    hospitalDetailsApi = HospitalDetailsApi(dioClient);
  }

  Future<PharmacyModel> getAllDoctorPharmacies(
      String hospitalId, BuildContext context) async {
    try {
      PharmacyModel response =
          await hospitalDetailsApi.getAllHospitalPharmacy('6');
      if (response.data != null) {
        response.data!.forEach((element) {
          hospitalPharmacies.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<PharmacyModel> getAllDoctorHospital(
      String hospitalId, BuildContext context) async {
    try {
      PharmacyModel response =
          await hospitalDetailsApi.getAllHospitalDoctors('6');
      if (response.data != null) {
        response.data!.forEach((element) {
          hospitalDoctors.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }
}
