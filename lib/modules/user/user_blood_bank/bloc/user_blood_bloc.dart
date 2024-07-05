import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_api.dart';
import 'package:joy_app/modules/user/user_blood_bank/model/all_bloodbank_model.dart';

import '../../../../Widgets/success_dailog.dart';
import '../../../blood_bank/bloc/blood_bank_api.dart';

class UserBloodBankController extends GetxController {
  late DioClient dioClient;
  late UserBloodBankApi userBloodBankApi;
  late BloodBankApi bloodBankApi;
  RxList<BloodRequest> allBloodRequest = <BloodRequest>[].obs;
  RxList<BloodRequest> allPlasmaRequest = <BloodRequest>[].obs;

  var showLoader = false.obs;
  RxList<BloodBank> bloodbank = <BloodBank>[].obs;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    bloodBankApi = BloodBankApi(dioClient);

    userBloodBankApi = UserBloodBankApi(dioClient);
  }

  Future<bool> createDonorUser(
      name, bloodGroup, location, gender, city, userId, context, type) async {
    showLoader.value = true;
    User? currentUser = await getCurrentUser();

    try {
      bool response = await userBloodBankApi.CreateDonor(name, bloodGroup,
          location, gender, city, currentUser!.userId.toString(), type);
      if (response == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              isBloodRequest: true,
              title: 'Congratulations!',
              content: 'Yor are successfully register as a donor',
              showButton: true,
              isBookAppointment: false,
            );
          },
        );
      } else {
        showErrorMessage(context, 'Error in creating you a donor');
      }
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<bool> createBloodAppeal(name, date, time, units, bloodGroup, gender,
      city, location, userId, bloodType, context) async {
    showLoader.value = true;
    User? currentUser = await getCurrentUser();

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
        showLoader.value = false;
      } else {
        showErrorMessage(context, 'Error creating ${bloodType} appeal');
        showLoader.value = false;
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
    try {
      bloodbank.clear();
      AllBloodBank response = await userBloodBankApi.getAllBloodBank();
      if (response.data != null) {
        response.data!.forEach((element) {
          bloodbank.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<AllBloodRequest> getAllBloodRequest() async {
    allBloodRequest.clear();
    allPlasmaRequest.clear();
    try {
      AllBloodRequest response = await bloodBankApi.getAllBloodRequest();
      if (response.data != null) {
        response.data!.forEach((element) {
          if (element.type == 'Plasma') {
            allPlasmaRequest.add(element);
          } else {
            allBloodRequest.add(element);
          }
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }
}
