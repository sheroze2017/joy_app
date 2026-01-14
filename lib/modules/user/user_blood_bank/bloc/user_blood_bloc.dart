import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_api.dart';
import 'package:joy_app/modules/user/user_blood_bank/model/all_bloodbank_model.dart';
import 'package:joy_app/widgets/dailog/success_dailog.dart';

import '../../../blood_bank/bloc/blood_bank_api.dart';

class UserBloodBankController extends GetxController {
  late DioClient dioClient;
  late UserBloodBankApi userBloodBankApi;
  late BloodBankApi bloodBankApi;
  RxList<BloodRequest> allBloodRequest = <BloodRequest>[].obs;
  RxList<BloodRequest> allPlasmaRequest = <BloodRequest>[].obs;
  RxList<BloodRequest> allMyRequest = <BloodRequest>[].obs;
  
  // Get all requests (both blood and plasma) for counting OPEN status
  List<BloodRequest> get allRequests => [...allBloodRequest, ...allPlasmaRequest];

  var showLoader = false.obs;
  RxList<BloodBank> bloodbank = <BloodBank>[].obs;
  RxList<BloodBank> searchResults = <BloodBank>[].obs;
  RxString searchQuery = ''.obs;
  var fetchBloodBank = false.obs;
  RxList<BloodDonor> allDonors = <BloodDonor>[].obs;
  RxList<BloodDonor> searchedDonors = <BloodDonor>[].obs;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    bloodBankApi = BloodBankApi(dioClient);

