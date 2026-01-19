import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/blood_bank/bloc/blood_bank_api.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/blood_bank/model/blood_bank_details_model.dart';

import '../../auth/models/user.dart';

class BloodBankController extends GetxController {
  late DioClient dioClient;
  late BloodBankApi bloodBankApi;
  RxList<BloodDonor> allDonors = <BloodDonor>[].obs;
  RxList<BloodRequest> allBloodRequest = <BloodRequest>[].obs;
  RxList<BloodRequest> allPlasmaRequest = <BloodRequest>[].obs;
  RxList<BloodDonor> searchedDonors = <BloodDonor>[].obs;

  final _bloodBankDetails = Rxn<BloodBankDetails>();
  var appointmentLoader = false.obs;
  var bloodBankHomeLoader = false.obs;
  var editLoader = false.obs;
  var val = 0.0.obs;

  BloodBankDetails? get bloodBankDetail => _bloodBankDetails.value;
  ProfileController _profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    bloodBankApi = BloodBankApi(dioClient);
    if (_profileController.userRole.value == 'USER') {
      getallDonor();
    } else {
      getBloodBankDetail();
      getAllBloodRequest();
      getallDonor();
    }
  }

  void searchByBloodGroup(String bloodGroup) {
    if (bloodGroup.isEmpty) {
      searchedDonors.assignAll(allDonors);
    } else {
      final filtered = allDonors
          .where((donor) =>
              donor.bloodGroup!.toLowerCase().contains(bloodGroup.toLowerCase()))
          .toList();
      searchedDonors.assignAll(filtered);
    }
    print('🩸 [BloodBankController] searchByBloodGroup() - Found ${searchedDonors.length} donors');
  }

  // avgrating() async {
  //   doctorDetail!.data!.reviews!.forEach((element) {
  //     val.value = val.value +
  //         (double.parse(element.rating!) / doctorDetail!.data!.reviews!.length);
  //   });
  // }

  Future<AllDonor> getallDonor() async {
    allDonors.clear();
    searchedDonors.clear();
    try {
      AllDonor response = await bloodBankApi.getAllDonor();
      print('🩸 [BloodBankController] getallDonor() - Response received');
      print('🩸 [BloodBankController] Response data: ${response.data?.length ?? 0} donors');
      if (response.data != null && response.data!.isNotEmpty) {
        print('🩸 [BloodBankController] Adding ${response.data!.length} donors to allDonors');
        // Use assignAll instead of forEach/add to prevent duplicates
        allDonors.assignAll(response.data!);
        print('🩸 [BloodBankController] allDonors length after adding: ${allDonors.length}');
      } else {
        print('🩸 [BloodBankController] No donors in response data');
      }
      return response;
    } catch (error) {
      print('❌ [BloodBankController] getallDonor() error: $error');
      throw (error);
    } finally {
      // Use assignAll to properly copy the list
      searchedDonors.assignAll(allDonors);
      print('🩸 [BloodBankController] searchedDonors length: ${searchedDonors.length}');
    }
  }

  Future<BloodBankDetails> getBloodBankDetail() async {
    bloodBankHomeLoader.value = true;

    try {
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        print('❌ [BloodBankController] getBloodBankDetail() - No current user');
        bloodBankHomeLoader.value = false;
        // Return existing data if available, otherwise return empty
        return _bloodBankDetails.value ?? BloodBankDetails();
      }

      print('🩸 [BloodBankController] getBloodBankDetail() - Calling API for user: ${currentUser.userId}');
      BloodBankDetails response =
          await bloodBankApi.getBloodBankDetail(currentUser.userId.toString());
      
      print('🩸 [BloodBankController] getBloodBankDetail() - Response received');
      print('🩸 [BloodBankController] Response code: ${response.code}, success: ${response.sucess}');
      print('🩸 [BloodBankController] Response data: ${response.data != null ? "present" : "null"}');
      
      if (response.data != null) {
        _bloodBankDetails.value = response;
        print('✅ [BloodBankController] getBloodBankDetail() - Successfully set bloodBankDetail');
      } else {
        print('⚠️ [BloodBankController] getBloodBankDetail() - Response data is null');
        // Don't clear existing data if we have it, just log the warning
        if (_bloodBankDetails.value == null) {
          print('⚠️ [BloodBankController] getBloodBankDetail() - No existing data, keeping null');
        } else {
          print('✅ [BloodBankController] getBloodBankDetail() - Keeping existing data');
        }
      }
      return response;
    } catch (error) {
      print('❌ [BloodBankController] getBloodBankDetail() - Error: $error');
      print('❌ [BloodBankController] Error type: ${error.runtimeType}');
      print('❌ [BloodBankController] Stack trace: ${StackTrace.current}');
      // Don't clear existing data on error - return existing data if available
      if (_bloodBankDetails.value != null) {
        print('✅ [BloodBankController] getBloodBankDetail() - Returning existing data despite error');
        return _bloodBankDetails.value!;
      }
      // Only return empty if we have no existing data
      return BloodBankDetails();
    } finally {
      bloodBankHomeLoader.value = false;
    }
  }

  Future<AllBloodRequest> getAllBloodRequest() async {
    allBloodRequest.clear();
    allPlasmaRequest.clear();
    try {
      AllBloodRequest response = await bloodBankApi.getAllBloodRequest();
      print('📥 [BloodBankController] getAllBloodRequest response: ${response.data?.length ?? 0} items');
      if (response.data != null) {
        response.data!.forEach((element) {
          final type = element.type?.toUpperCase() ?? '';
          print('📥 [BloodBankController] Processing request: type=$type, status=${element.status}');
          // Filter by type: PLASMA goes to plasma requests, everything else to blood requests
          if (type == 'PLASMA') {
            allPlasmaRequest.add(element);
            print('📥 [BloodBankController] Added to plasmaRequest list');
          } else {
            // URGENT, NORMAL, REQUEST, PLATELET, etc. all go to blood requests
            allBloodRequest.add(element);
            print('📥 [BloodBankController] Added to allBloodRequest list');
          }
        });
        print('📥 [BloodBankController] Final counts - Blood: ${allBloodRequest.length}, Plasma: ${allPlasmaRequest.length}');
      } else {
        print('📥 [BloodBankController] Response data is null');
      }
      return response;
    } catch (error) {
      print('❌ [BloodBankController] Error in getAllBloodRequest: $error');
      throw (error);
    } finally {}
  }

  Future<bool> attachDonorToBloodRequest(String bloodRequestId, BuildContext context) async {
    try {
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        print('❌ [BloodBankController] User not logged in');
        return false;
      }
      
      bool response = await bloodBankApi.attachDonorToBloodRequest(
        bloodRequestId,
        currentUser.userId.toString(),
      );
      if (response == true) {
        print('✅ [BloodBankController] Donor attached successfully');
        // Reload blood requests to get updated data
        await getAllBloodRequest();
        return true;
      } else {
        print('❌ [BloodBankController] Error attaching donor');
        return false;
      }
    } catch (error) {
      print('❌ [BloodBankController] Error attaching donor: $error');
      return false;
    }
  }

  Future<bool> updateAbout(String about, BuildContext context) async {
    appointmentLoader.value = true;
    UserHive? currentUser = await getCurrentUser();
    try {
      if (currentUser == null) {
        appointmentLoader.value = false;
        showErrorMessage(context, 'User not logged in');
        return false;
      }

      bool response = await bloodBankApi.updateAbout(
        currentUser.userId.toString(),
        about,
      );
      if (response == true) {
        appointmentLoader.value = false;
        showSuccessMessage(context, 'About updated successfully');
        await getBloodBankDetail(); // Refresh blood bank details
        return true;
      } else {
        appointmentLoader.value = false;
        showErrorMessage(context, 'Error updating about');
        return false;
      }
    } catch (error) {
      appointmentLoader.value = false;
      showErrorMessage(context, 'Error updating about: ${error.toString()}');
      return false;
    }
  }

  Future<bool> updateTimings(String timings, BuildContext context) async {
    appointmentLoader.value = true;
    UserHive? currentUser = await getCurrentUser();
    try {
      if (currentUser == null) {
        appointmentLoader.value = false;
        showErrorMessage(context, 'User not logged in');
        return false;
      }

      bool response = await bloodBankApi.updateTimings(
        currentUser.userId.toString(),
        timings,
      );
      if (response == true) {
        appointmentLoader.value = false;
        showSuccessMessage(context, 'Timings updated successfully');
        await getBloodBankDetail(); // Refresh blood bank details
        return true;
      } else {
        appointmentLoader.value = false;
        showErrorMessage(context, 'Error updating timings');
        return false;
      }
    } catch (error) {
      appointmentLoader.value = false;
      showErrorMessage(context, 'Error updating timings: ${error.toString()}');
      return false;
    }
  }
}
