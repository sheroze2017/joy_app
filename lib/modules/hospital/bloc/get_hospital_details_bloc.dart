import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_api.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';

import '../../../core/network/request.dart';
import '../../auth/utils/auth_hive_utils.dart';
import '../model/hospital_detail_model.dart';

class HospitalDetailController extends GetxController {
  late DioClient dioClient;
  RxList<PharmacyModelData> hospitalPharmacies = <PharmacyModelData>[].obs;
  RxList<PharmacyModelData> hospitalDoctors = <PharmacyModelData>[].obs;
  RxList<PharmacyModelData> hospitalBloodBank = <PharmacyModelData>[].obs;
  final hospitald = Rxn<hospitaldetail>();
  var hospitaldetailloader = false.obs;
  late HospitalDetailsApi hospitalDetailsApi;
  var linkLoader = false.obs;
  var unlinkLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    hospitalDetailsApi = HospitalDetailsApi(dioClient);
  }

  Future<PharmacyModel> getAllDoctorPharmacies(
      isHospital, String hospitalId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();
    hospitalPharmacies.clear();

    try {
      hospitalId = isHospital ? currentUser!.userId.toString() : hospitalId;

      PharmacyModel response =
          await hospitalDetailsApi.getAllHospitalPharmacy(hospitalId);
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
      bool isHospital, String hospitalId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();
    hospitalDoctors.clear();
    try {
      hospitalId = isHospital ? currentUser!.userId.toString() : hospitalId;
      PharmacyModel response =
          await hospitalDetailsApi.getAllHospitalDoctors(hospitalId);
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

  Future<HospitalDetail> getHospitalDetails(
      isHospital, String hospitalId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();

    hospitaldetailloader.value = true;
    try {
      hospitalId = isHospital ? currentUser!.userId.toString() : hospitalId;

      HospitalDetail response =
          await hospitalDetailsApi.getHospitalDetails(hospitalId);
      if (response.data != null) {
        hospitald.value = response.data;
        hospitaldetailloader.value = false;
      } else {
        hospitald.value = null;
        hospitaldetailloader.value = false;
      }
      return response;
    } catch (error) {
      hospitaldetailloader.value = false;

      throw (error);
    } finally {
      hospitaldetailloader.value = false;
    }
  }

  Future<void> linkProfile(String link_to_user_id, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();

    linkLoader.value = true;
    try {
      var hospitalId = currentUser!.userId.toString();

      Map<String, dynamic> response =
          await hospitalDetailsApi.linkHospital(hospitalId, link_to_user_id);
      if (response['data'] != null && response['code'] == 200) {
        Get.back();
        showSuccessMessage(context, 'Profile Link Successfully');
        linkLoader.value = false;
      } else {
        Get.back();
        showErrorMessage(context, response['message']);
        linkLoader.value = false;
      }
    } catch (error) {
      showErrorMessage(context, error.toString());
      linkLoader.value = false;
      throw (error);
    } finally {
      linkLoader.value = false;
    }
  }

  Future<void> unLinkProfile(
      String link_to_user_id, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();
    unlinkLoader.value = true;
    try {
      var hospitalId = currentUser!.userId.toString();

      Map<String, dynamic> response =
          await hospitalDetailsApi.linkHospital(hospitalId, link_to_user_id);
      if (response['data'] != null && response['code'] == 200) {
        Get.back();
        showSuccessMessage(context, 'Profile Unlinked Successfully');
        unlinkLoader.value = false;
      } else {
        showErrorMessage(context, response['message']);
        Get.back();
        unlinkLoader.value = false;
      }
    } catch (error) {
      showErrorMessage(context, error.toString());
      unlinkLoader.value = false;
      throw (error);
    } finally {
      unlinkLoader.value = false;
    }
  }
}