    userBloodBankApi = UserBloodBankApi(dioClient);
  }

  void searchBloodBanks(String query) {
    searchQuery.value = query;
    searchResults.assignAll(bloodbank
        .where((bloodBank) =>
            bloodBank.name!.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  Future<bool> createDonorUser(
      name, bloodGroup, location, gender, city, userId, context, type) async {
    showLoader.value = true;
    UserHive? currentUser = await getCurrentUser();

    try {
      bool response = await userBloodBankApi.CreateDonor(name, bloodGroup,
          location, gender, city, currentUser!.userId.toString(), type);
      if (response == true) {
        showLoader.value = false;
        // Reload donors list after successful registration
        await getAllDonors();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              isRegisterDonor: true,
              title: 'Congratulations!',
              content: 'Yor are successfully register as a donor',
              showButton: true,
              isBookAppointment: false,
            );
          },
        );
      } else {
        showLoader.value = false;
        showErrorMessage(context, 'Error in creating you a donor');
      }

      return response;
    } catch (error) {
      showLoader.value = false;
      throw (error);
    } finally {
      showLoader.value = false;
    }
  }

  Future<bool> createBloodAppeal(name, date, time, units, bloodGroup, gender,
      city, location, userId, bloodType, context) async {
    showLoader.value = true;
    UserHive? currentUser = await getCurrentUser();

    try {
      bool response = await userBloodBankApi.CreateBloodRequest(
          name,
          date,
          time,
          units,
          bloodGroup,
          gender,
          city,
          location,
          currentUser!.userId.toString(),
          bloodType);
      if (response == true) {
        showLoader.value = false;
        // Reload donors and blood requests after successful submission
        await getAllDonors();
        await getAllBloodRequest();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              isBloodRequest: true,
              title: 'Congratulations!',
              content:
                  'Your Appeal for ${bloodGroup} ${bloodType} has been submitted',
              showButton: true,
              isBookAppointment: false,
            );
          },
        );
      } else {
        showLoader.value = false;
        showErrorMessage(context, 'Error creating ${bloodType} appeal');
      }
      return response;
    } catch (error) {
      showLoader.value = false;
      throw (error);
    } finally {
      showLoader.value = false;
    }
  }

  Future<AllBloodBank> getAllBloodBank() async {
    fetchBloodBank.value = true;
    try {
      bloodbank.clear();
      AllBloodBank response = await userBloodBankApi.getAllBloodBank();
      if (response.data != null) {
        response.data!.forEach((element) {
          bloodbank.add(element);
        });
      } else {}
      fetchBloodBank.value = false;
      return response;
    } catch (error) {
      fetchBloodBank.value = false;
      throw (error);
    } finally {
      fetchBloodBank.value = false;
    }
  }

  Future<AllBloodRequest> getAllBloodRequest() async {
    UserHive? currentUser = await getCurrentUser();

    allBloodRequest.clear();
    allPlasmaRequest.clear();
    allMyRequest.clear();
    try {
      AllBloodRequest response = await bloodBankApi.getAllBloodRequest();
      if (response.data != null) {
        response.data!.forEach((element) {
          try {
            if (currentUser != null && currentUser.userId.toString() == element.userId?.toString()) {
              allMyRequest.add(element);
            }
            // Categorize by type: PLASMA goes to plasma, everything else (URGENT, NORMAL, PLATELET, REQUEST) goes to blood
            if (element.type?.toUpperCase() == 'PLASMA') {
              allPlasmaRequest.add(element);
            } else {
              // All other types (URGENT, NORMAL, PLATELET, REQUEST) are blood requests
              allBloodRequest.add(element);
            }
          } catch (e) {
            print('❌ [getAllBloodRequest] Error processing element: $e');
            print('   Element data: ${element.toJson()}');
          }
        });
      } else {}
      return response;
    } catch (error) {
      print('❌ [getAllBloodRequest] Error: $error');
      rethrow;
    } finally {}
  }

  Future<AllDonor> getAllDonors() async {
    allDonors.clear();
    try {
      AllDonor response = await bloodBankApi.getAllDonor();
      if (response.data != null) {
        response.data!.forEach((element) {
          allDonors.add(element);
        });
      }
      searchedDonors.assignAll(allDonors);
      return response;
    } catch (error) {
      throw (error);
    }
  }

  void searchDonors(String query) {
    if (query.isEmpty) {
      searchedDonors.assignAll(allDonors);
    } else {
      searchedDonors.assignAll(allDonors
          .where((donor) =>
              donor.name!.toLowerCase().contains(query.toLowerCase()) ||
              donor.bloodGroup!.toLowerCase().contains(query.toLowerCase()) ||
              donor.location!.toLowerCase().contains(query.toLowerCase()) ||
              donor.city!.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  Future<bool> deleteBloodRequest(String bloodId, BuildContext context) async {
    showLoader.value = true;
    try {
      bool response = await bloodBankApi.deleteBloodRequest(bloodId);
      if (response == true) {
        showLoader.value = false;
        // Remove from all lists
        allBloodRequest.removeWhere((req) => req.bloodId?.toString() == bloodId);
        allPlasmaRequest.removeWhere((req) => req.bloodId?.toString() == bloodId);
        allMyRequest.removeWhere((req) => req.bloodId?.toString() == bloodId);
        
        showSuccessMessage(context, 'Blood request deleted successfully');
        return true;
      } else {
        showLoader.value = false;
        showErrorMessage(context, 'Error deleting blood request');
        return false;
      }
    } catch (error) {
      showLoader.value = false;
      showErrorMessage(context, 'Error deleting blood request: ${error.toString()}');
      return false;
    } finally {
      showLoader.value = false;
    }
  }

  Future<bool> attachDonorToBloodRequest(String bloodRequestId, BuildContext context) async {
    showLoader.value = true;
    UserHive? currentUser = await getCurrentUser();
    try {
      if (currentUser == null) {
        showLoader.value = false;
        showErrorMessage(context, 'User not logged in');
        return false;
      }
      
      bool response = await bloodBankApi.attachDonorToBloodRequest(
        bloodRequestId,
        currentUser.userId.toString(),
      );
      if (response == true) {
        showLoader.value = false;
        showSuccessMessage(context, 'You have been attached as a donor successfully');
        // Reload blood requests to get updated data
        await getAllBloodRequest();
        return true;
      } else {
        showLoader.value = false;
        showErrorMessage(context, 'Error attaching donor');
        return false;
      }
    } catch (error) {
      showLoader.value = false;
      showErrorMessage(context, 'Error attaching donor: ${error.toString()}');
      return false;
    } finally {
      showLoader.value = false;
    }
  }

  Future<bool> detachDonorFromBloodRequest(String bloodRequestId, String userId, BuildContext context) async {
    showLoader.value = true;
    try {
      bool response = await bloodBankApi.detachDonorFromBloodRequest(
        bloodRequestId,
        userId,
      );
      if (response == true) {
        showLoader.value = false;
        showSuccessMessage(context, 'Donor attachment cancelled successfully');
        // Reload blood requests to get updated data
        await getAllBloodRequest();
        return true;
      } else {
        showLoader.value = false;
        showErrorMessage(context, 'Error detaching donor');
        return false;
      }
    } catch (error) {
      showLoader.value = false;
      showErrorMessage(context, 'Error detaching donor: ${error.toString()}');
      return false;
    } finally {
      showLoader.value = false;
    }
  }
}
