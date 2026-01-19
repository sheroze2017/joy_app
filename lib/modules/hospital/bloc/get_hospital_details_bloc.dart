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

  Future<PharmacyModel> getUnlinkedPharmacies(BuildContext context) async {
    hospitalPharmacies.clear();

    try {
      PharmacyModel response =
          await hospitalDetailsApi.getUnlinkedPharmacies();
      if (response.data != null) {
        response.data!.forEach((element) {
          hospitalPharmacies.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      print('Error fetching unlinked pharmacies: $error');
      showErrorMessage(context, 'Failed to load pharmacies: ${error.toString()}');
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

      // Use new linkOrDelinkHospital API
      bool success = await linkOrDelinkDoctorOrPharmacy(
          link_to_user_id, hospitalId, context);
      if (success) {
        // Close the confirmation dialog
        Get.back();
        // Navigate back from the selection screen (AllDoctorsScreen or AllDocPharmacy)
        Get.back();
        // Show success message after navigation completes
        Future.delayed(Duration(milliseconds: 300), () {
          if (Get.context != null) {
            showSuccessMessage(Get.context!, 'Linked successfully');
          }
        });
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
    unlinkLoader.value = true;
    try {
      // Use new linkOrDelinkHospital API with null hospital_id to delink
      bool success = await linkOrDelinkDoctorOrPharmacy(
          link_to_user_id, null, context);
      if (success) {
        // Close the confirmation dialog
        Get.back();
        // Show success message after dialog closes
        Future.delayed(Duration(milliseconds: 300), () {
          if (Get.context != null) {
            showSuccessMessage(Get.context!, 'Unlinked successfully');
          }
        });
      }
    } catch (error) {
      showErrorMessage(context, error.toString());
      unlinkLoader.value = false;
      throw (error);
    } finally {
      unlinkLoader.value = false;
    }
  }

  Future<bool> linkOrDelinkDoctorOrPharmacy(
      String userId, String? hospitalId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();
    linkLoader.value = true;
    try {
      final response =
          await hospitalDetailsApi.linkOrDelinkHospital(userId, hospitalId);

      // Backend sometimes returns "sucess" instead of "success"
      final bool isSuccessFlag =
          (response['success'] ?? response['sucess'] ?? false) == true;

      if (response['code'] == 200 && isSuccessFlag) {
        // Refresh hospital details to get updated list
        await getHospitalDetails(
            true, currentUser!.userId.toString(), context);
        // Success message will be shown in linkProfile/unLinkProfile after navigation
        linkLoader.value = false;
        return true;
      } else {
        showErrorMessage(context, response['message'] ?? 'Operation failed');
        linkLoader.value = false;
        return false;
      }
    } catch (error) {
      showErrorMessage(context, error.toString());
      linkLoader.value = false;
      return false;
    } finally {
      linkLoader.value = false;
    }
  }

  Future<void> linkPharmacy(String pharmacyId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();

    linkLoader.value = true;
    try {
      // When linking, only send pharmacy_id (isDelink = false)
      final response = await hospitalDetailsApi.linkOrDelinkPharmacy(pharmacyId, isDelink: false);

      // Backend sometimes returns "sucess" instead of "success"
      final bool isSuccessFlag =
          (response['success'] ?? response['sucess'] ?? false) == true;

      if (response['code'] == 200 && isSuccessFlag) {
        // Refresh hospital details to get updated list
        await getHospitalDetails(
            true, currentUser!.userId.toString(), context);
        // Close the confirmation dialog
        Get.back();
        // Navigate back from the selection screen
        Get.back();
        // Show success message after navigation completes
        Future.delayed(Duration(milliseconds: 300), () {
          if (Get.context != null) {
            showSuccessMessage(Get.context!, 'Pharmacy linked successfully');
          }
        });
        linkLoader.value = false;
      } else {
        showErrorMessage(context, response['message'] ?? 'Operation failed');
        linkLoader.value = false;
      }
    } catch (error) {
      showErrorMessage(context, error.toString());
      linkLoader.value = false;
    } finally {
      linkLoader.value = false;
    }
  }

  Future<void> delinkPharmacy(String pharmacyId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();

    linkLoader.value = true;
    try {
      // When delinking, send pharmacy_id and hospital_id: null (isDelink = true)
      final response = await hospitalDetailsApi.linkOrDelinkPharmacy(pharmacyId, isDelink: true);

      // Backend sometimes returns "sucess" instead of "success"
      final bool isSuccessFlag =
          (response['success'] ?? response['sucess'] ?? false) == true;

      if (response['code'] == 200 && isSuccessFlag) {
        // Refresh hospital details to get updated list
        await getHospitalDetails(
            true, currentUser!.userId.toString(), context);
        // Show success message
        showSuccessMessage(context, 'Pharmacy delinked successfully');
        linkLoader.value = false;
      } else {
        showErrorMessage(context, response['message'] ?? 'Operation failed');
        linkLoader.value = false;
      }
    } catch (error) {
      showErrorMessage(context, error.toString());
      linkLoader.value = false;
    } finally {
      linkLoader.value = false;
    }
  }
}
